//
//  DisconnectView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct DisconnectView: View {
    @EnvironmentObject private var rootVM: ContentVM

    var body: some View {
        ZStack {
            Color.general
            BodySection()
        }
        .ignoresSafeArea()
    }
    
    private func BodySection() -> some View {
        VStack(spacing: 24) {
            Image.disconnect
            Text("There is no internet connection")
                .foregroundStyle(.black)
                .font(.headline)
            
            Button("Try again") {
                    self.rootVM.reconnect()
                    }
            .buttonStyle(PrimaryButtonStyle(140))

        }
    }    
}

#Preview {
    DisconnectView()
}
