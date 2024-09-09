//
//  Class.swift
//  StopCig
//
//  Created by Hook on 09/09/2024.
//

import Network
import SwiftUI

class NetworkMinitor: ObservableObject {
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    @Published var isConnected: Bool = true
    
    init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "NetworkMonitor") // label sert a identifier la queue
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
