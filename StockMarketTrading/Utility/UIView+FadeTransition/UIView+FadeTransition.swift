//
//  UIView+FadeTransition.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//
///https://stackoverflow.com/questions/3073520/animate-text-change-in-uilabel/27645516#27645516
///https://github.com/SwiftArchitect/SO-3073520

import UIKit

/// Usage: insert view.fadeTransition right before changing content
/// to fade a UILabel (or any UIView for that matter) is to use a Core Animation Transition

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: convertFromCATransitionType(CATransitionType.fade))
    }
}

private func convertFromCATransitionType(_ input: CATransitionType) -> String {
    return input.rawValue
}
