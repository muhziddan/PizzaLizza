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
        var tv = UITableView()
        tv.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        tv.rowHeight = 70
        
        return tv
    }()
    
    var pizzaService = PizzaService()
    var pizzaData: Observable<[Pizza]> = Observable.just([])
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        navigationItem.title = "Pizza Lizza"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(ShoppingCart.sharedCart.pizzas.value.count) 🍕", style: .plain, target: self, action: #selector(segueHandler))
        
        pizzaData = Observable.just(pizzaService.fetchPizzaData() ?? [])
        tableView.reloadData()
        updateCartButton()
        setupCellConfiguration()
        setupCellTapHandling()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
}

//MARK: - RxSetup
private extension MainController {
    func updateCartButton() {
        ShoppingCart.sharedCart.pizzas.asObservable()
            .subscribe(onNext: {[unowned self] pizzas in
                navigationItem.rightBarButtonItem?.title = "\(pizzas.count) 🍕"
            })
            .disposed(by: disposeBag)
    }
    
    func setupCellConfiguration() {
        pizzaData
            .bind(to: tableView
                .rx
                .items(cellIdentifier: ItemCell.identifier,
                       cellType: ItemCell.self)) { row, pizza, cell in
                guard let price = CurrencyFormatter.rupiahFormatter.string(from: pizza.intPrice) else {return}
                cell.mainConfigure(mainText: pizza.countryName,
                               secondaryText: price)
            }
                       .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(Pizza.self)
            .subscribe(onNext: { [unowned self] pizza in
                let newValue = ShoppingCart.sharedCart.pizzas.value + [pizza]
                ShoppingCart.sharedCart.pizzas.accept(newValue)
                
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Segue handler
private extension MainController {
    @objc private func segueHandler() {
        let destinationVC = CartController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
