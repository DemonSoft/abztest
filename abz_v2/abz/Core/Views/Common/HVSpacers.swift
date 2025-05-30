//
//  HVSpacers.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 14.05.2025.
//

import SwiftUI

struct VSpacer: View {
    var height: Double
    
    init(_ height: Double = 8) {
        self.height = height
    }
    
    var body: some View {
        VStack {
            //WARNING: -- Careful! do not replace with VSpacer() !!!
            Spacer().frame(height: self.height)
        }
    }
}

struct HSpacer: View {
    var width: Double
    
    init(_ width: Double = 8) {
        self.width = width
    }
    
    var body: some View {
        HStack {
            //WARNING: -- Careful! do not replace with HSpacer() !!!
            Spacer().frame(width: self.width)
        }
    }
}
