//
//  BlockDetailScene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class BlockDetailScene: Scene {
    typealias View = BlockDetailViewController
    typealias ViewModel = BlockDetailMVVMViewModel
    
    var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}

extension BlockDetailScene: Equatable {
    static func == (lhs: BlockDetailScene, rhs: BlockDetailScene) -> Bool {
        lhs.viewModel == rhs.viewModel
    }
}
 
