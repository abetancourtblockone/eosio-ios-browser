//
//  BlockDetailScene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class BlockDetailScene: Scene {
    typealias ViewModel = BlockDetailMVVMViewModel
    
    var configuration: Configuration
    var dependencies: Dependencies
    
    init(configuration: Configuration, dependencies: Dependencies) {
        self.configuration = configuration
        self.dependencies = dependencies
    }
}
