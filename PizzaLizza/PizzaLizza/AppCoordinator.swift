//
//  AppCoordinator.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let rootVC = MainController()
        let navVC = UINavigationController(rootViewController: rootVC)
        let navBarAppearances = UINavigationBarAppearance()
        navBarAppearances.configureWithOpaqueBackground()
        navBarAppearances.backgroundColor = UIColor(named: "MainRed")
        navBarAppearances.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 26),
            .foregroundColor: UIColor.white
        ]
        navVC.navigationBar.tintColor = .white
        navVC.navigationBar.standardAppearance = navBarAppearances
        navVC.navigationBar.scrollEdgeAppearance = navBarAppearances
        
//        window?.windowScene = windowScene
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
}
