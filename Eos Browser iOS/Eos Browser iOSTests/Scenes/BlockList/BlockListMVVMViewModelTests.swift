//
//  BlockListMVVMViewModelTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
import Combine
@testable import Eos_Browser
@testable import EOSIOSDomain

final class BlockListMVVMViewModelTests: XCTestCase {
    private var stringsProvider: MockStringsProvider!
    private var retrieveBlocks: MockRetrieveBlocks!
    private var blockDetailSceneDependencies: BlockDetailScene.Dependencies!
    private var sut: BlockListMVVMViewModel!
    
    private var subscriptions = [AnyCancellable]()

    override func setUpWithError() throws {
        stringsProvider = .init()
        retrieveBlocks = .init()
        blockDetailSceneDependencies = .init(stringsProvider: stringsProvider)
        sut = .init(dependencies: .init(stringsProvider: stringsProvider,
                                        retrieveBlocks: retrieveBlocks,
                                        blockDetailSceneDependencies: blockDetailSceneDependencies))
    }

    override func tearDownWithError() throws {
        blockDetailSceneDependencies = nil
        stringsProvider = nil
        retrieveBlocks = nil
        sut = nil
        subscriptions.removeAll()
    }

    func test_SceneDidLoad_UpdateTitle() throws {
        // Given
        let givenTitle = "Mock Title"
        stringsProvider.mock_blockListTitle = givenTitle
        
        let observableHandler = MockFunction<String?, Void>()
        subscriptions.append(sut.titleLabel.sink(receiveValue: observableHandler.execute))
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popLastInvocationInput(), givenTitle,
                       "The received Title must be the given by the strings provider")
    }
    
    func test_HandleRefresh_RetrieveBlocks_Uses20AsBlocksQuantity() throws {
        // Given
        let observableHandler = MockFunction<[BlockListViewModel.Item], Void>()
        subscriptions.append(sut.blocks.sink(receiveValue: observableHandler.execute))
        
        // When
        sut.handleRefresh()
        
        guard let receivedBlocksQuantity = retrieveBlocks.mock_execute.popLastInvocationInput()?.0 else {
            XCTFail("It must call the retrieve blocks usecase")
            return
        }
        // Then
        XCTAssertEqual(receivedBlocksQuantity, UInt(20),
                       "It must call the retrieve blocks usecase with 20 as quantity argument")
    }
    
    func test_RetrieveBlocksSuccess_HandleRefresh_UpdatesBlockViewModels() throws {
        // Given
        let givenBlock: Block = .mock
        mockRetrieveBlocksSuccess(block: givenBlock)
        
        let observableHandler = MockFunction<[BlockListViewModel.Item], Void>()
        subscriptions.append(sut.blocks.sink(receiveValue: observableHandler.execute))
        
        // When
        sut.handleRefresh()
        
        // Then
        let expectedBlockViewModel: BlockListViewModel.Item = .init(id: givenBlock.id,
                                                           producer: givenBlock.producer)
        XCTAssertEqual(observableHandler.popLastInvocationInput(), [expectedBlockViewModel],
                       "The received viewModel is not valid")
    }
    
    func test_HandleRefresh_UpdatesSceneStateToRefreshing() throws {
        // Given
        let observableHandler = MockFunction<BlockListMVVMViewModel.State, Void>()
        subscriptions.append(sut.state.sink(receiveValue: observableHandler.execute))
        
        // When
        sut.handleRefresh()
        
        // Then
        guard case .refreshing = observableHandler.popLastInvocationInput() else {
            XCTFail("When refrshing, the state must be updated to refreshing")
            return
        }
    }
    
    func test_HandleBlockSelection_UpdatesSceneStateToShowingDetail() throws {
        // Given
        let givenBlock: Block = .mock
        mockRetrieveBlocksSuccess(block: givenBlock)
        
        let observableHandler = MockFunction<BlockListMVVMViewModel.State, Void>()
        subscriptions.append(sut.state.sink(receiveValue: observableHandler.execute))
        sut.handleRefresh()
        
        // When
        sut.handleSelectedBlock(at: .init(row: 0, section: 0))
        
        // Then
        guard case .showing(let scene) = observableHandler.popLastInvocationInput() else {
            XCTFail("The received state must be showing an scene")
            return
        }
        XCTAssertEqual(scene.configuration, .init(block: givenBlock),
                       "The received scene configuration must containt the seelcted block")
    }
    
    func test_FinishedRefreshing_HandleRefresh_UpdatesSceneStateToIdle() throws {
        // Given
        mockRetrieveBlocksSuccess(refreshingStatus: .finished)
        let observableHandler = MockFunction<BlockListMVVMViewModel.State, Void>()
        subscriptions.append(sut.state.sink(receiveValue: observableHandler.execute))
        
        // When
        sut.handleRefresh()
        
        // Then
        guard case .idle = observableHandler.popLastInvocationInput() else {
            XCTFail("When refrshing finishes, the state must be updated to idle")
            return
        }
    }
}

private extension BlockListMVVMViewModelTests {
    func mockRetrieveBlocksSuccess(block: Block = .mock,
                                   refreshingStatus: BlocksRetrievingInfo.Status = .fetchingPrevious) {
        let blocksRetrievingInfo: BlocksRetrievingInfo = .init(status: refreshingStatus,
                                                               lastRetrievedBlock: block)
        retrieveBlocks.mock_execute = .init({ $1(.success(blocksRetrievingInfo)) })
    }
}
