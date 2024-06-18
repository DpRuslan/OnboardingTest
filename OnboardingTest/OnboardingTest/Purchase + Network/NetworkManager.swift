//
//  NetworkManager.swift
//

import Network

protocol NetworkManagerDelegate: AnyObject {
    func becomeActiveAgain()
}

class NetworkManager {
    weak var delegate: NetworkManagerDelegate?
    
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected: Bool = false
    private var wasConnected: Bool = false
    
    private init() {
        setupMonitor()
    }
    
    deinit {
        monitor.cancel()
    }
    
    private func setupMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let currentlyConnected = path.status == .satisfied
                if currentlyConnected && !(self?.wasConnected ?? true) {
                    print("Internet is reappeared.")
                    self?.delegate?.becomeActiveAgain()
                } else if !currentlyConnected && (self?.wasConnected ?? false) {
                    print("Internet connection disappeared.")
                }
                // Update the wasConnected flag after handling the conditions
                self?.wasConnected = currentlyConnected
                self?.isConnected = currentlyConnected
            }
        }
        monitor.start(queue: queue)
    }
    
    private func networkBecameActive() {
        delegate?.becomeActiveAgain()
    }
}
