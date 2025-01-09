//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit
import SnapKit

final class SocialButton: UIButton {
    
    // MARK: - Properties
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    internal let title: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setTypography(.medium14)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, title])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }()
    
    // MARK: - Init
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        setupUI()
        configure(title: title, image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        layer.cornerRadius = 8
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
    
    // MARK: - Configuration
    func configure(title: String, image: UIImage?) {
        self.title.text = title
        if let image = image {
            // Force the image to be white
            iconImageView.image = image.withRenderingMode(.alwaysTemplate)
        }
    }
    
    func setBackgroundColor(_ color: UIColor) {
        backgroundColor = color
    }
} 
