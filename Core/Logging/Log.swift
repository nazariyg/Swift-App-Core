// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import SwiftyBeaver

// Logging utility based on SwiftyBeaver.

// Global log instance.
public let log = Log()

public struct Log {

    public static let consoleMinLogLevel: SwiftyBeaver.Level = .verbose
    public static let fileMinLogLevel: SwiftyBeaver.Level = .info

    private let logger = SwiftyBeaver.self

    fileprivate init() {
        logger.addDestination(Self.consoleDestination)
        logger.addDestination(Self.fileDestination)
    }

    // MARK: - Messaging

    public func error(_ message: String, _ category: String?) {
        let preparedMessage = Self.preparedMessage(message, category: category)
        logger.error(preparedMessage)
        LogManager.shared.logDidUpdate()
    }

    public func warning(_ message: String, _ category: String?) {
        let preparedMessage = Self.preparedMessage(message, category: category)
        logger.warning(preparedMessage)
        LogManager.shared.logDidUpdate()
    }

    public func info(_ message: String, _ category: String?) {
        let preparedMessage = Self.preparedMessage(message, category: category)
        logger.info(preparedMessage)
        LogManager.shared.logDidUpdate()
    }

    public func debug(_ message: String, _ category: String?) {
        let preparedMessage = Self.preparedMessage(message, category: category)
        logger.debug(preparedMessage)
        LogManager.shared.logDidUpdate()
    }

    public func verbose(_ message: String, _ category: String?) {
        let preparedMessage = Self.preparedMessage(message, category: category)
        logger.verbose(preparedMessage)
        LogManager.shared.logDidUpdate()
    }

    public func appInfo() {
        let message = Self.appInfo
        info(message, nil)
        LogManager.shared.logDidUpdate()
    }

    public func infoInvocation(_ filePath: String = #file, functionName: String = #function) {
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        let message = "[INVOCATION] \(fileName): \(functionName)"
        info(message, nil)
    }

    public func debugInvocation(_ filePath: String = #file, functionName: String = #function) {
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        let message = "[INVOCATION] \(fileName): \(functionName)"
        debug(message, nil)
    }

    public func verboseInvocation(_ filePath: String = #file, functionName: String = #function) {
        let fileName = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
        let message = "[INVOCATION] \(fileName): \(functionName)"
        verbose(message, nil)
    }

    // MARK: - Private

    private typealias `Self` = Log

    private static var consoleDestination: ConsoleDestination {
        let consoleDestination = ConsoleDestination()
        consoleDestination.minLevel = consoleMinLogLevel
        consoleDestination.format = "$DHH:mm:ss$d $L $M"
        consoleDestination.levelString.error = "🔴 [ERROR]"
        consoleDestination.levelString.warning = "⭕ [WARNING]"
        consoleDestination.levelString.info = "🔵 [INFO]"
        consoleDestination.levelString.debug = "⚪ [DEBUG]"
        consoleDestination.levelString.verbose = "⚫ [VERBOSE]"
        return consoleDestination
    }

    private static var fileDestination: FileDestination {
        let fileDestination = FileDestination()
        fileDestination.logFileURL = logFileURL()
        fileDestination.minLevel = fileMinLogLevel
        return fileDestination
    }

    private static func logFileURL() -> URL {
        let logDirectoryURL = FileManager.documentsURL.appendingPathComponent("log", isDirectory: true)
        try? FileManager.default.createDirectory(at: logDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        let logFileName = "\(Bundle.mainBundleID).log"
        let logFileURL = logDirectoryURL.appendingPathComponent(logFileName, isDirectory: false)
        return logFileURL
    }

    private static func preparedMessage(_ message: String, category: String? = nil) -> String {
        var message = identedMessage(message)
        if let category = category {
            message = messageWithCategory(message, category: category)
        }
        message = messageWithAppState(message)
        return message
    }

    private static func identedMessage(_ message: String) -> String {
        let identedMessage = message.replacingOccurrences(of: "\n", with: "\n  ")
        return identedMessage
    }

    private static func messageWithCategory(_ message: String, category: String) -> String {
        let messageWithCategory = "[\(category.uppercased())] \(message)"
        return messageWithCategory
    }

    private static func messageWithAppState(_ message: String) -> String {
        var messageWithAppState = message
        if App.shared.isBackgrounded {
            messageWithAppState = "[BACKGROUND] \(message)"
        }
        return messageWithAppState
    }

    private static let appInfo: String = {
        return DispatchQueue.main.executeSync {
            var infoString = ""
            infoString += "App version: \(App.shared.version)"
            infoString += ", iOS version: \(UIDevice.current.iosVersion)"
            infoString += ", device model: \(UIDevice.current.modelName)"
            return infoString
        }
    }()

}
