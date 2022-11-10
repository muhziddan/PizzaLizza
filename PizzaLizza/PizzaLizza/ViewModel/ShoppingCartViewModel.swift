//
//  ShoppingCartViewModel.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation
import RxSwift

class ShoppingCartViewModel {
    
    private let cartData = ShoppingCart.sharedCart.totalItems
    
    func fetchCartModel() -> Observable<[ShoppingCartModel]> {
        cartData.map { $0.map {
            ShoppingCartModel(totalItems: $0)
        } }
    }
}
