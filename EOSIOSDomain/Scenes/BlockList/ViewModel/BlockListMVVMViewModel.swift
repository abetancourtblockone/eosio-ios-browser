//
//  BlockListMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import Combine

public final class BlockListMVVMViewModel: MVVMViewModel {
    public typealias Configuration = Void
    
    public enum State {
        case refreshing
        case idle
        case showing(scene: BlockDetailScene)
    }
    
    public struct Dependencies {
        var stringsProvider: StringsProviding
        var retrieveBlocks: RetrieveBlocks
        var blockDetailSceneDependencies: BlockDetailScene.ViewModel.Dependencies
        public init(stringsProvider: StringsProviding,
                    retrieveBlocks: RetrieveBlocks,
                    blockDetailSceneDependencies: BlockDetailScene.ViewModel.Dependencies) {
            self.stringsProvider = stringsProvider
            self.retrieveBlocks = retrieveBlocks
            self.blockDetailSceneDependencies = blockDetailSceneDependencies
        }
    }
    
    private var blockEntities: [Block] = []
    private var blockItems: [BlockListViewModel.Item] = []
    private let dependencies: Dependencies
    
    private let stateValueSubject = PassthroughSubject<State, Never>()
    private let titleLabelValueSubject = PassthroughSubject<String?, Never>()
    private let blocksValueSubject = PassthroughSubject<[BlockListViewModel.Item], Never>()
    
    public lazy var state: AnyPublisher<State, Never> = stateValueSubject.eraseToAnyPublisher()
    public lazy var titleLabel: AnyPublisher<String?, Never> = titleLabelValueSubject.eraseToAnyPublisher()
    public lazy var blocks: AnyPublisher<[BlockListViewModel.Item], Never> = blocksValueSubject.eraseToAnyPublisher()
    
    public init(configuration: Configuration = (), dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension BlockListMVVMViewModel {
    public func sceneDidLoad() {
        titleLabelValueSubject.send(dependencies.stringsProvider.blockListTitle)
    }
    
    public func handleRefresh() {
        stateValueSubject.send(.refreshing)
        refreshBlocks()
    }
    
    public func handleSelectedBlock(at indexPath: IndexPath) {
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
