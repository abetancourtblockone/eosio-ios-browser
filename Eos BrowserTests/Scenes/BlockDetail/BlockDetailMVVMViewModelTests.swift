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
        let observable = MockObservable<String>()
        sut.titleLabel.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, givenBlock?.shortId,
                       "The received Title must be the given block short id")
    }
    
    func test_SceneDidLoad_UpdateProducerLabel() throws {
        // Given
        let givenBlock = block
        let observable = MockObservable<String>()
        sut.producerLabel.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, givenBlock?.producer,
                       "The received Title must be the given block producer")
    }
    
    func test_SceneDidLoad_UpdateProducerSignatureLabel() throws {
        // Given
        let givenBlock = block
        let observable = MockObservable<String>()
        sut.producerSignatureLabel.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, givenBlock?.producerSignature,
                       "The received Title must be the given block producer signature")
    }
    
    func test_SceneDidLoad_UpdateNumberOfTransactionsLabel() throws {
        // Given
        let givenBlock = block!
        let observable = MockObservable<String>()
        sut.numberOfTransactionsLabel.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, "\(givenBlock.transactionsCount)",
                       "The received Title must be the given block transactions count")
    }
    
    func test_SceneDidLoad_UpdateJsonVisibility() throws {
        // Given
        let observable = MockObservable<Bool>()
        sut.jsonIsVisible.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertFalse(observable.receivedValue!,
                       "Json must be hiden when scene did load")
    }
    
    func test_SceneDidLoad_UpdateJsonSwitchButtonTitle() throws {
        // Given
        let observable = MockObservable<String>()
        sut.switchJsonVisibilityButtonTitle.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, stringsProvider.showJsonButtonTitle,
            "It must set the showJsonButtonTitle as the button title when scene did load")
    }
    
    func test_SceneDidLoad_UpdateJsonText() throws {
        // Given
        let givenBlock = block
        let observable = MockObservable<String>()
        sut.jsonText.observe(observable.handler)
        
        // When
        sut.sceneDidLoad()
        
        // Then
        XCTAssertEqual(observable.receivedValue, givenBlock?.json,
            "The received json text must be the block json")
    }
    
    func test_HandleSwitchJsonVisibility_UpdateJsonVisibility() throws {
        // Given
        let observable = MockObservable<Bool>()
        sut.jsonIsVisible.observe(observable.handler)
        let givenCurrentVisibilityStatus = sut.jsonIsVisible.value
        
        // When
        sut.handleSwitchJsonVisibility()
        
        // Then
        XCTAssertEqual(observable.receivedValue, !givenCurrentVisibilityStatus,
                       "The received JsonVisibility status must be the negation of the current status")
    }
}
