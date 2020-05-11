//
//  MockEndpointProvider.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

@testable import Eos_Browser_iOS

final class MockEndpointProvider: EndpointProvider {
    var mock_getBlock = ""
    var mock_getBlockchainInfo = ""
    
    var getBlock: String {
        mock_getBlock
    }
    var getBlockchainInfo: String {
        mock_getBlockchainInfo
    }
}
