//
//  ContentView.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var model = ContentVM()
    
    var body: some View {
        
        ZStack {
            MainPlace()
            ModalPlace()
        }
        .environmentObject(self.model)
    }
    
    private func MainPlace() -> some View {
        Group {
            switch self.model.viewSate {
                case .launch        : LaunchView()
                case .disconnect    : DisconnectView()
                case .main          : MainView()
                default             : EmptyView()
            }
        }
    }

    private func ModalPlace() -> some View {
        Group {
            switch self.model.viewSate {
                case .success       : SuccessView()
                case .fail          : FailView()
                default             : EmptyView()
            }
        }
        .environmentObject(self.model)
    }

}

#Preview {
    ContentView()
}
