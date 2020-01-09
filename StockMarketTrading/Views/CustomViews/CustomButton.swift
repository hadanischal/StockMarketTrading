//
//  CustomButton.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 6/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import UIKit

final class CustomButton: UIButton {

    override func layoutMarginsDidChange() {
        super.layoutMarginsDidChange()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.tintColor = UIColor.clear
        self.setTitleColor(UIColor.white, for: .normal)
        self.setBackgroundColor(UIColor.buttonBaground, for: .normal)
        self.setBackgroundColor(UIColor.buttonBaground, for: .highlighted)
        self.setBackgroundColor(UIColor.buttonBaground, for: .disabled)

        self.clipsToBounds = true
        self.layer.cornerRadius = 8.0

        self.titleLabel?.font = UIFont.textButton
        self.titleLabel?.minimumScaleFactor = 0.5
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    private func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }

    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        context?.setFillColor(color.cgColor)
        context?.fill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
