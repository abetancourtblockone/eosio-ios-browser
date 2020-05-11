//
//  RestBlocksService.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import EOSIOSDomainMac

final class RestBlocksService: BlocksService {
    struct Dependencies {
        var urlRequester: URLRequester = URLSessionURLRequester()
        var endpointProvider: EndpointProvider = ClassEndpointProvider()
    }
    
    private lazy var getBlockchainInfoURL = URL(string: dependencies.endpointProvider.getBlockchainInfo)
    private lazy var getBlockcURL = URL(string: dependencies.endpointProvider.getBlock)

    private let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func retrieve(blockId: String, completion: @escaping RetrieveBlockHandler) {
        guard let url = getBlockcURL else {
            let error = ServiceError(message: "Couldn't build the url for retrieving a block")
            completion(.failure(error))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: ["block_num_or_id": blockId], options: [])
        
        dependencies.urlRequester.request(urlRequest: urlRequest) { (result) in
            switch result {
            case .success(let responseDisctionary):
                completion(.success(.init(dictionary: responseDisctionary)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func retrieveBlockchain(completion: @escaping RetrieveBlockchainHandler) {
        guard let url = getBlockchainInfoURL else {
            let error = ServiceError(message: "Couldn't build the url for retrieving a blockchain info")
            completion(.failure(error))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        dependencies.urlRequester.request(urlRequest: urlRequest) { (result) in
            switch result {
            case .success(let responseDisctionary):
                completion(.success(.init(dictionary: responseDisctionary)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func cancelRequests() {
        dependencies.urlRequester.cancelRequests()
    }
}

private extension Blockchain {
    init(dictionary: [String: Any]) {
        self.init(headBlockId: dictionary["head_block_id"] as? String ?? "")
    }
}

private extension Block {
    init(dictionary: [String: Any]) {
        self.init(id: dictionary["id"] as? String ?? "",
                  producer: dictionary["producer"] as? String ?? "",
                  producerSignature: dictionary["producer_signature"] as? String ?? "",
                  transactionsCount: (dictionary["transactions"] as? [[String: Any]])?.count ?? 0,
                  previousBlockId: dictionary["previous"] as? String ?? "",
                  json: dictionary.description)
    }
}
