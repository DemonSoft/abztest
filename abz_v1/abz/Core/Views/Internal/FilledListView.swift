//
//  FilledListView.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import SwiftUI
import Kingfisher

struct FilledListView: View {
    @EnvironmentObject private var model: MainVM
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(self.model.list, id: \.id) { user in
                    Cell(user)
                }
                ActivitySection()
            }
        }
    }
    
    @MainActor
    private func Cell(_ user: User) -> some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                
                KFImage(user.url)
                    .resizable()
                    .loadDiskFileSynchronously()
                    .fade(duration: 0.25)
                    .placeholder {
                        Icon(.Photo, 50)
                    }
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)

                
                VStack(spacing: 0) {
                    Text(user.name)
                        .multilineTextAlignment(.leading)
                        .font(.f18(.bold))
                        .foregroundColor(.black87)
                        .spreadWidthLeft()
                    VSpacer(4)
                    Text(user.position)
                        .font(.f14())
                        .foregroundColor(.black60)
                        .lineLimit(1)
                        .spreadWidthLeft()
                    VSpacer(8)
                    Text(user.email)
                        .font(.f14())
                        .foregroundColor(.black87)
                        .lineLimit(1)
                        .spreadWidthLeft()
                    Text(user.phone)
                        .font(.f14())
                        .foregroundColor(.black87)
                        .lineLimit(1)
                        .spreadWidthLeft()
                        .padding(.top, 4)
                    VSpacer(24)
                    Divider()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    
    private func ActivitySection() -> some View {
        VStack {
            if self.model.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(.disabled)
                    .padding()
            }
        }
        .spreadWidth()
        .onAppear() {
            self.model.onBottom()
        }
    }

}

#Preview {
    FilledListView()
}
