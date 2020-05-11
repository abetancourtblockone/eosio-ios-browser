//
//  BlockDetailMVVMViewModelTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
import Combine
@testable import EOSIOSDomain
@testable import Eos_Browser

final class BlockDetailMVVMViewModelTests: XCTestCase {
    var block: Block!
    var stringsProvider: MockStringsProvider!
    var sut: BlockDetailMVVMViewModel!
    
    private var subscriptions = [AnyCancellable]()

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
        subscriptions.removeAll()
    }

    func test_SceneDidLoad_UpdateTitle() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String?, Void>()
        sut.titleLabel.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popLastInvocationInput(), givenBlock?.shortId,
                       "The received Title must be the given block short id")
    }
    
    func test_SceneDidLoad_UpdateProducerLabel() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String?, Void>()
        sut.producerLabel.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popLastInvocationInput(), givenBlock?.producer,
                       "The received Title must be the given block producer")
    }
    
    func test_SceneDidLoad_UpdateProducerSignatureLabel() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String?, Void>()
        sut.producerSignatureLabel.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popLastInvocationInput(), givenBlock?.producerSignature,
                       "The received Title must be the given block producer signature")
    }
    
    func test_SceneDidLoad_UpdateNumberOfTransactionsLabel() throws {
        // Given
        let givenBlock = block!
        let observableHandler = MockFunction<String?, Void>()
        sut.numberOfTransactionsLabel.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popLastInvocationInput(), "\(givenBlock.transactionsCount)",
                       "The received Title must be the given block transactions count")
    }
    
    func test_SceneDidLoad_UpdateJsonVisibility() throws {
        // Given
        let observableHandler = MockFunction<Bool, Void>()
        sut.jsonIsHidden.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertTrue(observableHandler.popFirstInvocationInput()!,
                       "Json must be hiden when scene did load")
    }
    
    func test_SceneDidLoad_UpdateJsonSwitchButtonTitle() throws {
        // Given
        let observableHandler = MockFunction<String?, Void>()
        sut.switchJsonVisibilityButtonTitle.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), stringsProvider.showJsonButtonTitle,
            "It must set the showJsonButtonTitle as the button title when scene did load")
    }
    
    func test_SceneDidLoad_UpdateJsonText() throws {
        // Given
        let givenBlock = block
        let observableHandler = MockFunction<String?, Void>()
        sut.jsonText.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observableHandler.popFirstInvocationInput(), givenBlock?.json,
            "The received json text must be the block json")
    }
    
    func test_HandleSwitchJsonVisibility_UpdateJsonVisibility() throws {
        // Given
        let observableHandler = MockFunction<Bool, Void>()
        sut.jsonIsHidden.sink(receiveValue: observableHandler.execute).store(in: &subscriptions)
        let givenCurrentVisibilityStatus = true
        
        // When
        sut.handleSwitchJsonVisibility()
        
        // Then
        XCTAssertEqual(observableHandler.popLastInvocationInput(), !givenCurrentVisibilityStatus,
                       "The received JsonVisibility status must be the negation of the current status")
    }
}
