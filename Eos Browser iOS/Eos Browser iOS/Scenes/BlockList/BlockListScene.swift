//
//  BlockListScene.swift
//  EOSIOSDomain
//
//  Created by Angel Betancourt on 8/05/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

final class BlockListScene: Scene {
    typealias ViewModel = BlockListMVVMViewModel
    
    var configuration: Configuration
    var dependencies: Dependencies
    
    init(configuration: Configuration, dependencies: Dependencies) {
        self.configuration = configuration
        self.dependencies = dependencies
    }
}
