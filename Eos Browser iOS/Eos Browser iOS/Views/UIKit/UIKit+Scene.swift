//
//  UIKit+Scene.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 27/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit
import EOSIOSDomain

extension UIViewController {
    func show<S: Scene>(scene: S, storyboard: UIStoryboard = .main)
        where S.ViewModel: BlockDetailScene.ViewModel  {
            
            let viewControllerCreator: (NSCoder) -> UIViewController? = {
                BlockDetailViewController(coder: $0,
                                          viewModel: .init(configuration: scene.configuration,
                                                           dependencies: scene.dependencies))}
            
            let viewController = storyboard.instantiateViewController(identifier: "BlockDetailViewController",
                                                                      creator: viewControllerCreator)
            
            show(viewController, sender: self)
    }
}
