//
//  URL+Extensions.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

extension URL {
    static func sourcesUrl() -> URL? {
        return URL(string: ApiConstant.baseServerURL)
    }
}

struct ApiConstant {
    static let baseServerURL = "https://blockchain.info/ticker"
}
