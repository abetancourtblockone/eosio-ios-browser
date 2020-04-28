//
//  MockBlocksService.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockBlocksService: BlocksService {
    var mock_retrieveBlock: MockInvocation<(String, RetrieveBlockHandler), Void> = .init({ _,_ in  })
    var mock_retrieveBlockchain: MockInvocation<RetrieveBlockchainHandler, Void> = .init({ _ in })
    
    func retrieve(blockId: String, completion: @escaping RetrieveBlockHandler) {
        mock_retrieveBlock.execute((blockId, completion))
    }
    
    func retrieveBlockchain(completion: @escaping RetrieveBlockchainHandler) {
        mock_retrieveBlockchain.execute(completion)
    }
}
