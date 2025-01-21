//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit
import SnapKit

final class DiscoveryTwoColumnCell: UICollectionViewCell {
    static let identifier = "DiscoveryTwoColumnCell"
    
    // MARK: - UI Components
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(.subheading16)
        label.textColor = .black
        label.numberOfLines = 3
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()
    
    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.setTypography(.title20)
        label.textColor = .black
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()
    
    private var starImageViews: [UIImageView] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(priceStackView)
        containerView.addSubview(ratingStackView)
        
        priceStackView.addArrangedSubview(currentPriceLabel)
        
        // Create star image views
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.tintColor = .systemGreen
            ratingStackView.addArrangedSubview(starImageView)
            starImageViews.append(starImageView)
            
            starImageView.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(priceStackView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configuration
    func configure(with item: DiscoveryItem) {
        titleLabel.text = item.description
        currentPriceLabel.text = "\(item.price.currency)\(String(format: "%.2f", item.price.value))"
        
        // Configure rating stars
        let rating = item.ratePercentage ?? 0
        let starCount = Int(ceil(Double(rating) / 20.0)) // Convert percentage to 5-star scale
        for (index, starView) in starImageViews.enumerated() {
            if index < starCount {
                starView.image = UIImage(systemName: "star.fill")
            } else {
                starView.image = UIImage(systemName: "star")
            }
        }
        
        let placeholder = UIImage(systemName: "photo")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        imageView.sd_setImage(
            with: URL(string: item.imageUrl),
            placeholderImage: placeholder,
            options: [.retryFailed, .scaleDownLargeImages],
            context: [.imageThumbnailPixelSize: CGSize(width: 300, height: 300)]
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        currentPriceLabel.text = nil
        starImageViews.forEach { $0.image = nil }
    }
} 
