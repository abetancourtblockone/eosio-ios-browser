//
//  BlocksService.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

public struct ServiceError: LocalizedError {
    let message: String
    public var errorDescription: String? {
        message
    }
    
    public init(message: String) {
        self.message = message
    }
}

public typealias RetrieveBlockResult = Result<Block, Error>
public typealias RetrieveBlockHandler = (RetrieveBlockResult) -> ()

public typealias RetrieveBlockchainResult = Result<Blockchain, Error>
public typealias RetrieveBlockchainHandler = (RetrieveBlockchainResult) -> ()

public protocol BlocksService {
    func retrieve(blockId: String, completion: @escaping RetrieveBlockHandler)
    func retrieveBlockchain(completion: @escaping RetrieveBlockchainHandler)
    func cancelRequests()
}
