//
//  MockBlock.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 25/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
@testable import Eos_Browser

extension Block {
    static func mock(previousBlockId: String = UUID().uuidString) -> Block {
        .init(id: UUID().uuidString,
              producer: "Producer",
              producerSignature: UUID().uuidString,
              transactionsCount: (1...100).randomElement() ?? 0,
              previousBlockId: previousBlockId)
    }
}
