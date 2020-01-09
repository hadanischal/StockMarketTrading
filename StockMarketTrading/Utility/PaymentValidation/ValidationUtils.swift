//
//  ValidationUtils.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

struct ValidationUtils {
    static func isValid(amount: String) -> Bool {
        // validate two digit decimal value
        let amountRegex = "^\\$?[0-9, ]*(\\.[0-9]{0,2})?$" // "[0-9]+(\\.[0-9][0-9]?)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", amountRegex)
        return predicate.evaluate(with: amount)
    }

    static func isValid(units: String) -> Bool {
        // validate two digit decimal value
        let unitsRegex = "^\\$?[0-9, ]*(\\.[0-9]{0,2})?$" //"[0-9]+(\\.[0-9][0-9]?)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", unitsRegex)
        return predicate.evaluate(with: units)
    }
}
//finalFormat = "^\\$?[0-9, ]*$"
//finalFormat = "^\\$?[0-9, ]*(\\.[0-9]{0,2})?$"
//"^[0-9.]*$"
