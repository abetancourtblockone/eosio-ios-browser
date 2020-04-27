//
//  MockRetrieveBlocks.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockRetrieveBlocks: RetrieveBlocks {
    var execute: (UInt, RetrieveBlocksHandler) -> () = { _,_  in }
    
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping RetrieveBlocksHandler) {
        execute(quantityOfBlocksToBeRetrieved, completion)
    }
}
