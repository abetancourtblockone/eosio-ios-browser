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
        let mockHeadBlockId = UUID().uuidString
        let mockBlcokchain: Blockchain = .init(headBlockId: mockHeadBlockId)
        blocksService.retrieveBlockchain = { $0(.success(mockBlcokchain)) }
        
        let blockServiceExpectation = expectation(description: "firstBlockExpectation")
        blocksService.retrieveBlock = { _,_ in blockServiceExpectation.fulfill() }
        
        // When
        sut.execute(quantityOfBlocksToBeRetrieved: 1, completion: { _ in })
        
        // Then
        wait(for: [blockServiceExpectation], timeout: 0.1)
    }
    
    func test_BlockServiceSucceed_Execute_CallsBlockServiceInOrder() throws {
        // Given
        let mockBlocks = chainedBlocks(quantity: 20)
        let blockCallsOrderedExpectations = mockBlocks.map { expectation(description: $0.id) }
        
        let headBlock = mockBlocks.first!
        let mockBlcokchain: Blockchain = .init(headBlockId: headBlock.id)
        blocksService.retrieveBlockchain = { $0(.success(mockBlcokchain)) }
        
        blocksService.retrieveBlock = { id, completion in
            blockCallsOrderedExpectations.first(where: {$0.description == id})?.fulfill()
            guard let block = mockBlocks.first(where: { $0.id == id }) else {
                XCTFail("The requested block does no exists for id: \"\(id)\", make sure you are using the blovkchain headBlockId or the previousBlockId of a given block")
                return
            }
            completion(.success(block))
        }
        
        // When
        sut.execute(quantityOfBlocksToBeRetrieved: UInt(mockBlocks.count), completion: { _ in })
        
        // Then
        wait(for: blockCallsOrderedExpectations, timeout: 1, enforceOrder: true)
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
