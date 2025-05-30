//
//  Font+Styles.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import SwiftUI

extension Font {
    static func sys(_ size: CGFloat = 18, _ weight: Font.Weight = .regular) -> Font {
        return .system(size: size, weight: weight, design: .default)
    }

    static func f20(_ weight: Font.Weight = .regular) -> Font {
        return .system(size: 20, weight: weight, design: .default)
    }

    static func f18(_ weight: Font.Weight = .regular) -> Font {
        return .system(size: 16, weight: weight, design: .default)
    }

    static func f14(_ weight: Font.Weight = .regular) -> Font {
        return .system(size: 14, weight: weight, design: .default)
    }

}
