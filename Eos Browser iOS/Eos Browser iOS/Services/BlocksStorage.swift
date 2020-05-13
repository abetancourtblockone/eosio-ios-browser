//
//  BlocksStorage.swift
//  Eos Browser iOS
//
//  Created by Angel Betancourt on 12/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import EOSIOSDomain

protocol BlocksStorage {
    func save(block: Block)
    func retrieveAll() -> [Block]
}
