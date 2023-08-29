//
//  TabBarController.swift
//  Nika
//
//  Created by Max Kuzmin on 12.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupTabBar()
    }
    
    private func setupTabBar() {
        guard let todayImage = UIImage(named: "Today") else { return }
        guard let newsImage = UIImage(named: "News") else { return }
        guard let followingImage = UIImage(named: "Following") else { return }

        viewControllers = [
            createNavigationController(vc: TodayViewController(), itemName: "Today", itemImage: todayImage),
            createNavigationController(vc: NewsViewController(), itemName: "News", itemImage: newsImage),
            createNavigationController(vc: FollowingViewController(), itemName: "Following", itemImage: followingImage),
        ]
    }
    
    private func createNavigationController(vc: UIViewController, itemName: String, itemImage: UIImage) -> UIViewController {
        let navigationViewController = UINavigationController(rootViewController: vc)
        navigationViewController.tabBarItem.title = itemName
        navigationViewController.tabBarItem.image = itemImage
        return navigationViewController
    }
}
