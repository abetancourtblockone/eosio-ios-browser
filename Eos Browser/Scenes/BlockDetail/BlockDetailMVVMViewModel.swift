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
    
    var titleLabel = Observable<String>("")
    var producerLabel = Observable<String>("")
    var producerSignatureLabel = Observable<String>("")
    var numberOfTransactionsLabel = Observable<String>("")
    var switchJsonVisibilityButtonTitle = Observable<String>("")
    var jsonText = Observable<String>("")
    var jsonIsVisible = Observable<Bool>(false)
    
    init(block: Block) {
        self.block = block
    }
    
    func sceneDidLoad() {
        setup()
    }
    
    func handleSwitchJsonVisibility() {
        jsonIsVisible.value = jsonIsVisible.value ? false : true
        switchJsonVisibilityButtonTitle.value = jsonIsVisible.value ? "Hide Json" : "Show Json"
    }
}

private extension BlockDetailMVVMViewModel {
    func setup() {
        titleLabel.value = block.shortId
        producerLabel.value = block.producer
        producerSignatureLabel.value = block.producerSignature
        numberOfTransactionsLabel.value = "\(block.transactionsCount)"
        switchJsonVisibilityButtonTitle.value = "Show Json"
        jsonIsVisible.value = false
        jsonText.value = block.json
    }
}

extension BlockDetailMVVMViewModel: Equatable {
    static func == (lhs: BlockDetailMVVMViewModel, rhs: BlockDetailMVVMViewModel) -> Bool {
        lhs.block == rhs.block
    }
}
