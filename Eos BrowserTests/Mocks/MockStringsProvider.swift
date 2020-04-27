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
    var mock_showJsonButtonTitle = ""
    var mock_hideJsonButtonTitle = ""
    
    var blockListTitle: String {
        mock_blockListTitle
    }
    var showJsonButtonTitle: String {
        mock_showJsonButtonTitle
    }
    var hideJsonButtonTitle: String {
        mock_hideJsonButtonTitle
    }
}

