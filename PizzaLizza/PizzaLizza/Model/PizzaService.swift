//
//  PizzaService.swift
//  PizzaLizza
//
//  Created by Muhammad Ziddan Hidayatullah on 09/11/22.
//

import Foundation
import RxSwift

class PizzaService {
    
    func fetchPizzaData() -> Observable<[Pizza]> {
        
        return Observable.create { observer -> Disposable in
            
            guard let bundlePath = Bundle.main.url(forResource: "Data", withExtension: "json") else {
                observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                return Disposables.create { }
            }
            
            do {
                let jsonData = try Data(contentsOf: bundlePath, options: .mappedIfSafe)
                guard let parsedData = self.parseJSON(with: jsonData) else {
                    observer.onError(NSError(domain: "", code: -1, userInfo: nil))
                    return Disposables.create { }
                }
                observer.onNext(parsedData)
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create { }
        }
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
