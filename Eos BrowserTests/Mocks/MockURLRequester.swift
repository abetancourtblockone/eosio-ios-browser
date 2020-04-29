//
//  MockURLRequester.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
@testable import Eos_Browser

final class MockURLRequester: URLRequester {
    var mock_request: MockFunction<(URLRequest, URLRequestHandler), Void> = .init({ _,_ in })
    
    func request(urlRequest: URLRequest, completion: @escaping URLRequestHandler) {
        mock_request.execute((urlRequest, completion))
    }
}
