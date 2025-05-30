//
//  Date+Formaters.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 15.05.2025.
//

import Foundation

extension Date {
    
    // MARK: - Date Medium
    static let mediumDateFormater : DateFormatter = {
        let formatter       =  DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var humanDateMedium: String {
        return Date.mediumDateFormater.string(from: self)
    }

}
