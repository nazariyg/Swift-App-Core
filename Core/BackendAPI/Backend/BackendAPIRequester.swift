// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public struct BackendAPIRequester {

    public static func making(_ request: HTTPRequest) -> SpEr<HTTPDataResponse> {
        // Use a stateless session manager.
        let sessionManager = Requester.shared.stateless

        // Apply API HTTP request plugins.
        let request = BackendAPIRequestPluginProvider.shared.mapHTTPRequest(request)

        return
            sessionManager
            .makingProtobuf(request: request)
            .on(value: { response in
                // Apply API HTTP response observers.
                BackendAPIRequestPluginProvider.shared.onHTTPResponse(response)
            })
            .on(failed: { error in
                // Apply API HTTP response error observers.
                BackendAPIRequestPluginProvider.shared.onHTTPResponseError(error, request: request)
            })
    }

}
