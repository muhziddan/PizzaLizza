//
//  Pizza.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import Foundation

struct Pizza: Decodable, Hashable {
    let countryName: String
    let price: String
    let countryEmoji: String
    
    var intPrice: Int {
        return Int(price) ?? 0
    }
    var picked: Int?
}
