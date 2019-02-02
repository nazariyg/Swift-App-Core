// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import Alamofire

// Converting to URLRequest, via Alamofire.

extension HTTPRequest {

    public func asURLRequest(usingSessionManager sessionManager: SessionManager) -> URLRequest {
        let afMethod = method.afMethod

        var afParameters: Parameters?
        if let parameters = parameters {
            afParameters = parameters.keyValues
        }

        var afParameterEncoding: ParameterEncoding = URLEncoding.default
        if let parameters = parameters {
            switch parameters.placement {
            case .urlQueryString:
                afParameterEncoding = URLEncoding.queryString
            case let .body(encoding):
                switch encoding {
                case .url:
                    afParameterEncoding = URLEncoding.httpBody
                case .json:
                    afParameterEncoding = JSONEncoding.default
                }
            case .auto:
                assertionFailure()
            }
        }

        var afHeaders: HTTPHeaders?
        if headers.isNotEmpty {
            afHeaders = Dictionary(uniqueKeysWithValues: headers.map { key, value in (key.value, value) })
        }

        // Let Alamofire do the job of parameter encoding, setting headers, etc.
        let afRequest =
            sessionManager.request(
                url,
                method: afMethod,
                parameters: afParameters,
                encoding: afParameterEncoding,
                headers: afHeaders)
        var urlRequest = afRequest.request!

        if let cachePolicy = cachePolicy {
            urlRequest.cachePolicy = cachePolicy
        }

        if let timeoutInterval = timeoutInterval {
            urlRequest.timeoutInterval = timeoutInterval
        }

        return urlRequest
    }

}

private extension HTTPRequestMethod {

    var afMethod: HTTPMethod {
        switch self {
        case .get: return .get
        case .head: return .head
        case .post: return .post
        case .put: return .put
        case .delete: return .delete
        case .trace: return .trace
        case .options: return .options
        case .connect: return .connect
        case .patch: return .patch
        }
    }

}
