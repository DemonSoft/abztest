//
//  Image+Icons.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 14.05.2025.
//

import SwiftUI

extension Image {
    
    static var Xmark                : Image { return Image(systemName: "xmark") }
    static var Users                : Image { return Image(systemName: "person.3.sequence.fill")}
    static var SignUp               : Image { return Image(systemName: "person.crop.circle.fill.badge.plus")}
    static var Photo                : Image { return Image(systemName: "person.circle")}

    
    static var cat                  : Image { return Image("cat")}
    static var success              : Image { return Image("success")}
    static var fail                 : Image { return Image("fail")}
    static var disconnect           : Image { return Image("no-connection")}
    static var empty                : Image { return Image("empty")}
    
    static var radioCheck           : Image { return Image("radio-check")}
    static var radioUncheck         : Image { return Image("radio-uncheck")}

}
