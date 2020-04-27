//
//  ObservableTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
@testable import Eos_Browser

final class ObservableTests: XCTestCase {
    
    var sut: Observable<Bool>!

    override func setUpWithError() throws {
        sut = .init(false)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_Observe_Notify() throws {
        // Given
        let receiveChangeExpectation = expectation(description: "receiveChangeExpectation")
        sut.observe { if $0 { receiveChangeExpectation.fulfill() } }
        
        // When
        sut.value = true
        
        // Then
        wait(for: [receiveChangeExpectation], timeout: 1)
    }
}
