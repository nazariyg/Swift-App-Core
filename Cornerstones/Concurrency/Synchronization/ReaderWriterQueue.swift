// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

/// Allows for fast state access synchronization using a concurrent queue, on which state reading operations are isolated from state writing operations,
/// and with performance optimizations for recursive calls.
public final class ReaderWriterQueue {

    private let queue: DispatchQueue
    private let queueTag = DispatchSpecificKey<String>()

    // MARK: - Lifecycle

    public init(qos: DispatchQoS, labelSuffix: String = "", filePath: String = #file) {
        let label = DispatchQueue.uniqueQueueLabel(labelSuffix: labelSuffix, filePath: filePath)
        queue = DispatchQueue(label: label, attributes: .concurrent)
        queue.setSpecific(key: queueTag, value: label)
    }

    public init(label: String) {
        queue = DispatchQueue(label: label, attributes: .concurrent)
        queue.setSpecific(key: queueTag, value: label)
    }

    deinit {
        queue.setSpecific(key: queueTag, value: nil)
    }

    // MARK: - Reading and writing

    public func read<ReturnType>(_ work: ThrowingReturningClosure<ReturnType>) rethrows -> ReturnType {
        if isRecursive {
            return try work()
        } else {
            return try queue.sync(execute: work)
        }
    }

    public func write(_ work: @escaping VoidClosure) {
        if isRecursive {
            work()
        } else {
            queue.async(flags: .barrier, execute: work)
        }
    }

    // MARK: - Private

    private var isRecursive: Bool {
        return DispatchQueue.getSpecific(key: queueTag) == queue.label
    }

}
