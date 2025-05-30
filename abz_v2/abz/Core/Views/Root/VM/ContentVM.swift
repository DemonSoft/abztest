//
//  ContentVM.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

//import Combine
import SwiftUI

class ContentVM : ObservableObject {
    
    // MARK: - Types
    enum ViewState {
        case launch
        case disconnect
        case main
        case success
        case fail
    }
    
    // MARK: - Publishers
    @Published var viewSate = ViewState.launch
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    private let reachability = ReachabilityService()
    private var prevSate = ViewState.launch
    
    // MARK: - Init
    init() {
        self.subscriptions()
    }
    
    deinit {
    }
    
    // MARK: - Public methods
    func reconnect() {
        withAnimation {
            self.viewSate = .main
        }
    }
    
    func gotIt() {
        withAnimation {
            self.viewSate = .main
        }
    }

    func goSuccess() {
        withAnimation {
            self.viewSate = .success
        }
    }

    func goFail() {
        withAnimation {
            self.viewSate = .fail
        }
    }

    // MARK: - Private methods
    private func subscriptions() {
        
        self.reachability.start() { [weak self] res in
            guard let self = self else { return }
            if res {
                guard self.viewSate == .disconnect else { return }
                self.viewSate = self.prevSate
                "Internet is Well".logConsole()

            } else {
                if self.viewSate == .disconnect { return }
                self.prevSate = self.viewSate
                self.viewSate = .disconnect
                "Internet is Bad".logConsole()
            }
        }

        Database.start()
        RestNetwork.start()
        
        TokenRequest().adjust().execute()
        
        
        delay(0.75) {
            withAnimation {
                self.viewSate = .main
            }
        }
    }
}
