//
//  ValidationUtils.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation
import Regex

struct ValidationUtils {
    static let validationRegex = "^\\$?[0-9, ]*(\\.[0-9]{0,2})?$"

    // validate two digit decimal value
    static func isValid(amount: String) -> Bool {
        return amount =~ validationRegex
    }

    // validate two digit decimal value
    static func isValid(units: String) -> Bool {
        return units =~ validationRegex
    }
}
//"^\\$?[0-9, ]*$"
//"^\\$?[0-9, ]*(\\.[0-9]{0,2})?$"
//"^[0-9.]*$"
