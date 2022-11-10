//
//  CurrencyFormatter.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 10/11/22.
//

import Foundation

enum CurrencyFormatter {
    static let rupiahFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "IDR"
        return formatter
    }()
}

extension NumberFormatter {
    func string(from int: Int) -> String? {
        return string(from: NSNumber(value: int))
    }
}
