//
//  BlockListViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

struct BlockListViewModel {
    enum Section: CaseIterable {
        case blocks
    }
    struct Item: Hashable {
        let id: String
        let producer: String
        let producerSignature: String
        let transactionsCount: Int
        let previousBlockId: String
        let json: String
    }
}
