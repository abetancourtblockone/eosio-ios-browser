//
//  MockStringsProvider.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser

final class MockStringsProvider: StringsProviding {
    var mock_blockListTitle = ""
    
    var blockListTitle: String {
        mock_blockListTitle
    }
}
