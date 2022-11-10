//
//  ViewController.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import UIKit
import RxSwift
import RxCocoa

class MainController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        
        return tv
    }()
    
    var pizzaService = PizzaService()
    var pizzaData: [Pizza]?
    var shoppingCart = ShoppingCart.sharedCart
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        navigationItem.title = "Pizza Lizza"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(shoppingCart.pizzas.value.count) 🍕", style: .plain, target: self, action: #selector(segueHandler))
        
        pizzaData = pizzaService.fetchPizzaData()
        tableView.reloadData()
        updateCartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        updateCartButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

//MARK: - Cart update and Segue
private extension MainController {
    func updateCartButton() {
//        navigationItem.rightBarButtonItem?.title = "\(shoppingCart.pizzas.value.count) 🍕"
        ShoppingCart.sharedCart.pizzas.asObservable()
            .subscribe(onNext: {[unowned self] pizzas in
                navigationItem.rightBarButtonItem?.title = "\(pizzas.count) 🍕"
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func segueHandler() {
        let destinationVC = CartController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: - Table view data source and delegate
extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pizzaData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        
        guard let currentPizza = pizzaData?[indexPath.row],
        let price = CurrencyFormatter.rupiahFormatter.string(from: currentPizza.intPrice) else {return cell}
        
        cell.configure(mainText: "\(currentPizza.countryName) pizza",
                       secondaryText: price)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedPizza = pizzaData?[indexPath.row] else {return}
        
        let newValue = shoppingCart.pizzas.value + [selectedPizza]
        ShoppingCart.sharedCart.pizzas.accept(newValue)
//        shoppingCart.pizzas.append(selectedPizza)
//        updateCartButton()
    }
}

