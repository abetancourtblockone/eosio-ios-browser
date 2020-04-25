//
//  URLRequesterAdapter.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class URLRequesterAdapter: URLRequester {
    struct RequestResponseError: Error { let statusCode: Int? }
    
    func request(urlRequest: URLRequest, completion: @escaping URLRequestHandler) {
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let dictionary = json as? [String: Any]
            else {
                struct NotDataError: Error { }
                completion(.failure(NotDataError()))
                return
            }
            completion(.success(dictionary))
        }
        task.resume()
    }
}
