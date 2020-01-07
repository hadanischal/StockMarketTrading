//
//  MockData.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation
import XCTest
@testable import StockMarketTrading

class MockData {

    func stubPaymentsNetwork() -> PriceModel? {
        guard let data = self.getData() else {
            XCTAssert(false, "Can't get data from jobs.json")
            return nil
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let result = try? decoder.decode(PriceModel.self, from: data) {
            return result
        } else {
            XCTAssert(false, "Unable to parse ArticlesList results")
            return nil
        }
    }

    func getData() -> Data? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "PaymentsNetwork", withExtension: "json") else {
            XCTFail("Missing file: PaymentsNetwork.json")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            XCTFail("unable to read json")
            return nil
        }
    }
}
