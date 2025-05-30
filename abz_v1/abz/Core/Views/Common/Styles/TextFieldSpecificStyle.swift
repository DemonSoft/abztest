//
//  TextFieldSpecificStyle.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import Foundation

import SwiftUI

struct TextFieldSpecificStyle: TextFieldStyle {
    var mistake: Bool
    var title: String

    init(_ mistake: Bool, _ title: String) {
        self.mistake = mistake
        self.title = title
    }
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let borderColor = self.mistake ? Color.error : .disabled
        let textColor   = self.mistake ? Color.error : Color.black87
        ZStack {
            if self.mistake {
                Text(self.title)
                    .foregroundStyle(.error)
                    .font(.caption2)
                    .spreadWidthLeft()
                    .offset(y: -16)
            }
            configuration
                .offset(y: self.mistake ? 8 : 0)
        }
        .padding()
        .background(.clear)
        .foregroundColor(textColor)
        .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: 1)
                )
        
        }
}
