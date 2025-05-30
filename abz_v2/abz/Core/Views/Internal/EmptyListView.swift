//
//  EmptyListView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct EmptyListView: View {
    var body: some View {
        ZStack {
            Color.general
            BodySection()
        }
        .ignoresSafeArea()
    }
    
    private func BodySection() -> some View {
        VStack(spacing: 24) {
            Image.empty
            Text("There are no users yet")
                .foregroundStyle(.black)
                .font(.headline)
        }
    }
}

#Preview {
    EmptyListView()
}
