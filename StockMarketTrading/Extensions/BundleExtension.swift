//
//  BundleExtension.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 6/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
