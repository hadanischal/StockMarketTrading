// MARK: - Mocks generated from file: StockMarketTrading/APIWrappers/PaymentsNetwork.swift at 2020-01-09 07:51:19 +0000

//
//  BlockchainTickerNetwork.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Cuckoo
@testable import StockMarketTrading

import Foundation
import RxSwift


 class MockPaymentsNetworking: PaymentsNetworking, Cuckoo.ProtocolMock {
    
     typealias MocksType = PaymentsNetworking
    
     typealias Stubbing = __StubbingProxy_PaymentsNetworking
     typealias Verification = __VerificationProxy_PaymentsNetworking

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PaymentsNetworking?

     func enableDefaultImplementation(_ stub: PaymentsNetworking) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func getPriceInfo() -> Observable<PriceModel?> {
        
    return cuckoo_manager.call("getPriceInfo() -> Observable<PriceModel?>",
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.getPriceInfo())
        
    }
    
    
    
     func makePayment(_ units: String, _ amount: String) -> Observable<Bool> {
        
    return cuckoo_manager.call("makePayment(_: String, _: String) -> Observable<Bool>",
            parameters: (units, amount),
            escapingParameters: (units, amount),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.makePayment(units, amount))
        
    }
    

	 struct __StubbingProxy_PaymentsNetworking: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func getPriceInfo() -> Cuckoo.ProtocolStubFunction<(), Observable<PriceModel?>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentsNetworking.self, method: "getPriceInfo() -> Observable<PriceModel?>", parameterMatchers: matchers))
	    }
	    
	    func makePayment<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ units: M1, _ amount: M2) -> Cuckoo.ProtocolStubFunction<(String, String), Observable<Bool>> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: units) { $0.0 }, wrap(matchable: amount) { $0.1 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentsNetworking.self, method: "makePayment(_: String, _: String) -> Observable<Bool>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PaymentsNetworking: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func getPriceInfo() -> Cuckoo.__DoNotUse<(), Observable<PriceModel?>> {
	        let matchers: [Cuckoo.ParameterMatcher<Void>] = []
	        return cuckoo_manager.verify("getPriceInfo() -> Observable<PriceModel?>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func makePayment<M1: Cuckoo.Matchable, M2: Cuckoo.Matchable>(_ units: M1, _ amount: M2) -> Cuckoo.__DoNotUse<(String, String), Observable<Bool>> where M1.MatchedType == String, M2.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String, String)>] = [wrap(matchable: units) { $0.0 }, wrap(matchable: amount) { $0.1 }]
	        return cuckoo_manager.verify("makePayment(_: String, _: String) -> Observable<Bool>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PaymentsNetworkingStub: PaymentsNetworking {
    

    

    
     func getPriceInfo() -> Observable<PriceModel?>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<PriceModel?>).self)
    }
    
     func makePayment(_ units: String, _ amount: String) -> Observable<Bool>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<Bool>).self)
    }
    
}


// MARK: - Mocks generated from file: StockMarketTrading/Networking/WebService.swift at 2020-01-09 07:51:19 +0000

//
//  WebService.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 7/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Cuckoo
@testable import StockMarketTrading

import RxSwift


 class MockWebServiceProtocol: WebServiceProtocol, Cuckoo.ProtocolMock {
    
     typealias MocksType = WebServiceProtocol
    
     typealias Stubbing = __StubbingProxy_WebServiceProtocol
     typealias Verification = __VerificationProxy_WebServiceProtocol

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: WebServiceProtocol?

     func enableDefaultImplementation(_ stub: WebServiceProtocol) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        
    return cuckoo_manager.call("load(resource: Resource<T>) -> Observable<T>",
            parameters: (resource),
            escapingParameters: (resource),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.load(resource: resource))
        
    }
    

	 struct __StubbingProxy_WebServiceProtocol: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func load<M1: Cuckoo.Matchable, T: Decodable>(resource: M1) -> Cuckoo.ProtocolStubFunction<(Resource<T>), Observable<T>> where M1.MatchedType == Resource<T> {
	        let matchers: [Cuckoo.ParameterMatcher<(Resource<T>)>] = [wrap(matchable: resource) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockWebServiceProtocol.self, method: "load(resource: Resource<T>) -> Observable<T>", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_WebServiceProtocol: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func load<M1: Cuckoo.Matchable, T: Decodable>(resource: M1) -> Cuckoo.__DoNotUse<(Resource<T>), Observable<T>> where M1.MatchedType == Resource<T> {
	        let matchers: [Cuckoo.ParameterMatcher<(Resource<T>)>] = [wrap(matchable: resource) { $0 }]
	        return cuckoo_manager.verify("load(resource: Resource<T>) -> Observable<T>", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class WebServiceProtocolStub: WebServiceProtocol {
    

    

    
     func load<T: Decodable>(resource: Resource<T>) -> Observable<T>  {
        return DefaultValueRegistry.defaultValue(for: (Observable<T>).self)
    }
    
}


// MARK: - Mocks generated from file: StockMarketTrading/Utility/PaymentValidation/PaymentValidation.swift at 2020-01-09 07:51:19 +0000

//
//  PaymentValidation.swift
//  StockMarketTrading
//
//  Created by Nischal Hada on 9/1/20.
//  Copyright © 2020 Nischal Hada. All rights reserved.
//

import Cuckoo
@testable import StockMarketTrading

import Foundation
import RxSwift


 class MockPaymentValidating: PaymentValidating, Cuckoo.ProtocolMock {
    
     typealias MocksType = PaymentValidating
    
     typealias Stubbing = __StubbingProxy_PaymentValidating
     typealias Verification = __VerificationProxy_PaymentValidating

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: PaymentValidating?

     func enableDefaultImplementation(_ stub: PaymentValidating) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
     func validateUnits(_ units: String) -> ValidationResult {
        
    return cuckoo_manager.call("validateUnits(_: String) -> ValidationResult",
            parameters: (units),
            escapingParameters: (units),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateUnits(units))
        
    }
    
    
    
     func validateAmounts(_ amount: String) -> ValidationResult {
        
    return cuckoo_manager.call("validateAmounts(_: String) -> ValidationResult",
            parameters: (amount),
            escapingParameters: (amount),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.validateAmounts(amount))
        
    }
    

	 struct __StubbingProxy_PaymentValidating: Cuckoo.StubbingProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	
	     init(manager: Cuckoo.MockManager) {
	        self.cuckoo_manager = manager
	    }
	    
	    
	    func validateUnits<M1: Cuckoo.Matchable>(_ units: M1) -> Cuckoo.ProtocolStubFunction<(String), ValidationResult> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: units) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentValidating.self, method: "validateUnits(_: String) -> ValidationResult", parameterMatchers: matchers))
	    }
	    
	    func validateAmounts<M1: Cuckoo.Matchable>(_ amount: M1) -> Cuckoo.ProtocolStubFunction<(String), ValidationResult> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: amount) { $0 }]
	        return .init(stub: cuckoo_manager.createStub(for: MockPaymentValidating.self, method: "validateAmounts(_: String) -> ValidationResult", parameterMatchers: matchers))
	    }
	    
	}

	 struct __VerificationProxy_PaymentValidating: Cuckoo.VerificationProxy {
	    private let cuckoo_manager: Cuckoo.MockManager
	    private let callMatcher: Cuckoo.CallMatcher
	    private let sourceLocation: Cuckoo.SourceLocation
	
	     init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
	        self.cuckoo_manager = manager
	        self.callMatcher = callMatcher
	        self.sourceLocation = sourceLocation
	    }
	
	    
	
	    
	    @discardableResult
	    func validateUnits<M1: Cuckoo.Matchable>(_ units: M1) -> Cuckoo.__DoNotUse<(String), ValidationResult> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: units) { $0 }]
	        return cuckoo_manager.verify("validateUnits(_: String) -> ValidationResult", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	    @discardableResult
	    func validateAmounts<M1: Cuckoo.Matchable>(_ amount: M1) -> Cuckoo.__DoNotUse<(String), ValidationResult> where M1.MatchedType == String {
	        let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: amount) { $0 }]
	        return cuckoo_manager.verify("validateAmounts(_: String) -> ValidationResult", callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
	    }
	    
	}
}

 class PaymentValidatingStub: PaymentValidating {
    

    

    
     func validateUnits(_ units: String) -> ValidationResult  {
        return DefaultValueRegistry.defaultValue(for: (ValidationResult).self)
    }
    
     func validateAmounts(_ amount: String) -> ValidationResult  {
        return DefaultValueRegistry.defaultValue(for: (ValidationResult).self)
    }
    
}

