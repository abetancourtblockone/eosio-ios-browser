//
//  RetrieveBlocksDecorator.swift
//  Eos Browser iOS
//
//  Created by Angel Betancourt on 12/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import EOSIOSDomain

struct RetrieveBlocksDecorator: RetrieveBlocks {
    let retrieveBlocks: RetrieveBlocks
    let blocksStorage: BlocksStorage
    
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping RetrieveBlocksHandler) {
        retrieveBlocks.execute(quantityOfBlocksToBeRetrieved: quantityOfBlocksToBeRetrieved) { result in
            guard case .success(let info) = result else {
                completion(result)
                return
            }
            self.blocksStorage.save(block: info.lastRetrievedBlock)
            completion(result)
        }
    }
}
