//
//  BlockchainTickerNetwork.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Foundation
import RxSwift

protocol PaymentsNetworking {
    func getPriceInfo() -> Observable<PriceModel?>
    func makePayment(_ units: String, _ amount: String) -> Observable<Bool>
}

final class PaymentsNetwork: PaymentsNetworking {
    var resource: Resource<PriceModel> = {
        let url = URL.sourcesUrl()!
        return Resource(url: url)
    }()

    private let webService: WebServiceProtocol!

    init(withWebService webService: WebServiceProtocol = WebService()) {
        self.webService = webService
    }

    func getPriceInfo() -> Observable<PriceModel?> {
        return self.webService.load(resource: resource)
            .map { list-> PriceModel? in
                return list
            }.asObservable()
            .retry(2)
    }

    //Mock Payment
    func makePayment(_ units: String, _ amount: String) -> Observable<Bool> {
        return Observable.just(true)
            .delay(.seconds(5), scheduler: MainScheduler.instance)
    }

}
