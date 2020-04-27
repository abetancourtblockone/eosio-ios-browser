//
//  MockRetrieveBlocks.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockRetrieveBlocks: RetrieveBlocks {
    var mock_execute: (UInt, @escaping RetrieveBlocksHandler) -> () = { _,_  in }
    
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping  RetrieveBlocksHandler) {
        mock_execute(quantityOfBlocksToBeRetrieved, completion)
    }
}

final class MockRetrieveBlocksHandler {
    lazy var execute: (UInt, @escaping RetrieveBlocksHandler) -> () = {
        self.receivedBlocksQuantity = $0
        self.receivedCompletion = $1
    }
    var receivedCompletion: RetrieveBlocksHandler?
    var receivedBlocksQuantity: UInt?
}
