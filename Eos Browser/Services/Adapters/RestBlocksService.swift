//
//  RestBlocksService.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

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
            print("Couldn't build the url for retrieving a block")
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
            print("Couldn't build the url for retrieving a blockchain info")
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
}

private extension Blockchain {
    init(dictionary: [String: Any]) {
        self.headBlockId = dictionary["head_block_id"] as? String ?? ""
    }
}

private extension Block {
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.producer = dictionary["producer"] as? String ?? ""
        self.producerSignature = dictionary["producer_signature"] as? String ?? ""
        self.transactionsCount = (dictionary["transactions"] as? [[String: Any]])?.count ?? 0
        self.previousBlockId = dictionary["previous"] as? String ?? ""
        self.json = dictionary.description
    }
}
