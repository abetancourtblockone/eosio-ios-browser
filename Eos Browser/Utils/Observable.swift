//
//  Observable.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class Observable<Value> {
    typealias Handler = (Value) -> ()
    private var handler: Handler?
    
    func observe(_ handler: Handler?) {
        self.handler = handler
    }
    
    var value: Value {
        didSet {
            notify()
        }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    private func notify() {
        self.handler?(self.value)
    }
}

extension Observable where Value: Collection {
    var count: Int { value.count }
    subscript(index: Value.Index) -> Value.Element { return value[index] }
}
