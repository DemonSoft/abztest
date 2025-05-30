//
//  ReachabilityService.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import SwiftUI
import Network

final class ReachabilityService {
    typealias Callback = (_ state: Bool) -> Void
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityService")
    private var callback:Callback?

    func start(_ callback: Callback?) {
        self.callback = callback
        self.process()
    }

    
    // MARK - Private
    private func process() {
        let recheckTime = 5.0
        self.monitor.pathUpdateHandler = {[weak self] _ in

                    // Monitor runs on a background thread so we need to publish
                    // on the main thread
                    DispatchQueue.main.async {
                        delay(recheckTime) {
                            let result = Reachability.connectedToNetwork()
                            self?.callback?(result)
                        }
                    }
                }
        self.monitor.start(queue: self.queue)
    }
}

