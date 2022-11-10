//
//  CartController.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import UIKit

class CartController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        
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
    
    let totalItems = ShoppingCart.sharedCart.totalItems
    let totalCost = ShoppingCart.sharedCart.totalCost
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        navigationItem.title = "Cart"
        
        setupTableView()
        setupTotalView()
        
        tableView.reloadData()
    }
}

//MARK: - setup table view
extension CartController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.identifier, for: indexPath) as! ItemCell
        
        let totalPerItem = totalItems[indexPath.row]
        totalPriceLabel.text = CurrencyFormatter.rupiahFormatter.string(from: totalCost)
        
        cell.configure(mainText: "\(totalPerItem.countryName) pizza (\(totalPerItem.picked!))",
                       secondaryText: CurrencyFormatter.rupiahFormatter.string(from: totalPerItem.picked! * totalPerItem.intPrice) ?? "IDR 0")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - setup views
private extension CartController {
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
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
