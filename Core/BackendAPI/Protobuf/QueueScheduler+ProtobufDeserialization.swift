// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import ReactiveSwift

public extension QueueScheduler {

    static var protobufMessageDeserialization: QueueScheduler = {
        let queueLabel = DispatchQueue.uniqueQueueLabel()
        return QueueScheduler(qos: .utility, name: queueLabel)
    }()

}
