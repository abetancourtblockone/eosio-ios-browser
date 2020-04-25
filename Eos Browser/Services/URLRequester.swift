//
//  URLRequester.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

typealias URLRequestHandler = ((Result<[String: Any], Error>) -> Void)
protocol URLRequester {
    func request(urlRequest: URLRequest, completion: @escaping URLRequestHandler)
}
