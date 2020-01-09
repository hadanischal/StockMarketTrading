//
//  ValidationResult.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

enum ValidationResult: Equatable {
    case valid(message: String?)
    case empty
    case failed(message: String)
}

extension ValidationResult {
    var description: String? {
        switch self {
        case let .valid(message):
            return message
        case .empty:
            return nil
        case let .failed(message):
            return message
        }
    }

    var isValid: Bool {
        switch self {
        case .valid:
            return true
        default:
            return false
        }
    }
}
