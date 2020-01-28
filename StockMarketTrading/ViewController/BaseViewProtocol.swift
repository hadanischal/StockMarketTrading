//
//  BaseViewController.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import UIKit
import PKHUD

protocol BaseViewProtocol: class {
    func disable(_ button: UIButton)
    func enable(_ button: UIButton)
}

extension BaseViewProtocol {
    /**
     * Mark button as disabled
     */
    func disableNoAnimate(_ button: UIButton) {
        // And off
        button.isUserInteractionEnabled = false
        button.isEnabled = false
        button.alpha = 0.5
    }
    /**
     * Mark button as disabled
     */
    func disable(_ button: UIButton) {
        // And off
        button.isUserInteractionEnabled = false
        button.isEnabled = false

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.beginFromCurrentState],
                       animations: {
                        button.alpha = 0.5
        },
                       completion: nil)
    }

    /**
     * Mark button as enabled
     */
    func enable(_ button: UIButton) {
        button.isUserInteractionEnabled = true
        button.isEnabled = true

        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.beginFromCurrentState],
                       animations: {
                        button.alpha = 1.0
        },
                       completion: nil)
    }

    func createSpinnerView() {
        // add the spinner in view controller
        HUD.show(.progress)
    }

    func removeSpinnerView() {
        //remove the spinner in view controller
        HUD.hide()
    }
}
