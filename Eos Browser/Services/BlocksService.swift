//
//  BlocksService.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

struct ServiceError: LocalizedError {
    let message: String
    var errorDescription: String? {
        message
    }
}

typealias RetrieveBlockResult = Result<Block, Error>
typealias RetrieveBlockHandler = (RetrieveBlockResult) -> ()

typealias RetrieveBlockchainResult = Result<Blockchain, Error>
typealias RetrieveBlockchainHandler = (RetrieveBlockchainResult) -> ()

protocol BlocksService {
    func retrieve(blockId: String, completion: @escaping RetrieveBlockHandler)
    func retrieveBlockchain(completion: @escaping RetrieveBlockchainHandler)
    func cancelRequests()
}
