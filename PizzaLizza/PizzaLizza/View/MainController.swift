//
//  ViewController.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import UIKit

class MainController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "MainCell")
        
        return tv
    }()
    
    var pizzaService = PizzaService()
    var pizzaData: [Pizza]?
    var shoppingCart = ShoppingCart.sharedCart
//    var pickerCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        navigationItem.title = "Pizza Lizza"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(shoppingCart.pizzas.count) 🍕", style: .plain, target: self, action: #selector(segueHandler))
        
        pizzaData = pizzaService.fetchPizzaData()
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

private extension MainController {
    func updateCartButton() {
        navigationItem.rightBarButtonItem?.title = "\(shoppingCart.pizzas.count) 🍕"
    }
    
    @objc private func segueHandler() {
        let destinationVC = CartController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzaData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = pizzaData?[indexPath.row].countryName
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedPizza = pizzaData?[indexPath.row] else {return}
        shoppingCart.pizzas.append(selectedPizza)
        updateCartButton()
    }
}

