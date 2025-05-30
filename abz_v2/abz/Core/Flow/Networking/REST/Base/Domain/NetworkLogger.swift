//
//  NetworkLogger.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

class NetworkLogger {
    func log(_ error: Error?) async {
        guard let error = error else { return }
        print("‼️ \(error.localizedDescription)")
    }

    func log(_ error: String?) async {
        guard let error = error else { return }
        print("‼️ \(error)")
    }

    func console(_ message: String?) async {
        guard let message = message else { return }
        print("📡 \(message)")
    }
    
    func mistake(_ cmd: NetworkBase) async {
        guard let params = cmd.metadata.params else { return }
        "PARAMS".logError()
        params.print()
    }

    func started(_ url: URL?, _ metadata: NetworkMetadata, _ error: Error?) async {
        if let url = url {
            await self.console("\(url)")
        }
        if let _ = error {
            await self.log(error)
            return
        }
    }

}
