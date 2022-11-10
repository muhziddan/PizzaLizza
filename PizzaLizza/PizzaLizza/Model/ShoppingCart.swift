//
//  ShoppingCart.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation

class ShoppingCart {
    static let sharedCart = ShoppingCart()
    
    var pizzas: [Pizza] = []
}

extension ShoppingCart {
    var totalCost: Int {
        return pizzas.reduce(0) { partialResult, pizza in
            partialResult + pizza.intPrice
        }
    }
    
    var totalItems: [Pizza] {
        
        guard pizzas.count > 0 else {return []}
        
        let setOfPizzas = Set<Pizza>(pizzas)
        
        let items: [Pizza] = setOfPizzas.map { pizza in
            let counter: Int = pizzas.reduce(0) { partialResult, reducePizza in
                if pizza == reducePizza {
                    return partialResult + 1
                }
                
                return partialResult
            }
            
            var newPizza = pizza
            newPizza.picked = counter
            return newPizza
        }
        
        return items
    }
}
