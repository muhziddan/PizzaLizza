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
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        view.layer.shadowOpacity = 1.0
        view.layer.shadowRadius = 5.0
        
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
    private let payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "MainOrange")
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 20
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 25)
        ]
        button.setAttributedTitle(NSAttributedString(string: "Pay", attributes: attributes), for: .normal)
        
        return button
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
        setupPayButton()
        
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
            .modelSelected(ShoppingCartModel.self)
            .subscribe(onNext: { [unowned self] pizza in
                if let selectedRowIndexPath = self.tableView.indexPathForSelectedRow {
                    self.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Reset Cart method
private extension CartController {
    @objc private func resetCart() {
        ShoppingCart.sharedCart.pizzas.accept([])
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Pay button pressed
private extension CartController {
    @objc private func payButtonPressed() {
        let destinationVC = PayController()
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

//MARK: - setup views
private extension CartController {
    func setupTableView() {
        
        tableView.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: (view.bounds.height - CGFloat(140)))
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = true
        tableView.autoresizingMask = [UITableView.AutoresizingMask.flexibleLeftMargin, UITableView.AutoresizingMask.flexibleRightMargin, UITableView.AutoresizingMask.flexibleTopMargin, UITableView.AutoresizingMask.flexibleBottomMargin]
    }
    
    func setupTotalView() {
        // base view
        totalView.frame = CGRect(x: view.bounds.minX, y: view.bounds.maxY, width: view.bounds.width, height: -140)
        
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
    
    func setupPayButton() {
        payButton.frame = CGRect(x: (totalView.frame.size.width - 300)/2, y: totalLabel.frame.maxY + 20, width: 300, height: 50)
        payButton.addTarget(self, action: #selector(payButtonPressed), for: .touchUpInside)
        
        totalView.addSubview(payButton)
    }
}
