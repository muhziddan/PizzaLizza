//
//  CartController.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import UIKit
import RxCocoa
import RxSwift

class CartController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        tv.rowHeight = 70
        
        return tv
    }()
    private let totalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainRed")
        
        return view
    }()
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        
        return label
    }()
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    private var totalItems: Observable<[ShoppingCartModel]> = Observable.just([])
    private let totalCost = ShoppingCart.sharedCart.totalCost
    private let disposeBag = DisposeBag()
    private var viewModel = ShoppingCartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = "Cart"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "reset", style: .plain, target: self, action: #selector(resetCart))
        
        // setup vm
        totalItems = viewModel.fetchCartModel()
        
        // setup view
        setupTableView()
        setupTotalView()
        
        // setup rx
        setupCellConfiguration()
        setupCellTapHandling()
    }
}

//MARK: - ReactiveX setup
private extension CartController {
    func setupCellConfiguration() {
        totalItems
            .bind(to: tableView
                .rx
                .items(cellIdentifier: ItemCell.identifier,
                       cellType: ItemCell.self)) { row, pizza, cell in
                
                cell.cartConfigure(mainText: pizza.displayItemText,
                                   secondaryText: pizza.displayPriceText, count: pizza.picked)
            }
                       .disposed(by: disposeBag)
    }
    
    func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(MainModel.self)
            .subscribe(onNext: { [unowned self] pizza in
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Reset Cart
private extension CartController {
    @objc private func resetCart() {
        ShoppingCart.sharedCart.pizzas.accept([])
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - setup views
private extension CartController {
    func setupTableView() {
        
        tableView.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: (view.bounds.height - CGFloat(110)))
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.autoresizingMask = [UITableView.AutoresizingMask.flexibleLeftMargin, UITableView.AutoresizingMask.flexibleRightMargin, UITableView.AutoresizingMask.flexibleTopMargin, UITableView.AutoresizingMask.flexibleBottomMargin]
    }
    
    func setupTotalView() {
        // base view
        totalView.frame = CGRect(x: view.bounds.minX, y: view.bounds.maxY, width: view.bounds.width, height: -110)
        
        view.addSubview(totalView)
        
        totalView.translatesAutoresizingMaskIntoConstraints = true
        totalView.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        
        // labels
        totalLabel.frame = CGRect(x: totalView.bounds.minX + CGFloat(15), y: totalView.bounds.minY + CGFloat(20), width: 80, height: 25)
        totalPriceLabel.frame = CGRect(x: totalView.bounds.maxX - CGFloat(15), y: totalView.bounds.minY + CGFloat(20), width: -200, height: 25)
        
        totalLabel.text = "Total:"
        totalPriceLabel.text = CurrencyFormatter.rupiahFormatter.string(from: totalCost)
        
        totalView.addSubview(totalLabel)
        totalView.addSubview(totalPriceLabel)
        
        totalLabel.translatesAutoresizingMaskIntoConstraints = true
        totalPriceLabel.translatesAutoresizingMaskIntoConstraints = true
        totalLabel.autoresizingMask = [UILabel.AutoresizingMask.flexibleLeftMargin, UILabel.AutoresizingMask.flexibleRightMargin, UILabel.AutoresizingMask.flexibleTopMargin, UILabel.AutoresizingMask.flexibleBottomMargin]
        totalPriceLabel.autoresizingMask = [UILabel.AutoresizingMask.flexibleLeftMargin, UILabel.AutoresizingMask.flexibleRightMargin, UILabel.AutoresizingMask.flexibleTopMargin, UILabel.AutoresizingMask.flexibleBottomMargin]
    }
}
