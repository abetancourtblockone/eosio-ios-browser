//
//  BlockListMVVMViewModelTests.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import XCTest
@testable import Eos_Browser

class BlockListMVVMViewModelTests: XCTestCase {
    
    var retrieveBlocks: MockRetrieveBlocks!
    var sut: BlockListMVVMViewModel!

    override func setUpWithError() throws {
        retrieveBlocks = .init()
        sut = .init(dependencies: .init(retrieveBlocks: retrieveBlocks))
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        
    }
}