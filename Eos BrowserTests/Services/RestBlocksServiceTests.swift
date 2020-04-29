//
//  RestBlocksServiceTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
@testable import Eos_Browser

final class RestBlocksServiceTests: XCTestCase {
    
    var urlRequester: MockURLRequester!
    var endpointProvider: MockEndpointProvider!
    var sut: RestBlocksService!

    override func setUpWithError() throws {
        urlRequester = .init()
        endpointProvider = .init()
        sut = .init(dependencies: .init(urlRequester: urlRequester,
                                        endpointProvider: endpointProvider))
    }

    override func tearDownWithError() throws {
        urlRequester = nil
        endpointProvider = nil
        sut = nil
    }
    
    func test_CancelAllRequests_CancelAllRequests() {
        // When
        sut.cancelRequests()
        
        // Then
        XCTAssertNotNil(urlRequester.mock_cancelRequests.popFirstInvocationInput(),
                        "IT must ask the urlRequester for cancneling all requets")
    }

    func test_ValidBlockChainInfoEndPoint_RetrieveBlockchain_CallsURLRequester() throws {
        // Given
        let givenURLString = "https://validendpoint.com"
        endpointProvider.mock_getBlockchainInfo = givenURLString
        
        // When
        sut.retrieveBlockchain(completion: { _ in }) 
        
        // Then
        let receivedRequest = urlRequester.mock_request.popFirstInvocationInput()?.0
        XCTAssertEqual(receivedRequest?.url?.absoluteString, givenURLString,
                       "The service must receive the url request using the url given by the enpoints provider")
    }
    
    func test_InvalidBlockChainInfoEndPoint_RetrieveBlockchain_DoesNotCallsURLRequester() throws {
        // Given
        endpointProvider.mock_getBlockchainInfo = "malformed endpoint"
        
        // When
        sut.retrieveBlockchain(completion: { _ in })
        
        // Then
        let invocation = urlRequester.mock_request.popFirstInvocationInput()
        XCTAssertNil(invocation, "It must not call the url requester if there is not a valid url")
    }
    
    func test_ValidBlockEndPoint_RetrieveBlock_CallsURLRequester() throws {
        // Given
        let givenURLString = "https://validendpoint.com"
        let givenBlockId = UUID().uuidString
        endpointProvider.mock_getBlockchainInfo = givenURLString
        endpointProvider.mock_getBlock = givenURLString
        
        // When
        sut.retrieve(blockId: givenBlockId, completion: { _ in })
        
        // Then
        let receivedRequest = urlRequester.mock_request.popFirstInvocationInput()?.0
        XCTAssertEqual(receivedRequest?.url?.absoluteString, givenURLString,
                       "The service must receive the url request using the url given by the enpoints provider")
        
        let expectedJsonObject = ["block_num_or_id": givenBlockId]
        let expectedHttpBody = try? JSONSerialization.data(withJSONObject: expectedJsonObject, options: [])
        
        XCTAssertEqual(receivedRequest?.httpBody, expectedHttpBody,
                       "The expected request body must be a json serialized data containing this \(expectedJsonObject)")
        
    }
    
    func test_InvalidBlockEndPoint_RetrieveBlock_DoesNotCallsURLRequester() throws {
        // Given
        let givenBlockId = UUID().uuidString
        endpointProvider.mock_getBlock = "malformed url"
        
        // When
        sut.retrieve(blockId: givenBlockId, completion: { _ in })
        
        // Then
        let invocation = urlRequester.mock_request.popFirstInvocationInput()
        XCTAssertNil(invocation, "It must not call the url requester if there is not a valid url")
    }
    
    func test_ValidBlockchainEndPointResponse_RetrieveBlockchain_ReturnsResponseDictionary() throws {
        // Given
        let givenURLString = "https://validendpoint.com"
        let givenResponseHeadBlockId = UUID().uuidString
        let givenValidResponse = ["head_block_id": givenResponseHeadBlockId]
        
        endpointProvider.mock_getBlockchainInfo = givenURLString
        urlRequester.mock_request = .init({ $1(.success(givenValidResponse)) })
        
        // When
        let mockCompletion = MockFunction<RetrieveBlockchainResult, Void>()
        sut.retrieveBlockchain(completion: mockCompletion.execute)
        
        // Then
        guard case .success(let receivedBlockchain) = mockCompletion.popFirstInvocationInput() else {
            XCTFail("The completion was not called. Make sure the completion is being called passing the blockchain info")
            return
        }
        
        XCTAssertEqual(receivedBlockchain, .init(headBlockId: givenResponseHeadBlockId),
                       "The received blockchain info is not valid. The received headBlockId must be the returned by the url requester response")
    }
}
