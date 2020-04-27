//
//  Scene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//


protocol MVVMViewModel {
    func sceneDidLoad()
}

protocol MVVMView {
    associatedtype ViewModel: MVVMViewModel
    var viewModel: ViewModel? { get set }
}

protocol Scene {
    associatedtype View: MVVMView
    associatedtype ViewModel: MVVMViewModel
    
    var viewModel: ViewModel { get set }
    init(viewModel: ViewModel)
}


