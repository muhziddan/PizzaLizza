//
//  ShoppingCart.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingCart {
    static let sharedCart = ShoppingCart()
    
    let pizzas: BehaviorRelay<[MainModel]> = BehaviorRelay(value: [])
}

extension ShoppingCart {
    var totalCost: Int {
        return pizzas.value.reduce(0) { partialResult, pizza in
            partialResult + pizza.intPrice
        }
    }
    
    var totalItems: Observable<[MainModel]> {
        
        return Observable.create { observer -> Disposable in
            
            guard self.pizzas.value.count > 0 else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return Disposables.create { }
            }
            
            let setOfPizzas = Set<MainModel>(self.pizzas.value)
            
            let items: [MainModel] = setOfPizzas.map { pizza in
                let counter: Int = self.pizzas.value.reduce(0) { partialResult, reducePizza in
                    if pizza == reducePizza {
                        return partialResult + 1
                    }
                    
                    return partialResult
                }
                
                var newPizza = pizza
                newPizza.picked = counter
                return newPizza
            }
            observer.onNext(items)
            
            return Disposables.create { }
        }
    }
}
