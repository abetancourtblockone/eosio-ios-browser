//
//  RetrieveBlocks.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

public struct BlocksRetrievingInfo: Equatable {
    public enum Status {
        case fetchingPrevious
        case finished
    }
    public let status: Status
    public let lastRetrievedBlock: Block
}

public typealias RetrieveBlocksResult = Result<BlocksRetrievingInfo, Error>
public typealias RetrieveBlocksHandler = (RetrieveBlocksResult) -> ()

public protocol RetrieveBlocks {
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping RetrieveBlocksHandler)
}
