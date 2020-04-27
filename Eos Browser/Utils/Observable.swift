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
    var handler: Handler?
    let queue: DispatchQueue
    
    func observe(_ handler: Handler?) {
        self.handler = handler
    }
    
    var value: Value {
        didSet {
            notify()
        }
    }
    
    init(_ value: Value, queue: DispatchQueue = .main) {
        self.value = value
        self.queue = queue
    }
    
    private func notify() {
        queue.async {
            self.handler?(self.value)
        }
    }
}

extension Observable where Value == String {
    convenience init(_ value: Value = "") {
        self.init(value, queue: .main)
    }
}

extension Observable where Value: Collection {
    var count: Int { value.count }
    subscript(index: Value.Index) -> Value.Element { return value[index] }
}
