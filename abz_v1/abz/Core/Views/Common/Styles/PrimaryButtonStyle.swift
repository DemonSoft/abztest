//
//  PrimaryButtonStyle.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var width: CGFloat
    var enabled: Bool
    init(_ width: CGFloat, _ enabled: Bool = true) {
        self.width = width
        self.enabled = enabled
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let activeColor = configuration.isPressed ? Color.primarySelected : .primaryNormal
        configuration.label
            .frame(width: self.width)
            .padding()
            .background(self.enabled ? activeColor : .disabled)
            .foregroundStyle(self.enabled ? Color.black87 : .black48)
            .clipShape(Capsule())
    }
}
