//
//  BlockListMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation


final class BlockListMVVMViewModel {
    enum State {
        case refreshing
        case idle
        case pushing
    }
    struct Dependencies {
        let retrieveBlocks: RetrieveBlocks = RetrieveBlocksAdapter()
    }
    
    var state = Dynamic<State>(.idle)
    var titleLabel = Dynamic<String>("")
    var blocks = Dynamic<[BlockViewModel]>([])
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension BlockListMVVMViewModel {
    func sceneDidLoad() {
        titleLabel.value = "EOSIO Blocchain"
        
    }
    
    func handleRefresh() {
        state.value = .refreshing
        refreshBlocks()
    }
    
    func handleSelectedBlock(at indexPath: IndexPath) {
        print("show block at: \(indexPath.row)")
    }
}

private extension BlockListMVVMViewModel {
    func refreshBlocks() {
        self.blocks.value = []
        dependencies.retrieveBlocks.execute(quantityOfBlocksToBeRetrieved: 20) { result in
            self.handle(retrieveBlocksResult: result)
        }
    }
    
    func handle(retrieveBlocksResult: RetrieveBlocksResult) {
        switch retrieveBlocksResult {
        case .success(let retrievingInfo):
            handle(blocksRetrievingInfo: retrievingInfo)
            
        case .failure(let error):
            print("Couldn't retrieve the blockchain info. Error: \(error.localizedDescription)")
        }
    }
    
    func handle(blocksRetrievingInfo: BlocksRetrievingInfo) {
        blocks.value.append(.init(block: blocksRetrievingInfo.lastRetrievedBlock))
        if blocksRetrievingInfo.status == .finished {
            self.state.value = .idle
        }
    }
}

extension Dynamic where Value: Collection {
    var count: Int { value.count }
    subscript(index: Value.Index) -> Value.Element { return value[index] }
}

private extension BlockViewModel {
    init(block: Block) {
        self.id = block.id
        self.producer = block.producer
    }
}
