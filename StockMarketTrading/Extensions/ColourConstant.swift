//
//  ColourConstant.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 6/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import UIKit

extension UIColor {
    static var primary: UIColor {
        return ColorName.primary.color
    }
    static var viewBackgroundColor: UIColor {
        return ColorName.charcoal100.color
    }
    static var tableViewBackgroundColor: UIColor {
        return UIColor(rgb: 0xEEEEEE)
    }
    static var barTintColor: UIColor {
        return UIColor(rgb: 0x5c9ac1)
    }
    static var titleTintColor: UIColor {
        return UIColor.white
    }
    static var textFiledColor: UIColor {
        return ColorName.textFieldBaground.color
    }
    static var brightOrange: UIColor {
        return ColorName.brightOrange.color
    }
    static var segmentSelectedTitle: UIColor {
        return UIColor.black
    }
    static var segmentDefaultTitle: UIColor {
        return UIColor.darkGray
    }
    static var segmentSellUnSelected: UIColor {
        return ColorName.sellUnselected.color
    }
    static var segmentBuyUnSelected: UIColor {
        return ColorName.buyUnselected.color
    }
    static var statusColor: UIColor {
        return ColorName.headerColour.color
    }
    static var headerBuyColor: UIColor {
        return ColorName.headerBuy.color
    }

    static var titleColor: UIColor {
        return UIColor.black
    }
    static var cancelButtonColour: UIColor {
        return ColorName.cancelButtonColour.color
    }
    static var buttonBaground: UIColor {
        return ColorName.primary.color
    }
    static var currencyUpdated: UIColor {
        return ColorName.green537.color
    }
    static var currencyNotUpdated: UIColor {
        return UIColor.white
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
