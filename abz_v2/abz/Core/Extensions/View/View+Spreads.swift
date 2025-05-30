//
//  View+Spreads.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 14.05.2025.
//

import SwiftUI

extension View {
    func spread() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func spreadWidth() -> some View {
        self.frame(maxWidth: .infinity)
    }
    
    func spreadWidthLeft() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }

    func spreadWidthRight() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }

    func spreadHeight() -> some View {
        self.frame(maxHeight: .infinity)
    }
}
