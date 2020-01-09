//
//  PaymentValidation.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation
import RxSwift

protocol PaymentValidating: class {
    func validateUnits(_ units: String) -> ValidationResult
    func validateAmounts(_ amount: String) -> ValidationResult
}

final class PaymentValidation: PaymentValidating {

    func validateUnits(_ units: String) -> ValidationResult {
        if units.isEmpty {
            return .empty
        }
        if !ValidationUtils.isValid(units: units) {
            return .failed(message: L10n.DashBoard.unitError)
        }
        return .valid(message: units)
    }

    func validateAmounts(_ amount: String) -> ValidationResult {
        if amount.isEmpty {
            return .empty
        }
        if !ValidationUtils.isValid(amount: amount) {
            return .failed(message: L10n.DashBoard.amountError)
        }
        return .valid(message: amount)
    }
}
