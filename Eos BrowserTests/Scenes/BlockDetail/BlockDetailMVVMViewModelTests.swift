//
//  BlockDetailMVVMViewModelTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
@testable import Eos_Browser

final class BlockDetailMVVMViewModelTests: XCTestCase {
    var block: Block!
    var stringsProvider: MockStringsProvider!
    var sut: BlockDetailMVVMViewModel!

    override func setUpWithError() throws {
        block = .mock
        stringsProvider = .init()
        sut = .init(configuration: .init(block: block),
                    dependencies: .init(stringsProvider: stringsProvider))
    }

    override func tearDownWithError() throws {
        block = nil
        stringsProvider = nil
        sut = nil
    }

    func test_SceneDidLoad_UpdateTitle() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String, Void>()
        sut.titleLabel.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), givenBlock?.shortId,
                       "The received Title must be the given block short id")
    }
    
    func test_SceneDidLoad_UpdateProducerLabel() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String, Void>()
        sut.producerLabel.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), givenBlock?.producer,
                       "The received Title must be the given block producer")
    }
    
    func test_SceneDidLoad_UpdateProducerSignatureLabel() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String, Void>()
        sut.producerSignatureLabel.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), givenBlock?.producerSignature,
                       "The received Title must be the given block producer signature")
    }
    
    func test_SceneDidLoad_UpdateNumberOfTransactionsLabel() throws {
        // Given
        let givenBlock = block!
        let observableHandler = MockFunction<String, Void>()
        sut.numberOfTransactionsLabel.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), "\(givenBlock.transactionsCount)",
                       "The received Title must be the given block transactions count")
    }
    
    func test_SceneDidLoad_UpdateJsonVisibility() throws {
        // Given
        let observableHandler = MockFunction<Bool, Void>()
        sut.jsonIsVisible.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertFalse(observableHandler.popFirstInvocationInput()!,
                       "Json must be hiden when scene did load")
    }
    
    func test_SceneDidLoad_UpdateJsonSwitchButtonTitle() throws {
        // Given
        let observableHandler = MockFunction<String, Void>()
        sut.switchJsonVisibilityButtonTitle.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), stringsProvider.showJsonButtonTitle,
            "It must set the showJsonButtonTitle as the button title when scene did load")
    }
    
    func test_SceneDidLoad_UpdateJsonText() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String, Void>()
        sut.jsonText.observe(observableHandler.execute)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), givenBlock?.json,
            "The received json text must be the block json")
    }
    
    func test_HandleSwitchJsonVisibility_UpdateJsonVisibility() throws {
        // Given
        let observableHandler = MockFunction<Bool, Void>()
        sut.jsonIsVisible.observe(observableHandler.execute)
        let givenCurrentVisibilityStatus = sut.jsonIsVisible.value
        
        // When
        sut.handleSwitchJsonVisibility()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), !givenCurrentVisibilityStatus,
                       "The received JsonVisibility status must be the negation of the current status")
    }
}
