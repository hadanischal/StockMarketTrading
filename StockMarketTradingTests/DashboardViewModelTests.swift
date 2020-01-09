//
//  DashboardViewModelTests.swift
//  StockMarketTradingTests
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//
//swiftlint:disable all

import XCTest
import Quick
import Nimble
import Cuckoo
import RxTest
import RxBlocking
import RxSwift
@testable import StockMarketTrading

final class DashboardViewModelTests: QuickSpec {

    override func spec() {
        var testViewModel: DashboardViewModel!
        var mockPaymentsNetworking: MockPaymentsNetworking!
        var mockPaymentValidating: MockPaymentValidating!
        var testScheduler: TestScheduler!
        let mockPriceModel: PriceModel = MockData().stubPaymentsNetwork()!

        var buttonTapInput: Observable<Void>!
        var buttonNotTapInput: Observable<Void>!
        var stringInput: Observable<String>!
        var stringNoInput: Observable<String>!

        describe("DashboardViewModel") {
            beforeEach {
                testScheduler = TestScheduler(initialClock: 0)

                buttonTapInput = testScheduler.createColdObservable([Recorded.next(10, ())]).asObservable()
                buttonNotTapInput = testScheduler.createColdObservable([]).asObservable()
                stringInput = testScheduler.createColdObservable([Recorded.next(10, "123456")]).asObservable()
                stringNoInput = Observable.empty()

                mockPaymentsNetworking = MockPaymentsNetworking()
                stub(mockPaymentsNetworking, block: { stub in
                    when(stub.getPriceInfo()).thenReturn(Observable.just(mockPriceModel))
                    when(stub.makePayment(any(), any())).thenReturn(Observable.just(true))
                })

                mockPaymentValidating = MockPaymentValidating()
                stub(mockPaymentValidating) { (stub) in
                    when(stub.validateAmounts(any())).thenReturn(ValidationResult.empty)
                    when(stub.validateUnits(any())).thenReturn(ValidationResult.empty)
                }

                testViewModel = DashboardViewModel(withSourcesHandler: mockPaymentsNetworking, validationService: mockPaymentValidating)
            }

            describe("Get Price Info from PaymentsNetworking") {

                context("when get request succeed ") {
                    beforeEach {
                        stub(mockPaymentsNetworking, block: { stub in
                            when(stub.getPriceInfo()).thenReturn(Observable.just(mockPriceModel))
                        })
                        testViewModel.viewDidLoad()
                    }
                    it("it call PaymentsNetworking for Price info") {
                        verify(mockPaymentsNetworking).getPriceInfo()
                    }
                    it("update Price accountInfo to updated value") {
                        let correctResult: PriceModel = mockPriceModel.filter { $0.key == "GBP" }
                        expect(testViewModel.accountInfo?.count).to(equal(1))
                        expect(testViewModel.accountInfo).to(equal(correctResult))
                    }
                    it("emits the Price Result to the UI") {
                        testScheduler.scheduleAt(300) {
                            testViewModel.viewDidLoad()
                        }
                        let res = testScheduler.start { testViewModel.priceResult.asObservable() }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(300, mockPriceModel)]
                        expect(res.events).to(equal(correctResult))
                    }
                }

                context("when get Price request failed ") {
                    beforeEach {
                        stub(mockPaymentsNetworking, block: { stub in
                            when(stub.getPriceInfo()).thenReturn(Observable.error(RxError.noElements))
                        })
                        testViewModel.viewDidLoad()
                    }
                    it("it call PaymentsNetworking for Price info") {
                        verify(mockPaymentsNetworking).getPriceInfo()
                    }
                    it("update Price accountInfo to updated value") {
                        expect(testViewModel.accountInfo?.count).to(beNil())
                        expect(testViewModel.accountInfo).to(beNil())
                    }

                    it("doesnt emits Price Result to the UI") {
                        let res = testScheduler.start { testViewModel.priceResult.asObservable() }
                        expect(res.events).to(beEmpty())
                    }
                }
            }
            describe("When user input Units value") {
                // Update priceList
                beforeEach {
                    testScheduler.scheduleAt(300, action: {
                        testViewModel.viewDidLoad()
                    })
                }

                context("When PaymentValidating returns ValidationResult empty") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.empty)
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.empty)
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringNoInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.empty)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<ValidationResult>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(200, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }
                }

                context("When MockPaymentValidating returns ValidationResult valid") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.valid(message: "1234"))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.valid(message: "1234"))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringNoInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.valid(message: "1234"))]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("emits calculated Amount value result to UI i.e (BUY price * units value).") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.valid(message: "7098930.52"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(200, false), Recorded.next(310, true)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                }

                context("When MockPaymentValidating returns ValidationResult failed") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.failed(message: "Mock Message"))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.failed(message: "Mock Message"))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringNoInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.failed(message: "Mock Message"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<ValidationResult>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(200, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                }
            }
            describe("When user input Amounts value") {
                beforeEach {
                    // Update priceList
                    testScheduler.scheduleAt(300, action: {
                        testViewModel.viewDidLoad()
                    })
                }

                context("When PaymentValidating returns ValidationResult empty") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.empty)
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.empty)
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringNoInput, inputAmount: stringInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("doesn't emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<ValidationResult>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.empty)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(200, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }
                }

                context("When MockPaymentValidating returns ValidationResult valid") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.valid(message: "1234"))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.valid(message: "1234"))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringNoInput, inputAmount: stringInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("emits calculated Units result to UI i.e (amount value/ BUY price). ") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.valid(message: "0.21"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.valid(message: "1234"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(200, false), Recorded.next(310, true)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                }

                context("When MockPaymentValidating returns ValidationResult failed") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.failed(message: "Mock Message"))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.failed(message: "Mock Message"))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringNoInput, inputAmount: stringInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("doesn't emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<ValidationResult>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.failed(message: "Mock Message"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(200, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }
                }
            }

            describe("When button is tapped") {
                context("When validateAmounts and validateUnits is empty") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.empty)
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.empty)
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringInput, confirmTaps: buttonTapInput)
                        }
                    }
                    it("emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.empty)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.empty)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(200, false), Recorded.next(310, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, true)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(310, true), Recorded.next(310, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                }

                context("When MockPaymentValidating returns ValidationResult valid") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.valid(message: nil))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.valid(message: nil))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringInput, confirmTaps: buttonTapInput)
                        }
                    }
                    it("emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.valid(message: nil))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.valid(message: nil))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(200, false), Recorded.next(310, true)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, true)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(310, true), Recorded.next(310, false)]
                        expect(res.events).to(equal(correctResult))
                    }

                }
                context("When MockPaymentValidating returns ValidationResult failed") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.failed(message: "Mock Message"))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.failed(message: "Mock Message"))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringInput, confirmTaps: buttonTapInput)
                        }
                    }
                    it("emits validatedUnits result to UI") {
                        let res = testScheduler.start { testViewModel.validatedUnits }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.failed(message: "Mock Message"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits validatedAmount result to UI") {
                        let res = testScheduler.start { testViewModel.validatedAmount }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, ValidationResult.failed(message: "Mock Message"))]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits proceedEnabled result to UI") {
                        let res = testScheduler.start { testViewModel.proceedEnabled }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(200, false), Recorded.next(310, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                    it("emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, true)]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(310, true), Recorded.next(310, false)]
                        expect(res.events).to(equal(correctResult))
                    }
                }

                context("When mockPaymentsNetworking returns fail valid") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.valid(message: nil))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.valid(message: nil))
                        }

                        stub(mockPaymentsNetworking, block: { stub in
                            when(stub.makePayment(any(), any())).thenReturn(Observable.error(mockError))
                        })

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringInput, confirmTaps: buttonTapInput)
                        }
                    }

                    it("emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(1))
                        let correctResult = [Recorded.next(310, "Error contacting server")]
                        expect(res.events).to(equal(correctResult))
                    }

                    it("emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(310, true), Recorded.next(310, false)]
                        expect(res.events).to(equal(correctResult))
                    }

                }
            }

            describe("When button is not tapped") {
                context("When MockPaymentValidating returns ValidationResult valid") {
                    beforeEach {
                        stub(mockPaymentValidating) { (stub) in
                            when(stub.validateAmounts(any())).thenReturn(ValidationResult.valid(message: nil))
                            when(stub.validateUnits(any())).thenReturn(ValidationResult.valid(message: nil))
                        }

                        testScheduler.scheduleAt(300) {
                            testViewModel.transformInput(stringInput, inputAmount: stringInput, confirmTaps: buttonNotTapInput)
                        }
                    }
                    it("doesn't emits proceedComplete result to UI") {
                        let res = testScheduler.start { testViewModel.proceedComplete }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits proceedFailed result to UI") {
                        let res = testScheduler.start { testViewModel.proceedFailed }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<String>>] = []
                        expect(res.events).to(equal(correctResult))
                    }

                    it("doesn't emits loaderStatus result to UI") {
                        let res = testScheduler.start { testViewModel.loaderStatus }
                        expect(res.events.count).to(equal(0))
                        let correctResult: [Recorded<Event<Bool>>] = []
                        expect(res.events).to(equal(correctResult))
                    }
                }
            }
        }
    }
}
