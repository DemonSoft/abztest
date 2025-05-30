//
//  MainVM.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import Combine
import SwiftUI

class MainVM : ObservableObject {
    
    // MARK: - Types
    enum Page {
        case list, signup
        
        static var titles:[Self: String] = [
            .list: "Working with GET request",
            .signup: "Working with POST request"
        ]
        
        var title: String {
            return Self.titles[self]!
        }
    }
    
    
    // MARK: - Publishers
    @Published var list = [User]()
    @Published var page: Page = .list
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    private var fetcher: UserFetch?
    
    // MARK: - Init
    init() {
        self.subscriptions()
    }
    
    deinit {
        self.fetcher?.cancel()
        self.fetcher = nil
    }
    
    // MARK: - Public methods
    func switchToList() {
        withAnimation {
            self.page = .list
        }
    }
    
    func switchToSignUp() {
        withAnimation {
            self.page = .signup
        }
    }
    // MARK: - Private methods
    private func subscriptions() {
        self.fetcher = UserFetch()
        self.fetcher?.$list.receive(on: RunLoop.main).assign(to: &$list)
        self.fetcher?.fetch()
        
        self.load()
    }
    
    
    private func load() {
        self.loadRequest(1)
    }
    
    private func loadRequest(_ page: Int) {
        UsersRequest().adjust(page: page, count: 100).execute() {[weak self] req in
            if req.succeeded {
                self?.loadRequest(page + 1)
            }
        }
    }
}
