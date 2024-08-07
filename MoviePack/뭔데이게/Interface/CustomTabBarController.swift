//
//  CustomTabBarController.swift
//  MoviePack
//
//  Created by 서충원 on 7/12/24.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItems()
        configureTabBar(space: 40, addHeight: 11)
    }
    
    func configureTabBarItems() {
        let homeViewController = HomeViewController(view: HomeView(), viewModel: HomeViewModel())
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem.image = UIImage(systemName: "movieclapper")
        homeNavigationController.tabBarItem.selectedImage = UIImage(systemName: "movieclapper.fill")
        
        let addlistViewController = UINavigationController(rootViewController: TrendViewController())
        addlistViewController.tabBarItem.image = UIImage(systemName: "list.bullet.clipboard")
        addlistViewController.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.clipboard.fill")
        
        let userViewController = SearchViewController(view: SearchView(), viewModel: SearchViewModel())
        let userNavigationController = UINavigationController(rootViewController: userViewController)
        userNavigationController.tabBarItem.image = UIImage(systemName: "popcorn")
        userNavigationController.tabBarItem.selectedImage = UIImage(systemName: "popcorn.fill")
        
        let settingViewController = SettingViewController(view: SettingView(), viewModel: SettingViewModel())
        let settingNavigationController = UINavigationController(rootViewController: settingViewController)
        settingNavigationController.tabBarItem.image = UIImage(systemName: "person")
        settingNavigationController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        viewControllers = [homeNavigationController, addlistViewController, userNavigationController, settingNavigationController]
    }
    
    func configureTabBar(space: CGFloat, addHeight: CGFloat) {
        ///Gradient View
        let gradientView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: tabBar.frame.width, height: 100)))
        gradientView.backgroundColor = .clear

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)

        tabBar.insertSubview(gradientView, at: 0)
        
        ///Draw Custom TabBar
        let layer = CAShapeLayer()
        let x: CGFloat = space
        let width: CGFloat = tabBar.bounds.width - (x * 2)
        let baseHeight: CGFloat = 49
        let currentHeight: CGFloat = baseHeight + addHeight
        let y: CGFloat = -(5.5 + addHeight/2)
        
        let rectSize = CGRect(x: x, y: y, width: width, height: currentHeight)
        let path = UIBezierPath(roundedRect: rectSize, cornerRadius: currentHeight / 2).cgPath
        layer.path = path
        ///Background Color
        layer.fillColor = UIColor.black.cgColor
        ///Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        
        self.tabBar.layer.insertSublayer(layer, at: 1)
        ///Item Color
        self.tabBar.tintColor = Colors.blueAccent
        self.tabBar.unselectedItemTintColor = Colors.blackDescription
        ///TabBar Appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.stackedItemWidth = width / 7
        appearance.stackedItemPositioning = .centered

        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
    }
}
