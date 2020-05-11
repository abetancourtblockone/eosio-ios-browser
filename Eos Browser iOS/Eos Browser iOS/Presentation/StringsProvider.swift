//
//  StringsProvider.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 7/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

protocol StringsProviding {
    var blockListTitle: String { get }
    var showJsonButtonTitle: String { get }
    var hideJsonButtonTitle: String { get }
}

final class StringsProvider: StringsProviding {
    var blockListTitle: String = "Blocks"
    var showJsonButtonTitle: String = "Show Json"
    var hideJsonButtonTitle: String = "Hide Json"
}
