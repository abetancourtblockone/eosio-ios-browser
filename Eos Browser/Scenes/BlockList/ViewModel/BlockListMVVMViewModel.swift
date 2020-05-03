//
//  BlockListMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import Combine

final class BlockListMVVMViewModel: MVVMViewModel {
    typealias Configuration = Void
    
    enum State {
        case refreshing
        case idle
        case showing(scene: BlockDetailScene)
    }
    
    struct Dependencies {
        var stringsProvider: StringsProviding = StringsProvider()
        var retrieveBlocks: RetrieveBlocks = RetrieveBlocksAdapter()
        var blockDetailSceneDependencies: BlockDetailScene.ViewModel.Dependencies = .init()
    }
    
    private var blockEntities: [Block] = []
    private var blockItems: [BlockListViewModel.Item] = []
    private let dependencies: Dependencies
    
    private let stateValueSubject = PassthroughSubject<State, Never>()
    private let titleLabelValueSubject = PassthroughSubject<String?, Never>()
    private let blocksValueSubject = PassthroughSubject<[BlockListViewModel.Item], Never>()
    
    lazy var state: AnyPublisher<State, Never> = stateValueSubject.eraseToAnyPublisher()
    lazy var titleLabel: AnyPublisher<String?, Never> = titleLabelValueSubject.eraseToAnyPublisher()
    lazy var blocks: AnyPublisher<[BlockListViewModel.Item], Never> = blocksValueSubject.eraseToAnyPublisher()
    
    init(configuration: Configuration = (), dependencies: Dependencies = .init()) {
        self.dependencies = dependencies
    }
}

extension BlockListMVVMViewModel {
    func sceneDidLoad() {
        titleLabelValueSubject.send(dependencies.stringsProvider.blockListTitle)
    }
    
    func handleRefresh() {
        stateValueSubject.send(.refreshing)
        refreshBlocks()
    }
    
    func handleSelectedBlock(at indexPath: IndexPath) {
        let scene = BlockDetailScene(configuration: .init(block: blockEntities[indexPath.row]),
                                     dependencies: dependencies.blockDetailSceneDependencies)
        stateValueSubject.send(.showing(scene: scene))
    }
}

private extension BlockListMVVMViewModel {
    func refreshBlocks() {
        self.blocksValueSubject.send([])
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
        blockItems.append(.init(block: block))
        blocksValueSubject.send(blockItems)
        if blocksRetrievingInfo.status == .finished {
            self.stateValueSubject.send(.idle)
        }
    }
}

private extension BlockListViewModel.Item {
    init(block: Block) {
        self.id = block.id
        self.producer = block.producer
    }
}
