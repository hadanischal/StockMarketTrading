//
//  PaymentValidationTests.swift
//  StockMarketTradingTests
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import XCTest
import Quick
import Nimble
import Cuckoo
import RxTest
import RxSwift

@testable import StockMarketTrading

final class PaymentValidationTests: QuickSpec {

    override func spec() {
        var testValidation: PaymentValidation!

        describe("PaymentValidation") {
            beforeEach {
                testValidation = PaymentValidation()
            }

            describe("validateAmounts") {
                it("emits ValidationResult empty for empty string") {
                    let res = testValidation.validateAmounts("")
                    expect(res).to(equal(ValidationResult.empty))
                }

                it("emits ValidationResult failed for alphabet") {
                    let res = testValidation.validateAmounts("asdasd")
                    expect(res).to(equal(ValidationResult.failed(message: "Amount badly formatted")))
                }

                it("emits ValidationResult valid for valid number") {
                    let res = testValidation.validateAmounts("111111")
                    expect(res).to(equal(ValidationResult.valid(message: "111111")))
                }

                it("emits ValidationResult valid for valid number") {
                    let res = testValidation.validateAmounts("574157")
                    expect(res).to(equal(ValidationResult.valid(message: "574157")))
                }

                it("emits ValidationResult valid for valid number") {
                    let res = testValidation.validateAmounts("574157.12")
                    expect(res).to(equal(ValidationResult.valid(message: "574157.12")))
                }

                it("emits ValidationResult failed for invalid number") {
                    let res = testValidation.validateAmounts("574157.1234")
                    expect(res).to(equal(ValidationResult.failed(message: "Amount badly formatted")))
                }
            }

            describe("validateUnits") {
                it("emits ValidationResult empty for empty string") {
                    let res = testValidation.validateUnits("")
                    expect(res).to(equal(ValidationResult.empty))
                }

                it("emits ValidationResult failed for alphabet") {
                    let res = testValidation.validateUnits("asdasd")
                    expect(res).to(equal(ValidationResult.failed(message: "Unit badly formatted")))
                }

                it("emits ValidationResult valid for valid number") {
                    let res = testValidation.validateUnits("111111")
                    expect(res).to(equal(ValidationResult.valid(message: "111111")))
                }

                it("emits ValidationResult valid for valid number") {
                    let res = testValidation.validateUnits("574157")
                    expect(res).to(equal(ValidationResult.valid(message: "574157")))
                }
            }

        }
    }
}
