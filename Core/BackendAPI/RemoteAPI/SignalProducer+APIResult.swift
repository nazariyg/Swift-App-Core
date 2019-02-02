// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Cornerstones
import ReactiveSwift
import Result
import SwiftProtobuf

public typealias NoValue = Void?

private let protobufLogCategory = "Protobuf"
private let apiLogCategory = "API"

public extension SignalProducer where Value == HTTPDataResponse, Error == E {

    /// Reactively makes a protobuf request for the specified protobuf API entity type as the response's payload wrapped in `APIResult`.
    /// Sends an error event in case of the result signifies such.
    func entity<Entity: SwiftProtobuf.Message>(for: Entity.Type) -> SpEr<Entity> {
        return
            protobuf(for: APIResult.self)
            .attemptMap { result -> ReEr<Data> in
                switch result.type {
                case .success:
                    return .success(result.payload)
                case .failure:
                    let error = E(errorID: result.error.errorID)
                    log.error(error.description, apiLogCategory)
                    return .failure(error)
                }
            }
            .flatMap(.latest) { payload -> SpEr<Entity> in
                SpEr(value: payload)
                .start(on: QueueScheduler.protobufMessageDeserialization)
                .attemptMap { payload -> ReEr<Entity> in
                    let entity = try? Entity(serializedData: payload)
                    if let entity = entity {
                        return .success(entity)
                    } else {
                        log.error("Could not deserialize an API result", protobufLogCategory)
                        return .failure(.apiEntityDeserializationError)
                    }
                }
            }
    }

    /// Reactively makes a protobuf request for `APIPayloadlessResult`. Sends an error event in case of the result signifies such.
    func payloadlessResult() -> SpEr<APIPayloadlessResult> {
        return
            protobuf(for: APIPayloadlessResult.self)
            .attemptMap { result -> ReEr<APIPayloadlessResult> in
                switch result.type {
                case .success:
                    return .success(result)
                case .failure:
                    let error = E(errorID: result.error.errorID)
                    log.error(error.description, apiLogCategory)
                    return .failure(error)
                }
            }
    }

    func bool() -> SpEr<Bool> {
        return
            entity(for: APIBool.self)
            .map { entity -> Bool in
                return entity.value
            }
    }

    func string() -> SpEr<String> {
        return
            entity(for: APIString.self)
            .map { entity -> String in
                return entity.value
            }
    }

    func int() -> SpEr<Int> {
        return
            entity(for: APIInt.self)
            .map { entity -> Int in
                return Int(entity.value)
            }
    }

    func double() -> SpEr<Double> {
        return
            entity(for: APIDouble.self)
            .map { entity -> Double in
                return entity.value
            }
    }

}
