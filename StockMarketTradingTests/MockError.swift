//
//  MockError.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

enum MockError: Error, Equatable {
    case noElements
}
let mockError = MockError.noElements
