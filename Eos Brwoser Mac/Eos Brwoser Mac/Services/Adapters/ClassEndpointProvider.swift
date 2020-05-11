//
//  ClassEndpointProvider.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class ClassEndpointProvider: EndpointProvider {
    var getBlock = "https://eos.greymass.com/v1/chain/get_block"
    var getBlockchainInfo = "https://eos.greymass.com/v1/chain/get_info"
}
