//
//  TabButtonStyle.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct TabButtonStyle: ButtonStyle {
    let icon: Image
    let active: Bool
    
    init(_ icon: Image, _ active: Bool) {
        self.icon = icon
        self.active = active
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            let color = self.active ? Color.secondaryNormal : .black.opacity(0.60)
            icon
                .renderingMode(.template)
                .foregroundColor(color)
            configuration.label
                .padding()
                .foregroundStyle(color)
        }
    }
}
