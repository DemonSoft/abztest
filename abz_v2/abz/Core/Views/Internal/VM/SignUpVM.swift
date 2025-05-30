//
//  SignUpVM.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import Combine
import SwiftUI

class SignUpVM : ObservableObject {
    
    // MARK: - Types
    
    // MARK: - Publishers
    @Published var available    = false
    @Published var name         = "" {didSet {self.check()}}
    @Published var email        = "" {didSet {self.check()}}
    @Published var phone        = "" {didSet {self.check()}}
    @Published var picked       =  false {didSet {self.check()}}
    @Published var role         = Position.placeholder {didSet {self.check()}}

    @Published var selectedImage: UIImage? {
        didSet {
            self.handlePhoto(self.selectedImage)
        }
    }
    
    // MARK: - Public properties
    var roles = [Position]()
    
    
    // MARK: - Private properties
    private var rootVM:ContentVM?
    private var pickedPhoto: Data?
    
    
    // MARK: - Init
    init() {
        self.subscriptions()
    }
    
    // MARK: - Public methods
    func changeRole(_ value: Position) {
        self.role = value
    }
    
    func updateRootVM(_ root: ContentVM) {
        self.rootVM = root
    }

    func send() {
        self.upload()
    }
    // MARK: - Private methods
    private func subscriptions() {
        
        PositionsRequest().execute() {[weak self] req in
            guard   req.succeeded,
                    let req = req as? PositionsRequest,
                    let list = req.result?.positions else { return }
            main { self?.update(list) }
        }
    }
    
    private func update(_ positions: [Position]) {
        self.roles = positions.sorted(by: { $0.id < $1.id })
        self.role = self.roles.first ?? Position.placeholder
    }
    
    private func check() {
        self.available =
            self.picked &&
            self.name.isName &&
            self.phone.isPhone &&
            self.email.isEmail
    }
    
    private func handlePhoto(_ image: UIImage?) {
        self.pickedPhoto = nil
        self.picked      = false
        guard let img    = image else { return }

        guard img.size.width >= 70 && img.size.height >= 70 else { return }
        guard let data   = img.jpegData(compressionQuality : 1.0) else { return }

        guard data.count < 5_000_000 else { return }
        
        
        self.pickedPhoto = data
        self.picked      = true
        
        "SIZE: \(img.size)".logConsole()
        "LENGTH: \(data.count)".logConsole()
    }
    
    private func upload() {

        guard let data  = self.pickedPhoto else { return }

        let photo = UUID().uuidString
        let fileName = "\(photo).jpg"
        let user = User(id: 0, name: self.name, email: self.email.lowercased(), phone: self.phone, position: self.role.name, position_id: Int32(self.role.id), registration_timestamp: 0, photo: photo)
        
        SendUserRequest().uploadImage(user: user, fileName: fileName, imageData: data) {[weak self] req in
            guard let self = self else { return }
            guard let req = req as? SendUserRequest else { return  }
            guard let res = req.result else { 
                main { self.rootVM?.goFail() }
                return  }
            main {
                if res.success {
                    self.rootVM?.goSuccess()
                } else {
                    self.rootVM?.goFail()
                }
            }
        }
    }
}
