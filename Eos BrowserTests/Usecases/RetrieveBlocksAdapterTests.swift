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
    
    func test_Execute_CancelAllRequests() {
        // When
        sut.execute(quantityOfBlocksToBeRetrieved: 1, completion: { _ in })
        
        // Then
        XCTAssertNotNil(blocksService.mock_cancelRequests.popFirstInvocationInput(),
                        "IT must ask the service for cancneling all requets")
    }
    
    func test_OneBlockAndBlockchainServiceSucceed_Execute_ReturnsFinishedStatus() throws {
        // Given
        let mockBlock: Block = .mock
        mockServicesSucceed(block: mockBlock)
        
        // When
        let mockCompletion = MockFunction<RetrieveBlocksResult, Void>()
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
        mockServicesSucceed(block: mockBlock)
        
        // When
        let mockCompletion = MockFunction<RetrieveBlocksResult, Void>()
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
        let givenNumberOfBlocksToBeRetrieved = 1
        
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
    
    func test_BlockchainInfoFails_Execute_CompletionFails() {
        let givenError = ServiceError(message: "Mock error message")
        blocksService.mock_retrieveBlockchain = .init({ $0(.failure(givenError)) })
        
        // When
        let mockCompletion = MockFunction<RetrieveBlocksResult, Void>()
        sut.execute(quantityOfBlocksToBeRetrieved: 2, completion: mockCompletion.execute)
        
        // Then
        XCTAssertSutFail(givenError: givenError, mockCompletion: mockCompletion)
    }
    
    func test_GetBlockckFails_Execute_CompletionFails() {
        
        let mockBlcokchain: Blockchain = .init(headBlockId: "")
        blocksService.mock_retrieveBlockchain = .init({ $0(.success(mockBlcokchain)) })
        
        let givenError = ServiceError(message: "Mock error message")
        blocksService.mock_retrieveBlock = .init({ $1(.failure(givenError)) })
        
        // When
        let mockCompletion = MockFunction<RetrieveBlocksResult, Void>()
        sut.execute(quantityOfBlocksToBeRetrieved: 2, completion: mockCompletion.execute)
        
        // Then
        XCTAssertSutFail(givenError: givenError, mockCompletion: mockCompletion)
    }
}

private extension RetrieveBlocksAdapterTests {
    func mockServicesSucceed(block: Block) {
        let mockBlcokchain: Blockchain = .init(headBlockId: block.id)
        blocksService.mock_retrieveBlockchain = .init({ $0(.success(mockBlcokchain)) })
        blocksService.mock_retrieveBlock = .init({ $1(.success(block)) })
    }
    
    func XCTAssertSutFail(givenError: ServiceError,
                          mockCompletion: MockFunction<RetrieveBlocksResult, Void>,
                          file: StaticString = #file,
                          line: UInt = #line) {
        guard case .failure(let receivedError) = mockCompletion.popFirstInvocationInput() else {
            XCTFail("The result must be a error response",
                    file: file,
                    line: line)
            return
        }
        
        XCTAssertEqual(receivedError.localizedDescription, givenError.localizedDescription,
                       "The received error must be the error given by the service",
                       file: file,
                       line: line)
    }
}
