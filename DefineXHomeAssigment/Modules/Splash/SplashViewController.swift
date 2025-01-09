//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let userManager = UserManager.shared
    
    // MARK: - UI Components
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "login.app_title".localized
        label.numberOfLines = 2
        label.textAlignment = .center
        label.setTypography(.title20)
        label.textColor = Colors.primary
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - Animations
    private func startAnimations() {
        // Scale down and fade out slightly to create a "bounce" effect
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.logoImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.logoImageView.alpha = 0.8
            self?.titleLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.titleLabel.alpha = 0.8
        } completion: { [weak self] _ in
            // Bounce back with spring animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5) { [weak self] in
                self?.logoImageView.transform = .identity
                self?.logoImageView.alpha = 1
                self?.titleLabel.transform = .identity
                self?.titleLabel.alpha = 1
            } completion: { [weak self] _ in
                self?.checkLoginState()
            }
        }
    }
    
    // MARK: - Navigation
    private func checkLoginState() {
        DispatchQueue.main.async { [weak self] in
            if self?.userManager.validateSession() == true {
                self?.navigateToMainScreen()
            } else {
                self?.navigateToLogin()
            }
        }
    }
    
    private func navigateToMainScreen() {
        let tabBarController = MainTabBarController()
        UIView.transition(with: view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.window?.rootViewController = tabBarController
        })
    }
    
    private func navigateToLogin() {
        let loginVC = LoginRouter.createModule()
        UIView.transition(with: view.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.view.window?.rootViewController = loginVC
        })
    }
} 
