//
//  AppDelegate.swift
//  PracticalTest
//
//  Created by Parth Patel on 27/10/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - All Properties and Variables
    var window: UIWindow?

    //MARK: - App Life Cycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setupReachability()
        IQKeyboardManager.shared.enable = true
        return true
    }
    
    func applicationWillResignActive(_: UIApplication) {}
    
    func applicationDidEnterBackground(_: UIApplication) {}
    
    func applicationWillEnterForeground(_: UIApplication) {}
    
    func applicationDidBecomeActive(_: UIApplication) {}
    
    func applicationWillTerminate(_: UIApplication) {}
    
    //MARK: - Self Calling Methods
    private func setupReachability() {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
    }
}
