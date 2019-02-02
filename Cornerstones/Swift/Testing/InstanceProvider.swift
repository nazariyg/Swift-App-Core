// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

/// The protocol to be adopted by any input-to-output mapper.
public protocol InputOutputMapper {
    associatedtype Input
    associatedtype Output
    func map(input: Input) -> Output?
}

public final class InstanceProvider {

    public static let shared = InstanceProvider()

    // MARK: - Nested types

    /// Represents the output instance produced from an input, along with an optional time delay.
    public struct OutputResult<Output> {
        public let output: Output
        public let delay: TimeInterval?
    }

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Instance construction injection

    /// Sets a replacement instance to be used when constructing an instance conforming to a specific protocol.
    public func setInstance<InstanceProtocol>(for: InstanceProtocol.Type, instance: InstanceProtocol) {
        assert(TestingDetector.isTesting)
        synchronized(self) {
            let key = fullStringType(InstanceProtocol.self)
            storeStates[storeStates.lastIndex].stringTypesToInstances[key] = instance
        }
    }

    /// Dynamically selects the instance for a specific protocol from a mutable store or uses the provided default instance if no instance has been set
    /// for that protocol in the store. Called when accessing shared instances and by the rest of the code that supports this kind of dependency injection.
    public func instance<InstanceProtocol>(for: InstanceProtocol.Type, defaultInstance: InstanceProtocol) -> InstanceProtocol {
        return synchronized(self) {
            let key = fullStringType(InstanceProtocol.self)
            let setInstance = storeStates[storeStates.lastIndex].stringTypesToInstances[key] as? InstanceProtocol
            return setInstance ?? defaultInstance
        }
    }

    // MARK: - Input/output injection

    /// Registers an input-to-output mapper that takes in an input and optionally produces an output instance to be used as the substitute.
    /// If the mapper returns `nil`, no substitution happens and the code goes its usual course.
    public func registerInputOutputMapper<Mapper: InputOutputMapper>(mapper: Mapper, outputDelay: TimeInterval? = nil) {
        assert(TestingDetector.isTesting)
        synchronized(self) {
            let key = Self.keyForInputOutputTypes(inputType: Mapper.Input.self, outputType: Mapper.Output.self)
            let mapClosure: InstanceStore.MapperRecord.MapClosure = { input in
                let typedInput = input as! Mapper.Input
                let output = mapper.map(input: typedInput)
                return output
            }
            let mapperRecord = InstanceStore.MapperRecord(mapClosure: mapClosure, delay: outputDelay)
            storeStates[storeStates.lastIndex].stringTypesToInputOutputMappers[key] = mapperRecord
        }
    }

    /// Returns the replacement output instance for a given input, if any mappers are registered for the combination of the two types.
    /// Called e.g. when making HTTP requests to see if any HTTP response mappers have been registered.
    public func outputForInput<Input, Output>(_ input: Input, outputType: Output.Type = Output.self) -> OutputResult<Output>? {
        if TestingDetector.isNotTesting {
            return nil
        }
        return synchronized(self) {
            let key = Self.keyForInputOutputTypes(inputType: Input.self, outputType: Output.self)
            if let mapperRecord = storeStates[storeStates.lastIndex].stringTypesToInputOutputMappers[key] {
                if let output = mapperRecord.mapClosure(input) {
                    let output = output as! Output
                    return OutputResult(output: output, delay: mapperRecord.delay)
                }
            }
            return nil
        }
    }

    // MARK: - State operations

    /// Pushes a copy of the instance store.
    public func pushState() {
        synchronized(self) {
            let stateCopy = storeStates.last!
            storeStates.append(stateCopy)
        }
    }

    /// Pops the last pushed copy of the instance store.
    public func popState() {
        synchronized(self) {
            assert(storeStates.count > 1)
            storeStates.removeLast()
        }
    }

    /// Resets the instance store.
    public func resetState() {
        synchronized(self) {
            storeStates = [InstanceStore()]
        }
    }

    // MARK: - Private

    private typealias `Self` = InstanceProvider

    private struct InstanceStore {

        struct MapperRecord {
            typealias MapClosure = (Any) -> Any?
            let mapClosure: MapClosure
            let delay: TimeInterval?
        }

        var stringTypesToInstances: [String: Any] = [:]
        var stringTypesToInputOutputMappers: [String: MapperRecord] = [:]

    }

    private var storeStates: [InstanceStore] = [InstanceStore()]

    private static func keyForInputOutputTypes<Input, Output>(inputType: Input.Type, outputType: Output.Type) -> String {
        let key = "\(fullStringType(Input.self)) -> \(fullStringType(Output.self))"
        return key
    }

}
