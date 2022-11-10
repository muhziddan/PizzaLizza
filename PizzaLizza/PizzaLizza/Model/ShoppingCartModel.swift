//
//  ShoppingCartModel.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation

struct ShoppingCartModel {
    
    private let totalItems: MainModel
    
    var displayItemText: String {
        return totalItems.displayItemText
    }
    
    var displayPriceText: String {
        let price = totalItems.intPrice * totalItems.picked
        return CurrencyFormatter.rupiahFormatter.string(from: price) ?? ""
    }
    
    var picked: Int {
        return totalItems.picked
    }
    
    init(totalItems: MainModel) {
        self.totalItems = totalItems
    }
}
