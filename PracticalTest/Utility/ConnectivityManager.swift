//
//  ConnectivityManager.swift
//  PracticalTest
//
//  Created by Parth Patel on 28/10/22.
//

import UIKit
//import Network
import Foundation
import SystemConfiguration

/*class ConnectivityManager {
    static let shared = ConnectivityManager()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                // post disconnected notification
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}*/

class ConnectivityManager {
    static let shared = ConnectivityManager()
    
    //MARK: Internet availability
    func isInternetAvailable() -> Bool {
        /// Sample Socket Address
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        /// Reachability status
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        /// Flags of Reachability
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        /// Check Connectivity Flag
        let isReachable = flags.contains(.reachable)
        /// If needs a Conection
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
}
