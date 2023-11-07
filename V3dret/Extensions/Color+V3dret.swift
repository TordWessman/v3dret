//
//  Color+V3dret.swift
//  V3dret
//
//  Created by Tord Wessman on 2023-11-06.
//

import SwiftUI
import UIKit

class Theme {

    enum Mode {
        case dark
        case light
    }

    var mode: Theme.Mode = .light {
        didSet {

        }
    }

    private(set) static var current = Theme()
}

extension Color {

    static var mode: Theme.Mode { return Theme.current.mode }

    static var buttonColor: Color {
        switch mode {
        case .dark: return .white
        case .light: return .black
        }
    }

    static var backgroundColor: Color {
        switch mode {
        case .dark: return .black
        case .light: return .white
        }
    }

    static var textColor: Color {
        switch mode {
        case .dark: return .white
        case .light: return .black
        }
    }
    static var inputFieldBackgroundColor: Color {
        switch mode {
        case .dark: return .black
        case .light: return .white
        }
    }

    static var errorColor: Color {
        switch mode {
        case .dark: return .orange
        case .light: return .red
        }
    }
}
