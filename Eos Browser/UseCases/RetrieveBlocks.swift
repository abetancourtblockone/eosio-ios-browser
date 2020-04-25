//
//  RetrieveBlocks.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

struct BlocksRetrievingInfo {
    enum Status {
        case fetchingPrevious
        case finished
    }
    let status: Status
    let lastRetrievedBlock: Block
}

typealias RetrieveBlocksResult = Result<BlocksRetrievingInfo, Error>
typealias RetrieveBlocksHandler = (RetrieveBlocksResult) -> ()

protocol RetrieveBlocks {
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping RetrieveBlocksHandler)
}
