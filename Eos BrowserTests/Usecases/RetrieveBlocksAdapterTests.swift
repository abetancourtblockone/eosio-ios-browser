//
//  RetrieveBlocksAdapterTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
@testable import Eos_Browser

final class RetrieveBlocksAdapterTests: XCTestCase {
    
    var sut: RetrieveBlocksAdapter!
    var blocksService: MockBlocksService!

    override func setUpWithError() throws {
        blocksService = .init()
        sut = .init(dependencies: .init(blocksService: blocksService))
    }

    override func tearDownWithError() throws {
        sut = nil
        blocksService = nil
    }
    
    func test_OneBlockAndBlockchainServiceSucceed_Execute_ReturnsFinishedStatus() throws {
        // Given
        let mockBlock: Block = .mock
        let mockBlcokchain: Blockchain = .init(headBlockId: mockBlock.id)
        blocksService.mock_retrieveBlockchain = .init({ $0(.success(mockBlcokchain)) })
        blocksService.mock_retrieveBlock = .init({ $1(.success(mockBlock)) })
        
        // When
        let mockCompletion: MockInvocation<RetrieveBlocksResult, Void> = .init({ _ in })
        sut.execute(quantityOfBlocksToBeRetrieved: 1, completion: mockCompletion.execute)
        
        // Then
        guard case .success(let receivedRetrievingInfo) = mockCompletion.popFirstInvocationInput() else {
            XCTFail("The result must be a success response if both service calls succeed")
            return
        }
        
        XCTAssertEqual(receivedRetrievingInfo.status, .finished,
                       "The received status must be finished if the number of block is 1")
        XCTAssertEqual(receivedRetrievingInfo.lastRetrievedBlock, mockBlock,
                       "It must return the block returned by the service")
    }
    
    func test_MoreThanOneBlockAndBlockchainServiceSucceed_Execute_ReturnsRetrievingStatus() throws {
        // Given
        let mockBlock: Block = .mock
        let mockBlcokchain: Blockchain = .init(headBlockId: mockBlock.id)
        blocksService.mock_retrieveBlockchain = .init({ $0(.success(mockBlcokchain)) })
        blocksService.mock_retrieveBlock = .init({ $1(.success(mockBlock)) })
        
        // When
        let mockCompletion: MockInvocation<RetrieveBlocksResult, Void> = .init({ _ in })
        sut.execute(quantityOfBlocksToBeRetrieved: 2, completion: mockCompletion.execute)
        
        // Then
        guard case .success(let receivedRetrievingInfo) = mockCompletion.popFirstInvocationInput() else {
            XCTFail("The result must be a success response if both service calls succeed")
            return
        }
        
        XCTAssertEqual(receivedRetrievingInfo.status, .fetchingPrevious,
                       "The received status must be fetchingPrevious since this is the first invocation and 2 blocks must be retrieved")
    }
    
    func test_MoreThanOneBlockAndBlockServiceSucceed_Execute_CallsBlockServiceInOrder() throws {
        // Given
        let givenNumberOfBlocksToBeRetrieved = 20
        
        let headBlock: Block = .mock
        let mockBlcokchain: Blockchain = .init(headBlockId: headBlock.id)
        blocksService.mock_retrieveBlockchain = .init({ $0(.success(mockBlcokchain)) })
        
        var returnedBlocks: [Block] = []
        blocksService.mock_retrieveBlock = .init({ id, completion in
            let block: Block = .mock
            returnedBlocks.append(block)
            completion(.success(block))
        })
        
        // When
        sut.execute(quantityOfBlocksToBeRetrieved: UInt(givenNumberOfBlocksToBeRetrieved),
                    completion: { _ in })
        
        // Then
        XCTAssertEqual(blocksService.mock_retrieveBlock.receivedInvocations.count,
                       givenNumberOfBlocksToBeRetrieved,
                       "The number of invocations of the retrieve block service must be equal to the given number of blocks to be retrieved")
        
        let firstInvokedId = blocksService.mock_retrieveBlock.popFirstInvocationInput()?.0
        XCTAssertEqual(firstInvokedId, headBlock.id)
        
        let subsequentInvokedBlockIds = blocksService.mock_retrieveBlock.receivedInvocations.map { $0.0 }
        
        let expectedInvokedBlockIds = returnedBlocks.dropLast().map { $0.previousBlockId }
        XCTAssertEqual(subsequentInvokedBlockIds, expectedInvokedBlockIds,
                       "The invoked block ids are either different or are not in the expected order. The blocks must be invoked using the previousBlockId of the returned blocks in the order the blocks were returned")
    }
}
