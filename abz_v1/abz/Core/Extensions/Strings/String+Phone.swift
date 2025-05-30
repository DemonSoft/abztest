//
//  String+Phone.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

extension String {
    
    struct FormatterRegexp {
        var expression = ""
        var pattern = ""
    }
    
    static var phoneFormatter : FormatterRegexp {
        return FormatterRegexp(expression: "(\\d{2})(\\d{3})(\\d{3})(\\d{2})(\\d+)",
                              pattern: "+$1($2) $3-$4-$5")
    }
    
    func formateAsPhoneNumber() -> String {
        let formatter = Self.phoneFormatter
        return self.replacingOccurrences(of: formatter.expression, with: formatter.pattern, options: .regularExpression, range: nil)
    }

    static var phoneWithoutCodeFormatter : FormatterRegexp {
        return FormatterRegexp(expression: "(\\d{3})(\\d{3})(\\d+)",
                              pattern: "$1-$2-$3")
    }
    
    func formateAsPhoneNumberWithoutCode() -> String {
        let formatter = Self.phoneFormatter
        return self.replacingOccurrences(of: formatter.expression, with: formatter.pattern, options: .regularExpression, range: nil)
    }
}
