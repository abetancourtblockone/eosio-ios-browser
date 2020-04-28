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
    
    func test_BlockchainServiceSucceed_Execute_CallsGetBlockService() throws {
        // Given
        let mockBlock: Block = .mock()
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
    
    func test_BlockServiceSucceed_Execute_CallsBlockServiceInOrder() throws {
        // Given
        let givenNumberOfBlocksToBeRetrieved = 20
        let mockBlocks = chainedBlocks(quantity: UInt(givenNumberOfBlocksToBeRetrieved))
        
        let headBlock = mockBlocks.first!
        let mockBlcokchain: Blockchain = .init(headBlockId: headBlock.id)
        blocksService.mock_retrieveBlockchain = .init({ $0(.success(mockBlcokchain)) })
        
        blocksService.mock_retrieveBlock = .init({ id, completion in
            guard let block = mockBlocks.first(where: { $0.id == id }) else {
                XCTFail("The requested block does no exists for id: \"\(id)\", make sure you are using the blockchain headBlockId or the previousBlockId of a given block")
                return
            }
            completion(.success(block))
        })
        
        // When
        sut.execute(quantityOfBlocksToBeRetrieved: UInt(mockBlocks.count), completion: { _ in })
        
        // Then
        XCTAssertEqual(blocksService.mock_retrieveBlock.receivedInvocations.count, givenNumberOfBlocksToBeRetrieved,
                       "The number of invocations of the retrieve block service must be equal to the given number of blocks to be retrieved")
        
        let invokedBlockIds = blocksService.mock_retrieveBlock.receivedInvocations.map { $0.0 }
        let expectedInvokedBlockIds = mockBlocks.map { $0.id }
        XCTAssertEqual(invokedBlockIds, expectedInvokedBlockIds,
                       "The invoked block ids are either different or are not in the expected order")
    }
}

private extension RetrieveBlocksAdapterTests {
    func chainedBlocks(quantity: UInt) -> [Block] {
        var repeatingTimes = quantity - 1
        var lastBlock = Block.mock()
        var blocks = [lastBlock]
        
        while repeatingTimes > 0 {
            let block = Block.mock(previousBlockId: lastBlock.id)
            blocks.append(block)
            lastBlock = block
            repeatingTimes -= 1
        }
        return blocks.reversed()
    }
}
