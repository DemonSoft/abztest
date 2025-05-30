//
//  LaunchView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        BodySection()
    }
    
    private func BodySection() -> some View {
        ZStack {
            Color.primaryNormal
            VStack {
                Image.cat
                Text("TESTTASK")
                    .foregroundStyle(.black)
                    .font(.largeTitle)
            }
        }
        .spread()
        .ignoresSafeArea()
    }

}

#Preview {
    LaunchView()
}
