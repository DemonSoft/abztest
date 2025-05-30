//
//  FailView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct FailView: View {
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
            Image.fail
            Text("That email is already registered")
                .foregroundStyle(.black)
                .font(.headline)
            
            Button("Try again") {
                    self.rootVM.gotIt()
                    }
            .buttonStyle(PrimaryButtonStyle(140))

        }
    }}

#Preview {
    FailView()
}
