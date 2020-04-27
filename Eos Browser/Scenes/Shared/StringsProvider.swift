//
//  StringsProvider.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

protocol StringsProviding {
    var blockListTitle: String { get }
}

final class StringsProvider: StringsProviding {
    var blockListTitle: String = "Blocks"
    
    
}
