//
//  BlockDetailMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation

final class BlockDetailMVVMViewModel: MVVMViewModel {
    struct Dependencies {
        var stringsProvider: StringsProviding = StringsProvider()
    }
    
    private let block: Block
    private let dependencies: Dependencies
    
    var titleLabel = Observable<String>("")
    var producerLabel = Observable<String>("")
    var producerSignatureLabel = Observable<String>("")
    var numberOfTransactionsLabel = Observable<String>("")
    var switchJsonVisibilityButtonTitle = Observable<String>("")
    var jsonText = Observable<String>("")
    var jsonIsVisible = Observable<Bool>(false)
    
    init(block: Block, dependencies: Dependencies = .init()) {
        self.block = block
        self.dependencies = dependencies
    }
    
    func sceneDidLoad() {
        setup()
    }
    
    func handleSwitchJsonVisibility() {
        jsonIsVisible.value = jsonIsVisible.value ? false : true
        switchJsonVisibilityButtonTitle.value = jsonIsVisible.value ? dependencies.stringsProvider.hideJsonButtonTitle : dependencies.stringsProvider.showJsonButtonTitle
    }
}

private extension BlockDetailMVVMViewModel {
    func setup() {
        titleLabel.value = block.shortId
        producerLabel.value = block.producer
        producerSignatureLabel.value = block.producerSignature
        numberOfTransactionsLabel.value = "\(block.transactionsCount)"
        switchJsonVisibilityButtonTitle.value = dependencies.stringsProvider.showJsonButtonTitle
        jsonIsVisible.value = false
        jsonText.value = block.json
    }
}

extension BlockDetailMVVMViewModel: Equatable {
    static func == (lhs: BlockDetailMVVMViewModel, rhs: BlockDetailMVVMViewModel) -> Bool {
        lhs.block == rhs.block
    }
}
