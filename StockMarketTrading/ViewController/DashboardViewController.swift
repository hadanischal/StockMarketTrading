//
//  DashboardViewController.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 6/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftRichString

private struct Theme {
    struct Updated {
        static var dollar =  Style({ (style) -> Void in
            style.color = UIColor.currencyUpdated
            style.font = UIFont.formattedDollar
        })
        static var cent =  Style({ (style) -> Void in
            style.color = UIColor.currencyUpdated
            style.font = UIFont.formattedCent
        })
    }
    struct NotUpdated {
        static var dollar =  Style({ (style) in
            style.color = UIColor.currencyNotUpdated
            style.font = UIFont.formattedDollar
        })
        static var cent =  Style({ (style) in
            style.color = UIColor.currencyNotUpdated
            style.font = UIFont.formattedCent
        })
    }
}

final class DashboardViewController: UIViewController, BaseViewProtocol {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var headerDescriptionLabel: UILabel!

    @IBOutlet weak var sellView: UIView!
    @IBOutlet weak var buyView: UIView!

    @IBOutlet weak var sellTitleLabel: UILabel!
    @IBOutlet weak var buyTitleLabel: UILabel!

    @IBOutlet weak var sellAmountLabel: UILabel!
    @IBOutlet weak var buyAmountLabel: UILabel!

    @IBOutlet weak var spreadTitleLabel: UILabel!
    @IBOutlet weak var spreadDescriptionLabel: UILabel!

    @IBOutlet weak var unitsTitleLabel: UILabel!
    @IBOutlet weak var amountsTitleLabel: UILabel!

    @IBOutlet var unitsTextField: UITextField!
    @IBOutlet var amountsTextField: UITextField!

    @IBOutlet weak var marketView: UIView!
    @IBOutlet weak var marketLabel: UILabel!

    @IBOutlet var proceedButton: UIButton!

    private var viewModel: DashboardDataSource!
    private var priceList: PriceModel?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewSetUp()
        viewModelSetUp()
    }

    private func setupUI() {
        self.navigationItem.title = L10n.DashBoard.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.setCustomStyle()
        self.view.backgroundColor = UIColor.viewBackgroundColor

        headerView.backgroundColor = UIColor.statusColor
        headerDescriptionLabel.backgroundColor = UIColor.headerBuyColor

        sellView.backgroundColor = UIColor.segmentSellUnSelected
        buyView.backgroundColor = UIColor.segmentBuyUnSelected

        unitsTextField.backgroundColor = UIColor.textFiledColor
        amountsTextField.backgroundColor = UIColor.textFiledColor

        spreadTitleLabel.backgroundColor = UIColor.segmentBuyUnSelected
        marketView.backgroundColor = UIColor.primary
    }

    func viewSetUp() {

        headerTitleLabel.textColor = UIColor.white
        headerTitleLabel.font = UIFont.statusTitle

        headerDescriptionLabel.textColor = UIColor.white
        headerDescriptionLabel.font = UIFont.detailTitle

        headerTitleLabel.text = L10n.DashBoard.headerTitle
        headerDescriptionLabel.text = L10n.DashBoard.headerDescription

        //spread by subtracting the SELL price from the BUY price
        spreadTitleLabel.text = L10n.DashBoard.level1Title
        spreadTitleLabel.font = .detailTitle
        spreadDescriptionLabel.font = .detailTitle

        sellTitleLabel.textColor = UIColor.brightOrange
        buyTitleLabel.textColor = UIColor.primary

        unitsTitleLabel.textColor = UIColor.primary
        amountsTitleLabel.textColor = UIColor.primary

        unitsTextField.font = .body1
        unitsTextField.keyboardType = .numbersAndPunctuation
        unitsTextField.layer.borderWidth = 1.0
        unitsTextField.layer.masksToBounds = true
        unitsTextField.layer.cornerRadius = 5.0

        amountsTextField.font = .body1
        amountsTextField.keyboardType = .numbersAndPunctuation
        amountsTextField.layer.borderWidth = 1.0
        amountsTextField.layer.masksToBounds = true
        amountsTextField.layer.cornerRadius = 5.0

        marketLabel.font = .body2
        marketLabel.textColor = UIColor.white

        unitsTextField.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.unitsTextField.layer.borderColor = UIColor.primary.cgColor
            })
            .disposed(by: disposeBag)

        unitsTextField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.unitsTextField.layer.borderColor = UIColor.clear.cgColor
            })
            .disposed(by: disposeBag)

        amountsTextField.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.amountsTextField.layer.borderColor = UIColor.primary.cgColor
            })
            .disposed(by: disposeBag)

        amountsTextField.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.amountsTextField.layer.borderColor = UIColor.clear.cgColor
            })
            .disposed(by: disposeBag)
    }

    private func viewModelSetUp() {
        viewModel = DashboardViewModel()

        viewModel.priceResult
            .observeOn(MainScheduler.instance)
            .flatMap { [weak self] _ -> Observable<()> in
                guard let self = self else { return Observable.empty() }
                return self.updateRateValue(.updated)
                    .andThen(self.timerDelay())
                    .andThen(self.updateRateValue(.notUpdated))
                    .andThen(.just(()))
        }
        .catchErrorJustReturn(())
        .subscribe()
        .disposed(by: disposeBag)

        viewModel
            .errorResult
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showAlertView(withTitle: error.localizedDescription, andMessage: error.localizedDescription)
            })
            .disposed(by: disposeBag)

        viewModel.viewDidLoad()

        let unitsObservable = unitsTextField.rx.text.orEmpty.asObservable()
        let amountsObservable = amountsTextField.rx.text.orEmpty.asObservable()
        let proceedButtonTaps = proceedButton.rx.tap.asObservable()

        viewModel.proceedEnabled
            .subscribe(onNext: { [weak self] enabled  in
                if enabled {
                    self?.enable(self!.proceedButton)
                } else {
                    self?.disable(self!.proceedButton)
                }
            })
            .disposed(by: disposeBag)

        viewModel.proceedComplete
            .filter { $0 == true}
            .subscribe(onNext: { [weak self] _ in
                self?.presentNextView()
            })
            .disposed(by: disposeBag)

        viewModel.proceedFailed
            .subscribe(onNext: { [weak self] msg in
                self?.showAlertView(withTitle: L10n.DashBoard.failedTitle, andMessage: msg)
            })
            .disposed(by: disposeBag)

        viewModel.loaderStatus
            .subscribe(onNext: { [weak self] status in
                if status {
                    self?.createSpinnerView()
                } else {
                    self?.removeSpinnerView()
                }
            })
            .disposed(by: disposeBag)

        viewModel.validatedAmount
            .filter { $0.isValid }
            .map { $0.description }
            .filter { $0 != nil }
            .compactMap { $0}
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] amount in
                self?.amountsTextField.text = amount
            }).disposed(by: disposeBag)

        viewModel.validatedUnits
            .filter { $0.isValid }
            .map { $0.description }
            .filter { $0 != nil }
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] units in
                self?.unitsTextField.text = units
            }).disposed(by: disposeBag)

        viewModel.transformInput(unitsObservable, inputAmount: amountsObservable, confirmTaps: proceedButtonTaps)

    }

    private func updateRateValue(_ type: AppearanceType) -> Completable {
        return Completable.create { completable in
            guard let priceValue = self.viewModel.accountInfo?.first else {
                completable(.completed)
                return Disposables.create {}
            }

            self.updateValue(priceValue, type: type)
            self.sellAmountLabel.fadeTransition(0.5)
            self.buyAmountLabel.fadeTransition(0.5)
            completable(.completed)
            return Disposables.create {}
        }
    }

    private func updateValue(_ priceValue: (key: String, value: PriceModelValue), type: AppearanceType) {
        self.sellAmountLabel.attributedText = self.attributedDescription(NSNumber(value: priceValue.value.sell), type: type)
        self.buyAmountLabel.attributedText = self.attributedDescription(NSNumber(value: priceValue.value.buy), type: type)

        let spreadDescription = priceValue.value.buy - priceValue.value.sell
        self.spreadDescriptionLabel.text = "\(spreadDescription)"
    }

    private func attributedDescription(_ balance: NSNumber, type: AppearanceType) -> AttributedString {

        let styleDollar = type == .updated ? Theme.Updated.dollar : Theme.NotUpdated.dollar
        let styleCent = type == .updated ? Theme.Updated.cent : Theme.NotUpdated.cent

        let dollarsAndCentsBalance = CurrencyFormatter.moneyFormatter.string(from: balance)
        let parts = dollarsAndCentsBalance!.components(separatedBy: ".")

        let attributedBody: AttributedString = parts[0].set(style: styleDollar)
        attributedBody.append(".\(parts[1])".set(style: styleCent))
        return attributedBody
    }

    func timerDelay() -> Completable {
        return Observable.just(true)
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .ignoreElements()
    }

    private func presentNextView() {

    }

    @IBAction func cancelButtonDidPress(_ sender: Any) {
    }

}

extension DashboardViewController: UITextFieldDelegate {
    // max 2 decimal places for fractional part
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let regex = ValidationUtils.validationRegex // "^(?=\\d*\\.?\\d*$)(?!0\\d|\\d{12}|\\d+\\.\\d(0|\\d\\d))"
        guard var amountString = textField.text else {
            return false
        }
        amountString += string

        if amountString.range(of: regex, options: .regularExpression) == nil {
            return false
        }
        return true
    }
}
