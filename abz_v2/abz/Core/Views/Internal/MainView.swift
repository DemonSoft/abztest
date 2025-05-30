//
//  MainView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var rootVM: ContentVM
    @StateObject private var model = MainVM()

    var body: some View {
        BodySection()
    }
    
    private func BodySection() -> some View {
        VStack {
            VSpacer(0.5)
            TitleSection()
            CentralSection()
            ButtonSection()
        }
        .background(.general)
    }

    private func TitleSection() -> some View {
        VStack {
            Text(self.model.page.title)
                .font(.f20())
                .foregroundStyle(.black)
                .frame(height: 56)
                .spreadWidth()
        }
        .background(.primaryNormal)
        .spreadWidth()
    }

    private func CentralSection() -> some View {
        VStack {
            if self.model.page == .list {
                ListSection()
            } else {
                SignUpView()
            }
        }
    }

    
    private func ListSection() -> some View {
        VStack {
            
            if self.model.list.count > 0 {
                FilledListView()
                    .environmentObject(self.model)
            } else {
                EmptyListView()
            }
        }
        .spread()
    }
    
    private func ButtonSection() -> some View {
        HStack {
            Button("Users") {
                    self.model.switchToList()
                    }
            .buttonStyle(TabButtonStyle(.Users, self.model.page == .list))
            .disabled(self.model.page == .list)
            .spreadWidth()
            Button("Sign Up") {
                    self.model.switchToSignUp()
                    }
            .buttonStyle(TabButtonStyle(.SignUp, self.model.page == .signup))
            .disabled(self.model.page == .signup)
            .spreadWidth()
        }
        .padding(.horizontal)
        .spreadWidth()
        .background(.lightBackgroundGray)
    }
}

#Preview {
    MainView()
}
