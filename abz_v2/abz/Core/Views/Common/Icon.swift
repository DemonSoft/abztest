//
//  Icon.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 14.05.2025.
//

import SwiftUI

struct Icon: View {
    @State var image: Image
    @State var size: Double
    @State var color: Color
    
    init(_ image: Image, _ size: Double = 24, _ color: Color = .gray) {
        self.image = image
        self.size  = size
        self.color = color
    }

    var body: some View {
        ZStack {
            self.image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(self.color)
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: self.size, height: self.size)
    }
}

