//
//  TabController.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/22/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit

final class TabController: UITabBarController {
    
//    var coordinator: AppCoordinator?

    let homeVC = HomeVC() //(persistenceManager: PersistenceManager.shared)
    let favoriteVC = FavoriteVC()
    let categoryVC = CategoryVC()
    let searchVC = SearchVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCs()
//        coordinator?.start()
    }
    
    fileprivate func setupVCs(){
//        tabBar.barTintColor =  UIColor.rgb(red: 22, green: 23, blue: 27)
        tabBar.tintColor = .systemPink
        tabBar.isTranslucent = true
//        navigationController?.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        viewControllers = [
            createControllers(title: "Home", image: "chefhat", selectedImage: "chefhat.fill", vc: homeVC),
            createControllers(title: "Category", image: "list", selectedImage: "listfilled", vc: categoryVC),
            createControllers(title: "Favorited", image: "heart", selectedImage: "heartfilled", vc: favoriteVC),
            createControllers(title: "Search", image: "search", selectedImage: "searchfilled", vc: searchVC)
        ]
        
    }
    
    fileprivate func createControllers(title: String, image: String, selectedImage: String, vc: UIViewController) -> UINavigationController{
        let recentVC = UINavigationController(rootViewController: vc)
        recentVC.tabBarItem.title = title
        recentVC.tabBarItem.image = UIImage(named: image)
        //Handles optional binding
//        if let selectedImage = selectedImage {
        recentVC.tabBarItem.selectedImage = UIImage(named: selectedImage)
//        }
        return recentVC
    }
    
}


