//
//  MockBlocksService.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockBlocksService: BlocksService {
    
    var retrieveBlock: (String, RetrieveBlockHandler) -> () = { _,_  in }
    var retrieveBlockchain: (RetrieveBlockchainHandler) -> () = { _  in }
    
    func retrieve(blockId: String, completion: @escaping RetrieveBlockHandler) {
        retrieveBlock(blockId, completion)
    }
    
    func retrieveBlockchain(completion: @escaping RetrieveBlockchainHandler) {
        retrieveBlockchain(completion)
    }
}
