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
    @Published var list        = [User]()
    @Published var page : Page = .list
    @Published var isLoading   = false

    // MARK: - Public properties
    
    // MARK: - Private properties
    private var currentPage = 1
    private var pageFrame = 5

    // MARK: - Init
    init() {
        self.subscriptions()
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

    func onBottom() {
        guard !self.isLoading else { return }

        self.isLoading = true
        self.loadRequest(self.currentPage + 1)
    }
    // MARK: - Private methods
    private func subscriptions() {
        self.load()
    }
    
    
    private func load() {
        self.loadRequest(1)
    }
    
    // MARK: - Pagination
    private func loadRequest(_ page: Int) {
        UsersPageRequest().adjust(page: page, count: self.pageFrame).execute() {[weak self] req in

            guard let self = self else { return }
            main { self.isLoading   = false }

            guard let req = req as? UsersPageRequest,
                  let res = req.result else { return }
            if req.succeeded {
                let users = res.users
                let diff = users.filter { u1 in
                    return !self.list.contains { $0.id == u1.id }
                }
                
                
                let raw = self.list + diff
                let sorted = raw.sorted(by: {$0.registration_timestamp > $1.registration_timestamp })
                main {
                    self.currentPage = page
                    self.list        = sorted
                }
                
            }
        }
    }

}
