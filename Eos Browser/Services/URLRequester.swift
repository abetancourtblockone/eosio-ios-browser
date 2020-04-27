//
//  URLRequester.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

typealias URLRequestResponse = Result<[String: Any], Error>
typealias URLRequestHandler = ((URLRequestResponse) -> Void)

protocol URLRequester {
    func request(urlRequest: URLRequest, completion: @escaping URLRequestHandler)
}
