//
//  MockBlocksService.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockBlocksService: BlocksService {
    var mock_retrieveBlock: MockFunction<(String, RetrieveBlockHandler), Void> = .init({ _,_ in  })
    var mock_retrieveBlockchain: MockFunction<RetrieveBlockchainHandler, Void> = .init({ _ in })
    var mock_cancelRequests: MockFunction<Void, Void> = .init({ _ in })
    
    func retrieve(blockId: String, completion: @escaping RetrieveBlockHandler) {
        mock_retrieveBlock.execute((blockId, completion))
    }
    
    func retrieveBlockchain(completion: @escaping RetrieveBlockchainHandler) {
        mock_retrieveBlockchain.execute(completion)
    }
    
    func cancelRequests() {
        mock_cancelRequests.execute(())
    }
}
