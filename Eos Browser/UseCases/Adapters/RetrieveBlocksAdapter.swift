//
//  RetrieveBlockAdapter.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class RetrieveBlocksAdapter: RetrieveBlocks {
    struct Dependencies {
        var blocksService: BlocksService = BlocksServiceAdapter()
    }
    
    private var pendingBlocksToBeRetrived: UInt = 0
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
    
    func execute(quantityOfBlocksToBeRetrieved: UInt, completion: @escaping RetrieveBlocksHandler) {
        pendingBlocksToBeRetrived = quantityOfBlocksToBeRetrieved
        dependencies.blocksService.retrieveBlockchain {[weak self] result in
            self?.handleBlockchainInfo(result: result, completion: completion)
        }
    }
}

private extension RetrieveBlocksAdapter {
    var thereArePendingBlocksToBeRetrieved: Bool { pendingBlocksToBeRetrived > 0 }
    
    func handleBlockchainInfo(result: RetrieveBlockchainResult, completion: @escaping RetrieveBlocksHandler) {
        switch result {
        case .success(let blockchain):
            print("blockchain headBlockId: \(blockchain.headBlockId)")
            startRetrievingBlocks(from: blockchain.headBlockId, completion: completion)
        case .failure(let error):
            completion(.failure(error))
            print("Couldn't retrieve the blockchain info. Error: \(error.localizedDescription)")
        }
    }
    
    func startRetrievingBlocks(from blockId: String, completion: @escaping RetrieveBlocksHandler) {
        dependencies.blocksService.retrieve(blockId: blockId) { result in
            self.handleRetrievedBlock(result: result, completion: completion)
        }
    }
    
    func handleRetrievedBlock(result: RetrieveBlockResult, completion: @escaping RetrieveBlocksHandler) {
        switch result {
        case .success(let block):
            print("Retrieved block: \(block.id.suffix(4))")
            pendingBlocksToBeRetrived -= 1
            handleRetrievedBlock(block, completion: completion)
            
        case .failure(let error):
            print("Couldn't retrieve the block. Error: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    func handleRetrievedBlock(_ block: Block, completion: @escaping RetrieveBlocksHandler) {
        guard thereArePendingBlocksToBeRetrieved else {
            completion(.success(.init(status: .finished, lastRetrievedBlock: block)))
            print("Finished retrieving all blocks")
            return
        }
        completion(.success(.init(status: .fetchingPrevious, lastRetrievedBlock: block)))
        print("Pending blocks to be retrieved: \(pendingBlocksToBeRetrived)")
        retrievePreviousBlock(of: block, completion: completion)
    }
    
    func retrievePreviousBlock(of block: Block, completion: @escaping RetrieveBlocksHandler) {
        dependencies.blocksService.retrieve(blockId: block.previousBlockId) {[weak self] result in
            self?.handleRetrievedBlock(result: result, completion: completion)
            
        }
    }
}
