//
//  URLSessionURLRequester.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class URLSessionURLRequester: URLRequester {
    struct Dependencies {
        var uslSession: URLSession = .shared
        var responseQueue: DispatchQueue = .main
    }
        
    private let dependencies: Dependencies
    private var tasks: [URLSessionDataTask] = []
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func request(urlRequest: URLRequest, completion: @escaping URLRequestHandler) {
        let task = dependencies.uslSession.dataTask(with: urlRequest) {[weak self] (data, response, error) in
            guard let self = self else {
                return
            }
            if let error = error {
                self.notify(response: .failure(error), to: completion)
                return
            }
            if  let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let dictionary = json as? [String: Any]
            {
                self.notify(response: .success(dictionary), to: completion)
            } else {
                self.notify(response: .success([:]), to: completion)
            }
        }
        tasks.append(task)
        task.resume()
    }
    
    func cancelRequests() {
        tasks.forEach { $0.cancel() }
    }
}

private extension URLSessionURLRequester {
    func notify(response: URLRequestResponse, to handler: @escaping URLRequestHandler) {
        dependencies.responseQueue.async {
            handler(response)
        }
    }
}
