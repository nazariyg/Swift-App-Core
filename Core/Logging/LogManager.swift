// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import SwiftyBeaver

private let logCategory = "Logging"

public final class LogManager {

    public static let shared = LogManager()

    private static let logRotationMaxFileSizeMegabytes = 8
    private static let logRotationConsideringNumUpdatesModulo = 256

    private let queue = DispatchQueue.fileSpecificSerialQueue(qos: .background)
    private let logger = SwiftyBeaver.self
    private var logUpdateCounter = 0

    private init() {}

    func logDidUpdate() {
        // Serialize file operations while offloading potentially heavy work onto a background queue.
        queue.executeAsync { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.logUpdateCounter += 1
            guard strongSelf.logUpdateCounter % Self.logRotationConsideringNumUpdatesModulo == 0 else { return }
            strongSelf.logUpdateCounter = 0
            strongSelf.rotateLogFileIfNeeded()
        }
    }

    public func readLogFile() -> String {
        log.debug("Reading the log file", logCategory)

        let url =
            logger.destinations
                .compactMap { $0 as? FileDestination }
                .first?.logFileURL
        guard let logFileURL = url else { return "" }
        guard let data = try? Data(contentsOf: logFileURL) else { return "" }
        guard let content = String(data: data, encoding: .utf8) else { return "" }
        return content
    }

    // MARK: - Private

    private typealias `Self` = LogManager

    private func rotateLogFileIfNeeded() {
        logger.destinations
            .compactMap { $0 as? FileDestination }
            .forEach { fileDestination in
                guard let logFileURL = fileDestination.logFileURL else { return }
                guard let fileSize = FileManager.default.fileSize(ofFileAtURL: logFileURL) else { return }
                if fileSize.megabytes > Double(Self.logRotationMaxFileSizeMegabytes) {
                    rotateLogFile(atURL: logFileURL, fileDestination: fileDestination)
                }
        }
    }

    private func rotateLogFile(atURL fileURL: URL, fileDestination: FileDestination) {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let start = UInt64(data.endIndex) - FileSize(megabytes: UInt64(Self.logRotationMaxFileSizeMegabytes)).bytes
        guard start >= 0 else { return }
        let startIndex = Data.Index(start)
        let range = startIndex..<data.endIndex
        let newLogData = data[range]

        let dateString = DateFormatter.utc.string(from: Date())
        let rolledMessage = "[Log rotated at \(dateString)]\n\n"
        let rolledMessageData = rolledMessage.data(using: .utf8)!

        var newData = Data()
        newData.append(rolledMessageData)
        newData.append(newLogData)

        if fileDestination.deleteLogFile() {
            do {
                try newData.write(to: fileURL, options: .atomic)
                log.debug("Rotated the log file", logCategory)
            } catch {
                log.error("Error rotating the log file: could not write the new data", logCategory)
            }
        } else {
            log.error("Error rotating the log file: could not delete the old file", logCategory)
        }
    }

}
