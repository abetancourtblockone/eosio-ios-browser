//
//  SceneDelegate.swift
//  Eos Browser
//
//  Created by Angel Betancourt on 23/04/20.
//  Copyright © 2020 EOSIOS. All rights reserved.
//

import UIKit
import EOSIOSDomain

extension UIStoryboard {
    static let main = UIStoryboard.init(name: "Main", bundle: .main)
}

final class SceneBuilder {
    private lazy var storyboard: UIStoryboard = .main
    private lazy var stringsProvider = StringsProvider()
    private lazy var restBlocksService = RestBlocksService()
    private lazy var retrieveBlocks: RetrieveBlocksAdapter = .init(dependencies: .init(blocksService: restBlocksService))
    private lazy var blockDetailSceneDependencies: BlockDetailScene.ViewModel.Dependencies = .init(stringsProvider: stringsProvider)
    private lazy var blockListSceneDependencies: BlockListScene.ViewModel.Dependencies = .init(stringsProvider: stringsProvider,
                                                                                       retrieveBlocks: retrieveBlocks,
                                                                                       blockDetailSceneDependencies: blockDetailSceneDependencies)
    
    var rootViewController: UIViewController? {
        let homelistViewController = storyboard.instantiateViewController(identifier: "BlockListViewController") {
            let viewController = BlockListViewController(coder: $0,
                                                         viewModel: .init(configuration: (),
                                                                          dependencies: self.blockListSceneDependencies))
            return viewController
        }
        return UINavigationController(rootViewController: homelistViewController)
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = window ?? UIWindow(windowScene: windowScene)
        self.window?.rootViewController = SceneBuilder().rootViewController
        self.window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("sceneDidDisconnect. \(scene)")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        print("sceneDidBecomeActive. \(scene)")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("sceneWillResignActive. \(scene)")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("sceneWillEnterForeground. \(scene)")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("sceneDidEnterBackground. \(scene)")
    }
    
    
}
