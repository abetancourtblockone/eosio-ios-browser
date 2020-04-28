//
//  Scene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//


protocol MVVMViewModel: Equatable {
    associatedtype Configuration: Equatable
    associatedtype Dependencies
    
    init(configuration: Configuration, dependencies: Dependencies)
    func sceneDidLoad()
}

protocol MVVMView: Equatable {
    associatedtype ViewModel: MVVMViewModel
    var viewModel: ViewModel? { get set }
}

protocol Scene {
    associatedtype View: MVVMView
    associatedtype ViewModel: MVVMViewModel
    
    typealias Dependencies = ViewModel.Dependencies
    typealias Configuration = ViewModel.Configuration
    
    var configuration: Configuration { get set }
    var dependencies: Dependencies { get set }
    
    init(configuration: Configuration, dependencies: Dependencies)
}


