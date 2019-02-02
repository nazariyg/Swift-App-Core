// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public typealias HTTPContentType = MimeType

public extension HTTPContentType {

    // MARK: - Lifecycle

    /// Constructs a content type from a content type string.
    init?(contentTypeString: String) {
        self.init(mimeTypeString: contentTypeString)
    }

}
