//
//  CurrencyFormatter.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

final class CurrencyFormatter {

    public static var moneyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_AU")
        formatter.numberStyle = .currency
        return formatter
    }()

    /// A formatter that shows money but without decimal numbers
    public static var dollarFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_AU")
        formatter.numberStyle = .currency
        formatter.roundingMode = .floor
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    static var decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_AU")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    static var percentageRateFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.locale = Locale(identifier: "en_AU")
        formatter.roundingMode = NumberFormatter.RoundingMode.halfDown
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        return formatter
    }()
}
