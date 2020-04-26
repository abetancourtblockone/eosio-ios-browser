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
        case showing(scene: BlockDetailScene)
    }
    struct Dependencies {
        let retrieveBlocks: RetrieveBlocks = RetrieveBlocksAdapter()
    }
    
    var state = Dynamic<State>(.idle)
    var titleLabel = Dynamic<String>("")
    var blocks = Dynamic<[BlockViewModel]>([])
    
    private var blockEntities: [Block] = []
    
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
        let scene = BlockDetailScene(viewModel: .init(block: blockEntities[indexPath.row]))
        self.state.value = .showing(scene: scene)
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
        let block = blocksRetrievingInfo.lastRetrievedBlock
        blockEntities.append(block)
        blocks.value.append(.init(block: block))
        if blocksRetrievingInfo.status == .finished {
            self.state.value = .idle
        }
    }
}

private extension BlockViewModel {
    init(block: Block) {
        self.id = block.id
        self.producer = block.producer
    }
}
