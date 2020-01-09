//
//  Style+Extension.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation
import SwiftRichString

//https://github.com/malcommac/SwiftRichString
extension Style {
    func withColor(_ color: ColorConvertible) -> Style {
        return self.byAdding { $0.color = color }
    }
}
