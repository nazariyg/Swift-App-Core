// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension String {

    var localized: String {
        let localizedString = NSLocalizedString(self, comment: "")
        return localizedString
    }

    func localized(comment: String = "") -> String {
        let localizedString = NSLocalizedString(self, comment: comment)
        return localizedString
    }

    func localized(forLocaleID localeID: String) -> String {
        guard let path = Bundle.main.path(forResource: localeID, ofType: "lproj") else { return self }
        guard let bundle = Bundle(path: path) else { return self }
        let localizedString = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return localizedString
    }

    var localizedForEnglish: String {
        return localized(forLocaleID: "en")
    }

}
