//
//  BlockDetailMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import Combine

final class BlockDetailMVVMViewModel: MVVMViewModel {
    struct Configuration: Equatable {
        var block: Block
    }
    
    struct Dependencies {
        var stringsProvider: StringsProviding = StringsProvider()
    }
        
    private let configuration: Configuration
    private let dependencies: Dependencies
    
    var titleLabel = CurrentValueSubject<String, Never>("")
    var producerLabel = CurrentValueSubject<String, Never>("")
    var producerSignatureLabel = CurrentValueSubject<String, Never>("")
    var numberOfTransactionsLabel = CurrentValueSubject<String, Never>("")
    var switchJsonVisibilityButtonTitle = CurrentValueSubject<String, Never>("")
    var jsonText = CurrentValueSubject<String, Never>("")
    var jsonIsVisible = CurrentValueSubject<Bool, Never>(false)
    
    init(configuration: Configuration, dependencies: Dependencies = .init()) {
        self.configuration = configuration
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
        titleLabel.value = configuration.block.shortId
        producerLabel.value = configuration.block.producer
        producerSignatureLabel.value = configuration.block.producerSignature
        numberOfTransactionsLabel.value = "\(configuration.block.transactionsCount)"
        switchJsonVisibilityButtonTitle.value = dependencies.stringsProvider.showJsonButtonTitle
        jsonIsVisible.value = false
        jsonText.value = configuration.block.json
    }
}
