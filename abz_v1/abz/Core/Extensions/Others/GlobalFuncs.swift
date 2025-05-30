//
//  GlobalFuncs.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 09.05.2025.
//

import Foundation

public func main(_ seconds:Double = 0.0, closure:@escaping ()->()) {
    delay(seconds, closure: closure)
}

public func delay(_ seconds:Double, closure:@escaping ()->()) {
    Task {
        let delay = UInt64(seconds * 1_000_000_000)
        try await Task<Never, Never>.sleep(nanoseconds: delay)
        await MainActor.run { closure() }
    }
}
