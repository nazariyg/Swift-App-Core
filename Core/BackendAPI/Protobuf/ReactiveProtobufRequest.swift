// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import ReactiveSwift
import Alamofire

public extension Reactive where Base: SessionManager {

    /// Reactively makes an HTTP data request with "application/protobuf" expected content type in the response.
    func makingProtobuf(request: HTTPRequest) -> SpEr<HTTPDataResponse> {
        var httpRequest = request
        httpRequest.expectedContentType = .protobuf
        return makingForData(request: httpRequest, acceptForValidation: [.protobuf])
    }

}
