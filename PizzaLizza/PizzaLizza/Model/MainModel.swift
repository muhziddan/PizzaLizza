//
//  PizzaModel.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation

struct MainModel: Hashable {
    
    private let pizza: Pizza
    
    var displayItemText: String {
        return pizza.countryName + " Pizza"
    }
    
    var displayPriceText: String {
        let price = pizza.intPrice
        return CurrencyFormatter.rupiahFormatter.string(from: price) ?? ""
    }
    
    var intPrice: Int {
        return pizza.intPrice
    }
    
    var picked = 0
    
    init(pizza: Pizza) {
        self.pizza = pizza
    }
}
