//
//  String+expressions.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 28.05.2025.
//

import Foundation

import SwiftUI

extension String {
    static var emailExpression: String {
        return "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\\\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\\\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
    }
    
    static var nameExpression: String {
        return "^[a-zA-Z-]+ ?.* [a-zA-Z-]+$"
    }

    static var phoneExpression: String {
        //return "^\\(?\\d{3}\\)?[ -]?\\d{3}[ -]?\\d{4}$"
        return "^[\\+]{0,1}380([0-9]{9})$"
    }

    func verification(_ expression:String?, required:Bool = false) -> Bool
    {
        let text = self
        if required && text.count == 0 { return false } // text required, but field is empty ("")
        guard let expression else { return true } // no expression
        guard expression.count > 0 else { return true } // no expression

        
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", expression)
        let result = predicate.evaluate(with: self)
        return result
    }
    
    var isEmail : Bool  {
        return self.verification(Self.emailExpression, required: true)
    }
    
    var isPhone : Bool  {
        return self.verification(Self.phoneExpression, required: true)
    }

    var isName : Bool  {
        return self.verification(Self.nameExpression, required: true)
    }
}
