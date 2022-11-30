//
//  CoinPriceData.swift
//  ByteCoin
//
//  Created by Duy Do on 11/29/22.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinPriceData: Codable {
    let asset_id_base: String
    let rates: [Rate]
}

struct Rate: Codable {
    let time: String
    let asset_id_quote: String
    let rate: Double
}
