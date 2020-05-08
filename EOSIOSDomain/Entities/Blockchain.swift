//
//  Blockchain.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

public struct Blockchain: Equatable {
    public let headBlockId: String
    public init(headBlockId: String) {
        self.headBlockId = headBlockId
    }
}
