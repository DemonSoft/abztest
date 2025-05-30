//
//  Settings.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 13.05.2025.
//

import SwiftUI

let Settings = SettingsProvider.instance
class SettingsProvider: ObservableObject {
    static fileprivate (set) var instance = SettingsProvider()
    @AppStorage("bearer")    var bearer: String = ""
}
