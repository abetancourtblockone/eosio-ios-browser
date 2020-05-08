//
//  BlockListScene.swift
//  EOSIOSDomain
//
//  Created by Angel Betancourt on 8/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

public final class BlockListScene: Scene {
    public typealias ViewModel = BlockListMVVMViewModel
    
    public var configuration: Configuration
    public var dependencies: Dependencies
    
    public init(configuration: Configuration, dependencies: Dependencies) {
        self.configuration = configuration
        self.dependencies = dependencies
    }
}
