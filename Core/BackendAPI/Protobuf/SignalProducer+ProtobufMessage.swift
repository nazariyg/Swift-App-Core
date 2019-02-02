// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Cornerstones
import ReactiveSwift
import Result
import SwiftProtobuf

private let logCategory = "Protobuf"

public extension SignalProducer where Value == HTTPDataResponse, Error == E {

    /// Reactively makes a protobuf request for the specified protobuf message type as the response's payload.
    func protobuf<MessageType: SwiftProtobuf.Message>(for: MessageType.Type) -> SpEr<MessageType> {
        return flatMap(.latest) { response -> SpEr<MessageType> in
            SpEr(value: response.payload)
            .start(on: QueueScheduler.protobufMessageDeserialization)
            .attemptMap { payload -> ReEr<MessageType> in
                let message = try? MessageType(serializedData: payload)
                if let message = message {
                    return .success(message)
                } else {
                    log.error("Could not deserialize a protobuf message", logCategory)
                    return .failure(.apiEntityDeserializationError)
                }
            }
        }
    }

}
