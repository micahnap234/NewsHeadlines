//
//  SceneDelegate.swift
//  NewsHeadlines
//
//  Created by Micah Napier on 7/3/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    window = UIWindow(frame: scene.inputView?.coordinateSpace.bounds ?? CGRectZero)
    window?.windowScene = scene
    
    let tabController = UITabBarController()
    
    let headlinesTabItem = UITabBarItem()
    headlinesTabItem.title = "Headlines"
    
    let headlinesVC = ArticleViewController()
    headlinesVC.tabBarItem = headlinesTabItem
    let headlinesNavVC = UINavigationController(rootViewController: headlinesVC)
    headlinesNavVC.tabBarItem = headlinesTabItem
    
    let sourcesTabItem = UITabBarItem()
    sourcesTabItem.title = "Sources"
    let sourcesVC = SourcesViewController()
    sourcesVC.tabBarItem = sourcesTabItem
    let sourcesNavVC = UINavigationController(rootViewController: sourcesVC)
    sourcesNavVC.tabBarItem = sourcesTabItem
    
    let savedTabItem = UITabBarItem()
    savedTabItem.title = "Saved Articles"
    let savedVC = SavedArticlesViewController()
    let savedNavVC = UINavigationController(rootViewController: savedVC)
    savedNavVC.tabBarItem = savedTabItem
    
    tabController.viewControllers = [headlinesNavVC, sourcesNavVC, savedNavVC]
    window?.rootViewController = tabController
    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {}

  func sceneDidBecomeActive(_ scene: UIScene) {}

  func sceneWillResignActive(_ scene: UIScene) {}

  func sceneWillEnterForeground(_ scene: UIScene) {}

  func sceneDidEnterBackground(_ scene: UIScene) {}
}

