//
//  MainViewModel.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation
import RxSwift

class MainViewModel {
    
    private let pizzaService: PizzaServiceProtocol
    
    init(pizzaService: PizzaServiceProtocol = PizzaService()) {
        self.pizzaService = pizzaService
    }
    
    func fetchPizzaModel() -> Observable<[MainModel]> {
        pizzaService.fetchPizzaData().map { $0.map {
            MainModel(pizza: $0)
        } }
    }
}
