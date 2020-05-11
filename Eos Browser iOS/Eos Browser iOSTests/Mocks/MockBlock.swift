//
//  MockBlock.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import EOSIOSDomain

extension Block {
    static var mock: Block {
        .init(id: UUID().uuidString,
              producer: "Producer",
              producerSignature: UUID().uuidString,
              transactionsCount: (1...100).randomElement() ?? 0,
              previousBlockId: UUID().uuidString,
              json: "")
    }
}
