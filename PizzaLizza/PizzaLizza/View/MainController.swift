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
    
    private let disposeBag = DisposeBag()
    private var viewModel = MainViewModel()
    private var pizzaData: Observable<[MainModel]> = Observable.just([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Pizza Lizza"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(ShoppingCart.sharedCart.pizzas.value.count) 🍕", style: .plain, target: self, action: #selector(segueHandler))
        
        // fetchData
        pizzaData = viewModel.fetchPizzaModel()
        
        // setup view
        setupTableView()
        
        // rx setup call
        updateCartButton()
        setupCellConfiguration()
        setupCellTapHandling()
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
                cell.mainConfigure(mainText: pizza.displayItemText,
                                   secondaryText: pizza.displayPriceText)
            }
                       .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(MainModel.self)
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

//MARK: - View setup
private extension MainController {
    func setupTableView() {
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.autoresizingMask = [UITableView.AutoresizingMask.flexibleLeftMargin, UITableView.AutoresizingMask.flexibleRightMargin, UITableView.AutoresizingMask.flexibleTopMargin, UITableView.AutoresizingMask.flexibleBottomMargin]
    }
}
