//
//  SuccessView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct SuccessView: View {
    @EnvironmentObject private var rootVM: ContentVM

    var body: some View {
        ZStack {
            Color.general
            TitleSection()
            BodySection()
        }
        .ignoresSafeArea()
    }
    
    private func TitleSection() -> some View {
        VStack {
            VSpacer(44)
            HStack {
                Spacer()
                Button {
                    self.rootVM.gotIt()
                } label: {
                    Icon(.Xmark, 16, .disabled)
                }

            }
            Spacer()
        }
        .padding()
        .spread()
    }

    
    private func BodySection() -> some View {
        VStack(spacing: 24) {
            Image.success
            Text("User successfully registered")
                .foregroundStyle(.black)
                .font(.headline)
            
            Button("Got it") {
                    self.rootVM.gotIt()
                    }
            .buttonStyle(PrimaryButtonStyle(140))

        }
    }
}

#Preview {
    SuccessView()
}
