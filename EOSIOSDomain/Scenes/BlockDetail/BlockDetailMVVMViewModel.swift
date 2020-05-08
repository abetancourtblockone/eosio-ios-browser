//
//  BlockDetailMVVMViewModel.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import Foundation
import Combine

public final class BlockDetailMVVMViewModel: MVVMViewModel {
    public struct Configuration: Equatable {
        var block: Block
    }
    
    public struct Dependencies {
        var stringsProvider: StringsProviding
        public init(stringsProvider: StringsProviding) {
            self.stringsProvider = stringsProvider
        }
    }
        
    private let configuration: Configuration
    private let dependencies: Dependencies
    
    private let titleLabelSubject = PassthroughSubject<String?, Never>()
    private let producerLabelSubject = PassthroughSubject<String?, Never>()
    private let producerSignatureLabelSubject = PassthroughSubject<String?, Never>()
    private let numberOfTransactionsLabelSubject = PassthroughSubject<String?, Never>()
    private let switchJsonVisibilityButtonTitleSubject = PassthroughSubject<String?, Never>()
    private let jsonTextSubject = PassthroughSubject<String?, Never>()
    private let jsonIsHiddenSubject = CurrentValueSubject<Bool, Never>(true)
    
    public lazy var titleLabel: AnyPublisher<String?, Never> = titleLabelSubject.eraseToAnyPublisher()
    public lazy var producerLabel: AnyPublisher<String?, Never> = producerLabelSubject.eraseToAnyPublisher()
    public lazy var producerSignatureLabel: AnyPublisher<String?, Never> = producerSignatureLabelSubject.eraseToAnyPublisher()
    public lazy var numberOfTransactionsLabel: AnyPublisher<String?, Never> = numberOfTransactionsLabelSubject.eraseToAnyPublisher()
    public lazy var switchJsonVisibilityButtonTitle: AnyPublisher<String?, Never> = switchJsonVisibilityButtonTitleSubject.eraseToAnyPublisher()
    public lazy var jsonText: AnyPublisher<String?, Never> = jsonTextSubject.eraseToAnyPublisher()
    public lazy var jsonIsHidden: AnyPublisher<Bool, Never> = jsonIsHiddenSubject.eraseToAnyPublisher()
    
    public init(configuration: Configuration, dependencies: Dependencies) {
        self.configuration = configuration
        self.dependencies = dependencies
    }
    
    public func sceneDidLoad() {
        setup()
    }
    
    public func handleSwitchJsonVisibility() {
        jsonIsHiddenSubject.value = !jsonIsHiddenSubject.value
        let buttonTitle = jsonIsHiddenSubject.value ? dependencies.stringsProvider.showJsonButtonTitle : dependencies.stringsProvider.hideJsonButtonTitle
        switchJsonVisibilityButtonTitleSubject.send(buttonTitle)
    }
}

private extension BlockDetailMVVMViewModel {
    func setup() {
        titleLabelSubject.send(configuration.block.shortId)
        producerLabelSubject.send(configuration.block.producer)
        producerSignatureLabelSubject.send(configuration.block.producerSignature)
        numberOfTransactionsLabelSubject.send("\(configuration.block.transactionsCount)")
        switchJsonVisibilityButtonTitleSubject.send(dependencies.stringsProvider.showJsonButtonTitle)
        jsonTextSubject.send(configuration.block.json)
    }
}
