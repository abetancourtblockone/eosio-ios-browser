//
//  Scene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 26/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit

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

extension UIStoryboard {
    static let main = UIStoryboard.init(name: "main", bundle: .main)
}

extension UIViewController {
    func show<S: Scene>(scene: S)
        where S.View: UIViewController,
        S.View.ViewModel == S.ViewModel  {
        guard var viewController = storyboard?.instantiateViewController(identifier: String(describing: S.View.self)) as? S.View else {
            return
        }
        viewController.viewModel = scene.viewModel
        show(viewController, sender: self)
    }
}
