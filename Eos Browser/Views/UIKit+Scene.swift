//
//  UIKit+Scene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static let main = UIStoryboard.init(name: "main", bundle: .main)
}

extension UIViewController {
    func show<S: Scene>(scene: S)
        where S.View: UIViewController,
        S.View.ViewModel == S.ViewModel  {
            guard var viewController = storyboard?.instantiateViewController(identifier: String(describing: S.View.self)) as? S.View else {
                print("Couldn't instantiate the ViewController \(S.View.self) please make sure the viewcontroller identifier is the same as the scene view type")
                return
            }
            viewController.viewModel = S.ViewModel.init(configuration: scene.configuration,
                                                        dependencies: scene.dependencies)
            show(viewController, sender: self)
    }
}
