//
//  Block.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

public struct Block: Equatable {
    let id: String
    let producer: String
    let producerSignature: String
    let transactionsCount: Int
    let previousBlockId: String
    let json: String
    
    public init(id: String,
                producer: String,
                producerSignature: String,
                transactionsCount: Int,
                previousBlockId: String,
                json: String) {
        self.id = id
        self.producer = producer
        self.producerSignature = producerSignature
        self.transactionsCount = transactionsCount
        self.previousBlockId = previousBlockId
        self.json = json
    }
}

extension Block {
    var shortId: String { .init(id.suffix(4)) }
}
