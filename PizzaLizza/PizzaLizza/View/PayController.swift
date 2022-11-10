//
//  PayViewController.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import UIKit

class PayController: UIViewController {
    private let doneImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "DoneImage")
        imageView.image = image
        
        return imageView
    }()
    private let doneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = "Your food will be Processed and Delivered"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    private let menuButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "MainGreen")
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 5.0
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 20
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 25)
        ]
        button.setAttributedTitle(NSAttributedString(string: "Order Again!", attributes: attributes), for: .normal)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MainRed")
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        setupImage()
        setupLabel()
        setupButton()
    }
}

private extension PayController {
    @objc private func orderAgain() {
        ShoppingCart.sharedCart.pizzas.accept([])
        navigationController?.popToRootViewController(animated: true)
    }
}

private extension PayController {
    func setupImage() {
        doneImage.frame = CGRect(x: (view.frame.size.width - 200)/2, y: 150, width: 200, height: 200)
        view.addSubview(doneImage)
    }
    
    func setupLabel() {
        doneLabel.frame = CGRect(x: (view.frame.size.width - 300)/2, y: doneImage.frame.maxY + 50, width: 300, height: 150)
        view.addSubview(doneLabel)
    }
    
    func setupButton() {
        menuButton.frame = CGRect(x: (view.frame.size.width - 300)/2, y: view.frame.maxY - 70, width: 300, height: -60)
        menuButton.addTarget(self, action: #selector(orderAgain), for: .touchUpInside)
        view.addSubview(menuButton)
    }
}
