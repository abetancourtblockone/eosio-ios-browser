//
//  BlockListMVVMViewModelTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
@testable import Eos_Browser

final class BlockListMVVMViewModelTests: XCTestCase {
    var stringsProvider = MockStringsProvider()
    var retrieveBlocks: MockRetrieveBlocks!
    var sut: BlockListMVVMViewModel!

    override func setUpWithError() throws {
        retrieveBlocks = .init()
        sut = .init(dependencies: .init(stringsProvider: stringsProvider,
                                        retrieveBlocks: retrieveBlocks))
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_SceneDidLoad_UpdateTitle() throws {
        // Given
        let givenTitle = "Mock Title"
        stringsProvider.mock_blockListTitle = givenTitle
        
        let observable = MockObservable<String>()
        sut.titleLabel.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, givenTitle,
                       "The received Title must be the given by the strings provider")
    }
    
    func test_HandleRefresh_RetrieveBlocks() throws {
        // Given
        let mockHandler = MockRetrieveBlocksHandler()
        retrieveBlocks.mock_execute = mockHandler.execute
        
        let observable = MockObservable<[BlockViewModel]>()
        sut.blocks.observe(observable.handler)
        
        // When
        sut.handleRefresh()
        
        // Then

        XCTAssertEqual(mockHandler.receivedBlocksQuantity, 20,
                       "It must call the retrieve blocks usecase with 20 as quantity argument")
    }
    
    func test_RetrieveBlocksSuccess_HandleRefresh_UpdatesBlockViewModels() throws {
        // Given
        let givenBlock: Block = .mock()
        mockRetrieveBlocksSuccess(block: givenBlock)
        
        let observable = MockObservable<[BlockViewModel]>()
        sut.blocks.observe(observable.handler)
        
        // When
        sut.handleRefresh()
        
        // Then
        let expectedBlockViewModel: BlockViewModel = .init(id: givenBlock.id,
                                                           producer: givenBlock.producer)
        XCTAssertEqual(observable.receivedValue, [expectedBlockViewModel],
                       "The received viewModel is not valid")
    }
    
    func test_HandleRefresh_UpdatesStatus() throws {
        // Given
        let observable = MockObservable<BlockListMVVMViewModel.State>()
        sut.state.observe(observable.handler)
        
        // When
        sut.handleRefresh()
        
        // Then
        XCTAssertEqual(observable.receivedValue, .refreshing,
                       "When refrshing, the state must be updated to refreshing")
    }
    
    func test_FinishedRefreshing_HandleRefresh_UpdatesStatus() throws {
        // Given
        mockRetrieveBlocksSuccess(refreshingStatus: .finished)
        let observable = MockObservable<BlockListMVVMViewModel.State>()
        sut.state.observe(observable.handler)
        
        // When
        sut.handleRefresh()
        
        // Then
        XCTAssertEqual(observable.receivedValue, .idle,
                       "When refrshing finishes, the state must be updated to idle")
    }
}

private extension BlockListMVVMViewModelTests {
    func mockRetrieveBlocksSuccess(block: Block = .mock(), refreshingStatus: BlocksRetrievingInfo.Status = .fetchingPrevious) {
        let blocksRetrievingInfo: BlocksRetrievingInfo = .init(status: refreshingStatus,
                                                               lastRetrievedBlock: block)
        retrieveBlocks.mock_execute = { $1(.success(blocksRetrievingInfo)) }
    }
}
