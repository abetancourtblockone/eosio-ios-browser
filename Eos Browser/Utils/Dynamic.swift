//
//  Dynamic.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 24/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class Dynamic<Value> {
    typealias Listener = (Value) -> ()
    var listener: Listener?
    let queue: DispatchQueue
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        notify()
    }
    
    var value: Value {
        didSet {
            notify()
        }
    }
    
    private func notify() {
        queue.async {
            self.listener?(self.value)
        }
    }
    
    init(_ value: Value, queue: DispatchQueue = .main) {
        self.value = value
        self.queue = queue
    }
}
