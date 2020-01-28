//
//  ValidationUtils.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

struct ValidationUtils {
    static let validationRegex = "^\\$?[0-9, ]*(\\.[0-9]{0,2})?$"

    // validate two digit decimal value
    static func isValid(amount: String) -> Bool {
        let amountRegex = validationRegex // "[0-9]+(\\.[0-9][0-9]?)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", amountRegex)
        return predicate.evaluate(with: amount)
    }

    // validate two digit decimal value
    static func isValid(units: String) -> Bool {
        let unitsRegex = validationRegex //"[0-9]+(\\.[0-9][0-9]?)?"
        let predicate = NSPredicate(format: "SELF MATCHES %@", unitsRegex)
        return predicate.evaluate(with: units)
    }
}
//"^\\$?[0-9, ]*$"
//"^\\$?[0-9, ]*(\\.[0-9]{0,2})?$"
//"^[0-9.]*$"
