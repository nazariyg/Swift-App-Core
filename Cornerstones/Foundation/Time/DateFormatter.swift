// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension DateFormatter {

    /// "yyyy-MM-dd HH:mm:ss UTC"
    static var utc: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss 'UTC'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }

    /// "yyyy-MM-ddTHH:mm:ssZ"
    static var iso8601UTC: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }

}
