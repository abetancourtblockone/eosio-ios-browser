//
//  BlockDetailScene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

public final class BlockDetailScene: Scene {
    public typealias ViewModel = BlockDetailMVVMViewModel
    
    public var configuration: Configuration
    public var dependencies: Dependencies
    
    public init(configuration: Configuration, dependencies: Dependencies) {
        self.configuration = configuration
        self.dependencies = dependencies
    }
}