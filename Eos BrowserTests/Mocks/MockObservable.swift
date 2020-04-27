//
//  MockObservable.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class MockObservable<Value> {
    var receivedValue: Value?
    lazy var handler: ((Value) -> ())? = {
        self.receivedValue = $0
    }
}
