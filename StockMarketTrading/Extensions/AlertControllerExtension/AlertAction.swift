//
//  AlertAction.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 6/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import UIKit

public struct AlertAction {

    public let title: String
    public let type: Int
    public let style: UIAlertAction.Style

    public init(title: String,
                type: Int = 0,
                style: UIAlertAction.Style = .default) {
        self.title = title
        self.type = type
        self.style = style
    }
}
