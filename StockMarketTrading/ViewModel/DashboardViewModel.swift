//
//  DashboardViewModel.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation
import RxSwift

protocol DashboardDataSource {
    var priceResult: Observable<PriceModel> { get }
    var errorResult: Observable<Error> { get }
    var accountInfo: PriceModel? { get }

    var validatedUnits: Observable<ValidationResult> { get }
    var validatedAmount: Observable<ValidationResult> { get }
    var proceedEnabled: Observable<Bool> { get } //button status
    var proceedComplete: Observable<Bool> { get }
    var proceedFailed: Observable<String> { get }

    var loaderStatus: Observable<Bool> { get }
    func transformInput(_ inputUnits: Observable<String>, inputAmount: Observable<String>, confirmTaps: Observable<Void>)
    func viewDidLoad()
}

class DashboardViewModel: DashboardDataSource {

    //output
    let priceResult: Observable<PriceModel>
    let errorResult: Observable<Error>
    let validatedUnits: Observable<ValidationResult>
    let validatedAmount: Observable<ValidationResult>
    var accountInfo: PriceModel? {
        self.priceList?.filter { $0.key == "GBP" }
    }

    // Is signup button enabled
    let proceedEnabled: Observable<Bool>
    // Has user signed in
    let proceedComplete: Observable<Bool>
    // Is signing process in progress
    let loaderStatus: Observable<Bool>
    let proceedFailed: Observable<String>

    //input
    private let paymentsNetworking: PaymentsNetworking
    private let validationService: PaymentValidating

    private let priceResultSubject = PublishSubject<PriceModel>()
    private let errorResultSubject = PublishSubject<Error>()

    private let validatedUnitsSubject = PublishSubject<ValidationResult>()
    private let validatedAmountSubject = PublishSubject<ValidationResult>()
    private let proceedEnabledSubject = BehaviorSubject<Bool>(value: false)
    private let proceedCompleteSubject = PublishSubject<Bool>()
    private let proceedFailedSubject = PublishSubject<String>()
    private let loaderStatusSubject = PublishSubject<Bool>()
    private var priceList: PriceModel?

    private let disposeBag = DisposeBag()

    init(withSourcesHandler paymentsNetworking: PaymentsNetworking = PaymentsNetwork(),
         validationService: PaymentValidating = PaymentValidation()) {
        self.paymentsNetworking = paymentsNetworking
        self.validationService = validationService

        self.priceResult = priceResultSubject.asObserver()
        self.errorResult = errorResultSubject.asObserver()

        validatedUnits = validatedUnitsSubject.asObservable()
        validatedAmount = validatedAmountSubject.asObservable()
        proceedEnabled = proceedEnabledSubject.asObservable()
        proceedComplete = proceedCompleteSubject.asObservable()
        proceedFailed = proceedFailedSubject.asObservable()

        loaderStatus = loaderStatusSubject.asObservable()

        priceResultSubject
            .asObservable()
            .subscribe(onNext: { [weak self] result in
                self?.priceList = result
            }).disposed(by: disposeBag)

        // Button status
        updateButtonStatus()

        reloadTask()
    }

    func viewDidLoad() {
        self.updatePaymentsInfo()
    }

    private func updateButtonStatus() {
        Observable
            .combineLatest(validatedUnits, validatedAmount)
            .map { $0.0.isValid && $0.1.isValid}
            .subscribe(onNext: { [weak self] status in
                self?.proceedEnabledSubject.onNext(status)
            }).disposed(by: disposeBag)
    }

    // Reload Price list from server
    private func reloadTask() {
        let scheduler = SerialDispatchQueueScheduler(qos: .default)
        Observable<Int>.interval(.seconds(10), scheduler: scheduler)
            .flatMap { [weak self] _ -> Observable<PriceModel> in
                return self?.getPriceListFromServer() ?? Observable.empty()
        }
        .subscribe(onNext: { [priceResultSubject] result in
            priceResultSubject.onNext(result)
            }, onError: { [errorResultSubject] (error) in
                errorResultSubject.on(.next(error))
        }).disposed(by: disposeBag)
    }

    // Get Price list from server
    func updatePaymentsInfo() {
        self.getPriceListFromServer()
            .subscribe(onNext: { [priceResultSubject] result in
                priceResultSubject.onNext(result)
                }, onError: { [errorResultSubject] (error) in
                    errorResultSubject.on(.next(error))
            }).disposed(by: disposeBag)
    }

    // MARK: - get Price list from Server
    private func getPriceListFromServer() -> Observable<PriceModel> {
        return paymentsNetworking
            .getPriceInfo()
            .retry(2)
            .catchErrorJustReturn(nil)
            .filter { $0 != nil }
            .map { $0! }
    }

    func transformInput(_ inputUnits: Observable<String>, inputAmount: Observable<String>, confirmTaps: Observable<Void>) {

        //Validate Units textfield
        inputUnits
            .map { units in
                return self.validationService.validateUnits(units)
        }
        .share(replay: 1)
        .subscribe(onNext: { result in
            self.validatedUnitsSubject.onNext(result)
            self.updateAmount(withUnit: result)
        }).disposed(by: disposeBag)

        //Validate amount textfield
        inputAmount
            .map { amount in
                return self.validationService.validateAmounts(amount)
        }
        .share(replay: 1)
        .subscribe(onNext: { result in
            self.validatedAmountSubject.onNext(result)
            self.updateUnit(withAmount: result)
        }).disposed(by: disposeBag)

        //Button taps
        let unitsAndAmount = Observable.combineLatest(inputUnits, inputAmount) { (units: $0, amount: $1) }

        confirmTaps
            .withLatestFrom(unitsAndAmount)
            .flatMap { [weak self] result -> Observable<Bool> in
                self?.loaderStatusSubject.onNext(true)
                return self?.makePayment(result.units, result.amount).catchErrorJustReturn(false) ?? Observable.just(false)
        }.subscribe(onNext: { [weak self] status in
            self?.loaderStatusSubject.onNext(false)
            if status {
                self?.proceedCompleteSubject.onNext(true)
            } else {
                self?.proceedFailedSubject.onNext(L10n.DashBoard.serverError)
            }
            }, onError: { error in
                print(error)
        }).disposed(by: disposeBag)

    }

    private func updateAmount(withUnit validationResult: ValidationResult) {
        guard let accountValue = accountInfo, !accountValue.isEmpty else { return }
        guard let buyingRate = accountValue.first?.value.buy else { assertionFailure("rateValue is nil"); return }
        // TODO: update info, determine buy or sale button click action latter

        guard validationResult.isValid,
            let unitValue = validationResult.description,
            let unit = Double(unitValue) else { return }

        let result = unit * buyingRate
        let finalResult = String(result.roundToPlaces())
        validatedAmountSubject.onNext(ValidationResult.valid(message: finalResult))
    }

    private func updateUnit(withAmount validationResult: ValidationResult) {
        guard let accountValue = accountInfo, !accountValue.isEmpty else { return }
        guard let buyingRate = accountValue.first?.value.buy else { assertionFailure("rateValue is nil"); return }
        // TODO: update info, determine buy or sale button click action latter

        guard validationResult.isValid,
            let unitValue = validationResult.description,
            let amount = Double(unitValue) else { return }

        let result = amount / buyingRate
        let finalResult = String(result.roundToPlaces())

        validatedUnitsSubject.onNext(ValidationResult.valid(message: finalResult))
    }

    private func makePayment(_ units: String, _ amount: String) -> Observable<Bool> {
        //Mock payment
        return self.paymentsNetworking.makePayment(units, amount)
    }
}
