//
//  EndpointProvider.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

protocol EndpointProvider {
    var getBlock: String { get }
    var getBlockchainInfo: String { get }
}
