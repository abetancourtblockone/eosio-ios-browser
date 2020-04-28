//
//  MockInvocation.swift
//  Eos BrowserTests
//
//  Created by Angel Betancourt on 28/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class MockInvocation<Input, Output> {
    typealias Function = (Input) -> Output
    
    private(set) var receivedInvocations: [Input] = []
    private let function: Function
    init(_ function: @escaping Function) {
        self.function = function
    }
    
    @discardableResult
    func execute(_ input: Input) -> Output {
        receivedInvocations.append(input)
        return function(input)
    }
    
    @discardableResult
    func popFirstInvocationInput() -> Input? {
        guard !receivedInvocations.isEmpty else {
            return nil
        }
        return receivedInvocations.removeFirst()
    }
}
