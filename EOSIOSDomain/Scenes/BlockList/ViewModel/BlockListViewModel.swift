//
//  BlockListViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

public struct BlockListViewModel {
    public enum Section: CaseIterable {
        case blocks
    }
    public struct Item: Hashable {
        public let id: String
        public let producer: String
    }
}