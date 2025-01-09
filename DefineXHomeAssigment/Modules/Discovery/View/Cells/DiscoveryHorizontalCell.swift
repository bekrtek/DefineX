import UIKit
import SnapKit
import SDWebImage

final class DiscoveryHorizontalCell: UICollectionViewCell {
    static let identifier = "DiscoveryHorizontalCell"
    
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
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var oldPriceContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var currentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemRed
        return label
    }()
    
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
        
        priceStackView.addArrangedSubview(currentPriceLabel)
        priceStackView.addArrangedSubview(oldPriceContainer)
        
        oldPriceContainer.addArrangedSubview(oldPriceLabel)
        oldPriceContainer.addArrangedSubview(discountLabel)
        
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
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configuration
    func configure(with item: DiscoveryItem) {
        titleLabel.text = item.description
        
        if !item.discount.isEmpty {
            // Calculate discounted price
            let originalPrice = item.price.value
            let discountValue = Double(item.discount.replacingOccurrences(of: "% OFF", with: "")) ?? 0
            let discountedPrice = originalPrice * (100 - discountValue) / 100
            
            currentPriceLabel.text = "\(item.price.currency)\(String(format: "%.2f", discountedPrice))"
            
            let attributedString = NSAttributedString(
                string: "\(item.price.currency)\(String(format: "%.2f", originalPrice))",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .strikethroughColor: UIColor.systemGray
                ]
            )
            oldPriceLabel.attributedText = attributedString
            oldPriceLabel.isHidden = false
            discountLabel.text = "• \(item.discount)"
            discountLabel.isHidden = false
            oldPriceContainer.isHidden = false
        } else {
            currentPriceLabel.text = "\(item.price.currency)\(String(format: "%.2f", item.price.value))"
            oldPriceLabel.isHidden = true
            discountLabel.isHidden = true
            oldPriceContainer.isHidden = true
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
        oldPriceLabel.text = nil
        discountLabel.text = nil
        oldPriceLabel.isHidden = true
        discountLabel.isHidden = true
        oldPriceContainer.isHidden = true
    }
} 
