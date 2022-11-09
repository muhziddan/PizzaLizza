//
//  PizzaService.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import Foundation

class PizzaService {
    
    func fetchPizzaData() -> [Pizza]? {
        guard let bundlePath = Bundle.main.url(forResource: "Data", withExtension: "json") else {return nil}
        
        guard let jsonData = try? Data(contentsOf: bundlePath) else {return nil}
        
        guard let parsedData = parseJSON(with: jsonData) else {return nil}
        
        return parsedData
    }
    
    func parseJSON(with pizzaData: Data) -> [Pizza]? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode([Pizza].self, from: pizzaData)
            return decodedData
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
