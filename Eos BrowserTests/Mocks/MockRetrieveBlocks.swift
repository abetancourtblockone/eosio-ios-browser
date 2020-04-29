//
//  MockRetrieveBlocks.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockRetrieveBlocks: RetrieveBlocks {
    
    var mock_execute: MockFunction<(UInt, RetrieveBlocksHandler), Void> = .init({ _,_ in  })
    
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping  RetrieveBlocksHandler) {
        mock_execute.execute((quantityOfBlocksToBeRetrieved, completion))
    }
}
