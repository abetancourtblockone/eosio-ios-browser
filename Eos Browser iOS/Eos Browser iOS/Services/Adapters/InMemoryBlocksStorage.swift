//
//  InMemoryBlocksStorage.swift
//  Eos Browser iOS
//
//  Created by Angel Betancourt on 12/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import EOSIOSDomain

final class InMemoryBlocksStorage: BlocksStorage {
    private var blocks = [Block]()
    
    func save(block: Block) {
        blocks.append(block)
    }
    
    func retrieveAll() -> [Block] {
        blocks
    }
}
