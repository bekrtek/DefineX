//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    private let selectedItemImageScale: CGFloat = 1.08
    private let unselectedItemImageScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
        delegate = self
        
        // Set initial scale for selected tab
        if let selectedIndex = tabBar.selectedItem?.tag,
           let tabBarButtons = tabBar.subviews.filter({ $0.isKind(of: NSClassFromString("UITabBarButton")!) }) as? [UIView],
           selectedIndex < tabBarButtons.count {
            tabBarButtons[selectedIndex].transform = CGAffineTransform(scaleX: selectedItemImageScale, y: selectedItemImageScale)
        }
    }
    
    private func setupTabs() {
        // Discovery Tab
        let discoveryVC = DiscoveryRouter.createModule()
        discoveryVC.navigationItem.leftBarButtonItem = createProfileBarButton()
        discoveryVC.navigationItem.rightBarButtonItem = createSearchBarButton()
        let discoveryNav = createNavigationController(for: discoveryVC, title: "discovery.title".localized, 
            image: "house", selectedImage: "house.fill", tag: 0)
        
        // Categories Tab
        let categoriesVC = createPlaceholderViewController(title: "categories.title".localized)
        let categoriesNav = createNavigationController(for: categoriesVC, title: "categories.title".localized,
            image: "square.grid.2x2", selectedImage: "square.grid.2x2.fill", tag: 1)
        
        // Cart Tab
        let cartVC = createPlaceholderViewController(title: "cart.title".localized)
        let cartNav = createNavigationController(for: cartVC, title: "cart.title".localized,
            image: "cart", selectedImage: "cart.fill", tag: 2)
        
        // Favorites Tab
        let favoritesVC = createPlaceholderViewController(title: "favorites.title".localized)
        let favoritesNav = createNavigationController(for: favoritesVC, title: "favorites.title".localized,
            image: "heart", selectedImage: "heart.fill", tag: 3)
        
        // Profile Tab
        let profileVC = createPlaceholderViewController(title: "profile.title".localized)
        let profileNav = createNavigationController(for: profileVC, title: "profile.title".localized,
            image: "person", selectedImage: "person.fill", tag: 4)
        
        viewControllers = [discoveryNav, categoriesNav, cartNav, favoritesNav, profileNav]
    }
    
    private func createNavigationController(for rootViewController: UIViewController, 
                                         title: String, 
                                         image: String, 
                                         selectedImage: String, 
                                         tag: Int) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.prefersLargeTitles = false
        
        // Setup navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = appearance
        nav.navigationBar.compactAppearance = appearance
        nav.navigationBar.tintColor = .black
        
        // Setup tab bar item
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: image)?.withConfiguration(UIImage.SymbolConfiguration(scale: .medium)),
            selectedImage: UIImage(systemName: selectedImage)?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        )
        nav.tabBarItem.tag = tag
        
        return nav
    }
    
    private func createPlaceholderViewController(title: String) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        let label = UILabel()
        switch title {
        case "categories.title".localized:
            label.text = "categories.coming_soon".localized
        case "cart.title".localized:
            label.text = "cart.coming_soon".localized
        case "favorites.title".localized:
            label.text = "favorites.coming_soon".localized
        case "profile.title".localized:
            label.text = "profile.coming_soon".localized
        default:
            label.text = "\(title) - Coming Soon"
        }
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .gray
        
        viewController.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])
        
        return viewController
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 16
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            let normalItemAppearance = UITabBarItemAppearance()
            normalItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            normalItemAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.systemBlue,
                .font: UIFont.systemFont(ofSize: 12, weight: .medium)
            ]
            
            appearance.stackedLayoutAppearance = normalItemAppearance
            appearance.inlineLayoutAppearance = normalItemAppearance
            appearance.compactInlineLayoutAppearance = normalItemAppearance
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.items?.forEach { item in
                item.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
                item.setTitleTextAttributes([
                    .foregroundColor: UIColor.systemBlue,
                    .font: UIFont.systemFont(ofSize: 12, weight: .medium)
                ], for: .selected)
            }
        }
    }
    
    private func createProfileBarButton() -> UIBarButtonItem {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "person.circle", withConfiguration: imageConfig)
        return UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
    
    private func createSearchBarButton() -> UIBarButtonItem {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: imageConfig)
        return UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
}

// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view,
              let fromIndex = viewControllers?.firstIndex(of: selectedViewController!),
              let toIndex = viewControllers?.firstIndex(of: viewController),
              fromIndex != toIndex else {
            return true
        }
        
        // Animate tab selection
        UIView.transition(from: fromView,
                         to: toView,
                         duration: 0.2,
                         options: [.transitionCrossDissolve],
                         completion: nil)
        
        // Animate icon scale
        let tabBarButtons = tabBar.subviews.filter { $0.isKind(of: NSClassFromString("UITabBarButton")!) }
        
        UIView.animate(withDuration: 0.2) {
            tabBarButtons.enumerated().forEach { index, button in
                if index == toIndex {
                    button.transform = CGAffineTransform(scaleX: self.selectedItemImageScale, y: self.selectedItemImageScale)
                } else {
                    button.transform = CGAffineTransform(scaleX: self.unselectedItemImageScale, y: self.unselectedItemImageScale)
                }
            }
        }
        
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Animate title appearance
        UIView.animate(withDuration: 0.2) {
            self.tabBar.items?.forEach { tabItem in
                if tabItem == item {
                    tabItem.setTitleTextAttributes([
                        .foregroundColor: UIColor.systemBlue,
                        .font: UIFont.systemFont(ofSize: 12, weight: .medium)
                    ], for: .selected)
                } else {
                    tabItem.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
                }
            }
            self.tabBar.layoutIfNeeded()
        }
    }
} 
