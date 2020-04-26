//
//  BlockDetailMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class BlockDetailMVVMViewModel: MVVMViewModel {
    
    private let block: Block
    
    var titleLabel = Dynamic<String>("")
    var producerLabel = Dynamic<String>("")
    var producerSignatureLabel = Dynamic<String>("")
    var numberOfTransactionsLabel = Dynamic<String>("")
    var switchJsonVisibilityButtonTitle = Dynamic<String>("")
    var jsonText = Dynamic<String>("")
    var jsonIsVisible = Dynamic<Bool>(false)
    
    init(block: Block) {
        self.block = block
    }
    
    func sceneDidLoad() {
        titleLabel.value = block.shortId
        producerLabel.value = block.producer
        producerSignatureLabel.value = block.producerSignature
        numberOfTransactionsLabel.value = "\(block.transactionsCount)"
        switchJsonVisibilityButtonTitle.value = "Show Json"
        jsonIsVisible.value = false
        jsonText.value = block.json
    }
    
    func handleSwitchJsonVisibility() {
        jsonIsVisible.value = jsonIsVisible.value ? false : true
        switchJsonVisibilityButtonTitle.value = jsonIsVisible.value ? "Hide Json" : "Show Json"
    }
}
