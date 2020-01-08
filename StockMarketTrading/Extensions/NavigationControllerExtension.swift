//
//  NavigationControllerExtension.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 6/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setCustomStyle()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    func setCustomStyle() {
        navigationBar.isTranslucent = false
        //To tint the bar's items
        navigationBar.tintColor = .titleTintColor
        //To tint the bar's background
        navigationBar.barTintColor = .barTintColor
//        navigationItem.hidesBackButton = true

        navigationBar.titleTextAttributes = [.font: UIFont.navigationBarTitle,
                                             .foregroundColor: UIColor.titleTintColor]

        let attributes = [NSAttributedString.Key.font: UIFont.navigationBarButtonItem]

        UIBarButtonItem
            .appearance()
            .setTitleTextAttributes(attributes,
                                    for: UIControl.State.normal)

        view.backgroundColor = .barTintColor
        navigationBar.barStyle = .black
        navigationBar.prefersLargeTitles = false

    }

    func configureNavigationBar() {
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.black
        let attributes = [
            NSAttributedString.Key.font: UIFont.navigationBarTitle,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        navigationBar.titleTextAttributes = attributes

        let buttonAttributes = [NSAttributedString.Key.font: UIFont.navigationBarButtonItem]

        UIBarButtonItem
            .appearance()
            .setTitleTextAttributes(buttonAttributes,
                                    for: UIControl.State.normal)
    }
}
