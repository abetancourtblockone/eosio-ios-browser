//
//  MockURLRequester.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
@testable import Eos_Browser_iOS

final class MockURLRequester: URLRequester {
    var mock_request = MockFunction<(URLRequest, URLRequestHandler), Void>()
    var mock_cancelRequests = MockFunction<Void, Void>()
    
    func request(urlRequest: URLRequest, completion: @escaping URLRequestHandler) {
        mock_request.execute((urlRequest, completion))
    }
    
    func cancelRequests() {
        mock_cancelRequests.execute(())
    }
}
