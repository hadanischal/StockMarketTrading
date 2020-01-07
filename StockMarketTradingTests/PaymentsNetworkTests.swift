//
//  PaymentsNetworkTests.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Cuckoo
import RxTest
import RxBlocking
import RxSwift
@testable import StockMarketTrading

class PaymentsNetworkTests: QuickSpec {

    override func spec() {
        var testHandler: PaymentsNetwork!
        var mockWebService: MockWebServiceProtocol!
        var testScheduler: TestScheduler!
        let mockPriceModel = MockData().stubPaymentsNetwork()

        describe("PaymentsNetwork") {
            beforeEach {
                testScheduler = TestScheduler(initialClock: 0)
                mockWebService = MockWebServiceProtocol()

                stub(mockWebService, block: { stub in
                    when(stub.load(resource: any(Resource<PriceModel>.self))).thenReturn(Observable.empty())
                })
                testHandler = PaymentsNetwork(withWebService: mockWebService)
            }

            describe("Get Price List server") {
                context("when get Price List server request succeed") {
                    beforeEach {
                        stub(mockWebService, block: { stub in
                            when(stub.load(resource: any(Resource<PriceModel>.self))).thenReturn(Observable.just(mockPriceModel!))
                        })
                    }
                    it("it call WebService for Price info") {
                        _ = testHandler.getPriceInfo()
                        verify(mockWebService).load(resource: any(Resource<PriceModel>.self))
                    }
                    it("emits the Price list to the UI") {
                        let observable = testHandler.getPriceInfo().asObservable()

                        let res = testScheduler.start { observable }
                        expect(res.events.count).to(equal(2))
                        let correctResult = [Recorded.next(200, mockPriceModel),
                                             Recorded.completed(200)]
                        expect(res.events).to(equal(correctResult))
                    }
                }

                context("when get Price List from server request failed ") {

                    beforeEach {
                        stub(mockWebService, block: { stub in
                            when(stub.load(resource: any(Resource<PriceModel>.self))).thenReturn(Observable.error(mockError))
                        })
                    }
                    it("it call WebService for Price info") {
                        _ = testHandler.getPriceInfo().asObservable()
                        verify(mockWebService).load(resource: any(Resource<PriceModel>.self))
                    }
                    it("emits the Price list to the UI") {
                        let observable = testHandler.getPriceInfo().asObservable()

                        let res = testScheduler.start { observable }
                        expect(res.events.count).to(equal(1))
                        let correctResult: [Recorded<Event<PriceModel?>>] = [Recorded.error(200, mockError, PriceModel?.self) ]
                        expect(res.events).to(equal(correctResult))
                    }
                }
            }

            //Mock payment for time being
            describe("When make Payment request") {
                context("when server request complete  successfully") {
                    var result: [Bool]?
                    beforeEach {
                        //timeout = 6 since we have timer delay .seconds(5)
                        result = try? testHandler.makePayment("Mock Unit", "Mock Amount").toBlocking(timeout: 6).toArray()
                    }

                    it("emits the image to the UI", closure: {
                        let correctResult: [Bool] = [true]
                        expect(result?.count).to(equal(1))
                        expect(result).to(equal(correctResult))
                    })

                }
            }
        }
    }
}
