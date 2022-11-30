//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpateApiFail(error: Error)
    func didUpdateApi(price: String)
}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "AC975178-D038-40C7-A2F5-E87266206694"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(currency: String = "USD") {
        performRequest(urlString: "\(baseURL)/\(currency)?apikey=\(apiKey)")
    }
    
    func performRequest(urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create URL Session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) {(data,response,error) in
                if error != nil {
                    delegate?.didUpateApiFail(error: error!)
                    return
                }
                
                if let safeData = data {
                    // parseJSON
                    if let coinPrice = self.parseJSON(priceData: safeData) {
                        delegate?.didUpdateApi(price: coinPrice)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(priceData: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinPriceData.self, from: priceData)
            let rate = decodedData.rate
                        
            return String(format: "%.2f", rate)
        } catch {
            delegate?.didUpateApiFail(error: error)
            return nil
        }
    }
}

