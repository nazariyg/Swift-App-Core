// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import ReactiveSwift
import Alamofire

private let logCategory = "Network"

extension SessionManager: ReactiveExtensionsProvider {}

public extension Reactive where Base: SessionManager {

    // MARK: - Streaming status types

    public enum DownloadStatus {
        case inProgress(progress: Double)
        case completed(fileURL: URL)
    }

    public enum UploadStatus {
        case inProgress(progress: Double)
        case completed
    }

    // MARK: - Making requests

    /// Reactively makes an HTTP request for the specified payload type expected in the response.
    /// Possible payload types are: `Data`, `JSONDictionary`, and `JSONArray`.
    func making<ResponsePayload>(
        request: HTTPRequest, for _: ResponsePayload.Type, acceptForValidation: [HTTPContentType] = []) -> SpEr<HTTPResponse<ResponsePayload>> {

        // Output injection.
        if let injectedOutputResult = InstanceProvider.shared.outputForInput(request, outputType: HTTPResponse<ResponsePayload>.self) {
            var signalProducer = SpEr(value: injectedOutputResult.output)
            if let delay = injectedOutputResult.delay {
                signalProducer = signalProducer.delay(delay, on: QueueScheduler.main)
            }
            return signalProducer
        }

        return
            SpEr { [weak base] emitter, lifetime in
                guard let sessionManager = base else {
                    emitter.sendInterrupted()
                    return
                }

                let urlRequest = request.asURLRequest(usingSessionManager: sessionManager)
                var afRequest = sessionManager.request(urlRequest)

                if acceptForValidation.isNotEmpty {
                    let contentTypes = acceptForValidation.map { $0.string }
                    afRequest = afRequest.validate(contentType: contentTypes)
                }

                let requestHasSensitiveData = request.hasSensitiveData.map { $0 } ?? false
                log.debug("Making an HTTP request: \(!requestHasSensitiveData ? request.description : request.safeDescription)", logCategory)

                // Data.
                if Data.self is ResponsePayload.Type {
                    let afActiveRequest = afRequest.responseData { afResponse in
                        log.debug("Received a response from \(request.url)", logCategory)
                        if Config.shared.general.logHTTPResponseData {
                            afResponse.data
                                .flatMap { $0.count <= Config.shared.general.maxHTTPResponseDataSizeForLogging ? $0.string : nil }
                                .map { log.verbose("HTTP response data: \($0)", logCategory) }
                        }

                        let anyErrors = Self.processURLResponseCodeForErrors(afResponse.response, error: afResponse.error, emitter: emitter)
                        if anyErrors {
                            return
                        }

                        switch afResponse.result {
                        case let .success(value):
                            if let urlResponse = afResponse.response {
                                let responseHeaders = Self.responseHeaders(fromURLResponse: urlResponse)
                                let response =
                                    HTTPResponse<ResponsePayload>(
                                        payload: value as! ResponsePayload, headers: responseHeaders, urlResponse: urlResponse, request: request)
                                emitter.send(value: response)
                                emitter.sendCompleted()
                            } else {
                                let error: E = .unknown
                                log.error(error.description, logCategory)
                                emitter.send(error: error)
                            }
                        case let .failure(afError):
                            let error = E(afError)
                            log.error(error.description, logCategory)
                            emitter.send(error: error)
                        }
                    }

                    lifetime.observeEnded {
                        afActiveRequest.cancel()
                    }

                    // Start the request.
                    afRequest.resume()

                    return
                }

                // JSON.
                if JSONDictionary.self is ResponsePayload.Type ||
                   JSONArray.self is ResponsePayload.Type {

                    let afActiveRequest = afRequest.responseJSON { afResponse in
                        log.debug("Received a response from \(request.url)", logCategory)

                        let anyErrors = Self.processURLResponseCodeForErrors(afResponse.response, error: afResponse.error, emitter: emitter)
                        if anyErrors {
                            return
                        }

                        switch afResponse.result {
                        case let .success(value):
                            if let urlResponse = afResponse.response {
                                var jsonValue: Any?
                                if JSONDictionary.self is ResponsePayload.Type {
                                    jsonValue = value as? JSONDictionary
                                } else if JSONArray.self is ResponsePayload.Type {
                                    jsonValue = value as? JSONArray
                                }
                                guard let json = jsonValue else {
                                    let error: E = .unexpectedHTTPResponsePayload
                                    log.error(error.description, logCategory)
                                    emitter.send(error: error)
                                    return
                                }

                                let responseHeaders = Self.responseHeaders(fromURLResponse: urlResponse)
                                let response =
                                    HTTPResponse<ResponsePayload>(
                                        payload: json as! ResponsePayload, headers: responseHeaders, urlResponse: urlResponse, request: request)
                                emitter.send(value: response)
                                emitter.sendCompleted()
                            } else {
                                let error: E = .unknown
                                log.error(error.description, logCategory)
                                emitter.send(error: error)
                            }
                        case let .failure(afError):
                            let error = E(afError)
                            log.error(error.description, logCategory)
                            emitter.send(error: error)
                        }
                    }

                    lifetime.observeEnded {
                        afActiveRequest.cancel()
                    }

                    // Start the request.
                    afRequest.resume()

                    return
                }

                assertionFailure("Unknown response payload")
            }
    }

    /// Reactively makes a file downloading from a URL.
    func downloading(url: URL, acceptForValidation: [HTTPContentType] = []) -> SpEr<DownloadStatus> {
        return
            SpEr { [weak base] emitter, lifetime in
                guard let sessionManager = base else {
                    emitter.sendInterrupted()
                    return
                }

                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let destinationFileURL = FileManager.generateTemporaryFileURL()
                    return (destinationFileURL, [.removePreviousFile, .createIntermediateDirectories])
                }

                var afRequest = sessionManager.download(url, to: destination)

                if acceptForValidation.isNotEmpty {
                    let contentTypes = acceptForValidation.map { $0.string }
                    afRequest = afRequest.validate(contentType: contentTypes)
                }

                // Progress.
                afRequest.downloadProgress { progress in
                    emitter.send(value: .inProgress(progress: progress.fractionCompleted))
                }

                log.debug("Making a file downloading request to \(url)", logCategory)

                let afActiveRequest = afRequest.response { afResponse in
                    log.debug("Received a response from \(url)", logCategory)

                    let anyErrors = Self.processURLResponseCodeForErrors(afResponse.response, error: afResponse.error, emitter: emitter)
                    if anyErrors {
                        return
                    }

                    if let afError = afResponse.error {
                        let error = E(afError)
                        log.error(error.description, logCategory)
                        emitter.send(error: error)
                        return
                    }

                    if var fileURL = afResponse.destinationURL {
                        // Completed.

                        if let urlResponse = afResponse.response {
                            let responseHeaders = Self.responseHeaders(fromURLResponse: urlResponse)
                            let contentType = responseHeaders[HTTPHeader.Response.contentType].flatMap { HTTPContentType(contentTypeString: $0) }
                            if let contentType = contentType {
                                // Rename the file to match its content type.
                                let newFileURL = FileManager.generateTemporaryFileURL(forMimeType: contentType)
                                if (try? FileManager.default.moveItem(at: fileURL, to: newFileURL)) != nil {
                                    fileURL = newFileURL
                                }
                            }
                        }

                        emitter.send(value: .completed(fileURL: fileURL))
                        emitter.sendCompleted()
                    } else {
                        let error: E = .unknown
                        log.error(error.description, logCategory)
                        emitter.send(error: error)
                    }
                }

                lifetime.observeEnded {
                    afActiveRequest.cancel()
                }

                // Start the request.
                afRequest.resume()
            }
    }

    /// Reactively makes a file uploading to a URL.
    func uploadingFile(withURL fileURL: URL, toURL url: URL) -> SpEr<UploadStatus> {
        return
            SpEr { [weak base] emitter, lifetime in
                guard let sessionManager = base else {
                    emitter.sendInterrupted()
                    return
                }

                let afRequest = sessionManager.upload(fileURL, to: url)

                // Progress.
                afRequest.uploadProgress { progress in
                    emitter.send(value: .inProgress(progress: progress.fractionCompleted))
                }

                log.debug("Making a file uploading request to \(url)", logCategory)

                let afActiveRequest = afRequest.response { afResponse in
                    log.debug("Received a response from \(url)", logCategory)

                    let anyErrors = Self.processURLResponseCodeForErrors(afResponse.response, error: afResponse.error, emitter: emitter)
                    if anyErrors {
                        return
                    }

                    if let afError = afResponse.error {
                        let error = E(afError)
                        log.error(error.description, logCategory)
                        emitter.send(error: error)
                        return
                    }

                    // Completed.
                    emitter.send(value: .completed)
                    emitter.sendCompleted()
                }

                lifetime.observeEnded {
                    afActiveRequest.cancel()
                }

                // Start the request.
                afRequest.resume()
            }
    }

    /// Reactively makes a data uploading to a URL.
    func uploadingData(_ data: @autoclosure @escaping () -> Data, toURL url: URL) -> SpEr<UploadStatus> {
        return
            SpEr { [weak base] emitter, lifetime in
                guard let sessionManager = base else {
                    emitter.sendInterrupted()
                    return
                }

                let afRequest = sessionManager.upload(data(), to: url)

                // Progress.
                afRequest.uploadProgress { progress in
                    emitter.send(value: .inProgress(progress: progress.fractionCompleted))
                }

                log.debug("Making a data uploading request to \(url)", logCategory)

                let afActiveRequest = afRequest.response { afResponse in
                    log.debug("Received a response from \(url)", logCategory)

                    let anyErrors = Self.processURLResponseCodeForErrors(afResponse.response, error: afResponse.error, emitter: emitter)
                    if anyErrors {
                        return
                    }

                    if let afError = afResponse.error {
                        let error = E(afError)
                        log.error(error.description, logCategory)
                        emitter.send(error: error)
                        return
                    }

                    // Completed.
                    emitter.send(value: .completed)
                    emitter.sendCompleted()
                }

                lifetime.observeEnded {
                    afActiveRequest.cancel()
                }

                // Start the request.
                afRequest.resume()
            }
    }

    // MARK: - Specializations

    func makingForData(request: HTTPRequest, acceptForValidation: [HTTPContentType] = []) -> SpEr<HTTPDataResponse> {
        return making(request: request, for: Data.self, acceptForValidation: acceptForValidation)
    }

    // MARK: - Private

    private typealias `Self` = Reactive

    private static func processURLResponseCodeForErrors<ResponsePayload>(
        _ urlResponse: HTTPURLResponse?, error: Error?, emitter: ObEr<ResponsePayload>) -> Bool {

        if let statusCodeInt = urlResponse?.statusCode {
            let statusCode = HTTPStatusCode(statusCodeInt)

            if statusCode == .unauthorized {
                let error: E = .notAuthenticated
                log.error(error.description, logCategory)
                emitter.send(error: error)
                return true
            }

            if statusCode.isServerError && Config.shared.general.acknowledgeServerErrors {
                let error: E = .serverError
                log.error(error.description, logCategory)
                emitter.send(error: error)
                return true
            }

            if statusCode == .notFound && Config.shared.general.acknowledgeHTTPResponseNotFoundErrors {
                let error: E = .networkResponseNotFound
                log.error(error.description, logCategory)
                emitter.send(error: error)
                return true
            }

            if statusCode.isError && Config.shared.general.acknowledgeHTTPResponseErrorCodes {
                let error: E = .httpErrorCode
                log.error(error.description, logCategory)
                emitter.send(error: error)
                return true
            }
        }

        if let error = error as? AFError {
            if case .responseValidationFailed = error {
                let error: E = .unexpectedHTTPResponseContentType
                log.error(error.description, logCategory)
                emitter.send(error: error)
                return true
            }
        }

        return false
    }

    private static func responseHeaders(fromURLResponse urlResponse: HTTPURLResponse) -> [HTTPHeader.Response: String] {
        let responseHeaders =
            Dictionary(uniqueKeysWithValues:
                urlResponse.allHeaderFields.compactMap { key, value -> (HTTPHeader.Response, String)? in
                    guard let keyString = key as? String else { return nil }
                    guard let valueString = value as? String else { return nil }
                    guard let header = HTTPHeader.Response(headerName: keyString) else { return nil }
                    return (header, valueString)
                })
        return responseHeaders
    }

}
