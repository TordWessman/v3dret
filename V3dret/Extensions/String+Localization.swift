//
//  String+Localization.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import Foundation

public extension String {

    /** Treat `self` as a localization key and pass `args` to the localized string. */
    func localize(_ args: CVarArg...) -> String {
        return withVaList(args) {
            return NSString(format: self.localized, locale: Locale.current, arguments: $0) as String
        }
    }

    /** Treat `self` as a localization key.  */
    var localized: String  {
        return NSLocalizedString(self, comment: "") as String
    }
}
