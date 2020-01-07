//
//  PriceModel.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

// MARK: - PriceModelValue
struct PriceModelValue: Codable, Equatable {
    let the15M, last, buy, sell: Double
    let symbol: String

    enum CodingKeys: String, CodingKey {
        case the15M = "15m"
        case last, buy, sell, symbol
    }
}

typealias PriceModel = [String: PriceModelValue]

//   let priceModel = try? newJSONDecoder().decode(PriceModel.self, from: jsonData)
