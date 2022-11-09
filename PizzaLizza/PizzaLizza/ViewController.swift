//
//  ViewController.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let navBarAppearances = UINavigationBarAppearance()
        navBarAppearances.configureWithOpaqueBackground()
        navBarAppearances.backgroundColor = UIColor(named: "MainRed")
        navBarAppearances.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 27),
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.standardAppearance = navBarAppearances
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearances
        
        navigationItem.title = "Pizza Lizza"
    }


}

