//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit
import SnapKit

final class DiscoveryViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: DiscoveryPresenterProtocol?
    private var firstHorizontalItems: [DiscoveryItem] = []
    private var secondHorizontalItems: [DiscoveryItem] = []
    private var twoColumnItems: [DiscoveryItem] = []
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.refreshControl = refreshControl
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    private lazy var firstHorizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DiscoveryHorizontalCell.self, forCellWithReuseIdentifier: DiscoveryHorizontalCell.identifier)
        return collectionView
    }()
    
    private lazy var secondHorizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DiscoveryHorizontalCell.self, forCellWithReuseIdentifier: DiscoveryHorizontalCell.identifier)
        return collectionView
    }()
    
    private lazy var twoColumnCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DiscoveryTwoColumnCell.self, forCellWithReuseIdentifier: DiscoveryTwoColumnCell.identifier)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemGray6
        navigationItem.title = "Home"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let userInitialsLabel = UILabel()
        userInitialsLabel.text = "NA"
        userInitialsLabel.textAlignment = .center
        userInitialsLabel.backgroundColor = .systemPurple
        userInitialsLabel.textColor = .white
        userInitialsLabel.layer.cornerRadius = 15
        userInitialsLabel.clipsToBounds = true
        userInitialsLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userInitialsLabel)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(firstHorizontalCollectionView)
        stackView.addArrangedSubview(secondHorizontalCollectionView)
        stackView.addArrangedSubview(twoColumnCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        firstHorizontalCollectionView.snp.makeConstraints { make in
            make.height.equalTo(280)
        }
        
        secondHorizontalCollectionView.snp.makeConstraints { make in
            make.height.equalTo(210)
        }
        
        twoColumnCollectionView.snp.makeConstraints { make in
            make.height.equalTo(1000)
        }
    }
    
    // MARK: - Actions
    @objc private func refreshData() {
        presenter?.refreshData()
    }
}

// MARK: - UICollectionViewDataSource
extension DiscoveryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case firstHorizontalCollectionView:
            return firstHorizontalItems.count
        case secondHorizontalCollectionView:
            return secondHorizontalItems.count
        case twoColumnCollectionView:
            return twoColumnItems.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case firstHorizontalCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoveryHorizontalCell.identifier, for: indexPath) as! DiscoveryHorizontalCell
            cell.configure(with: firstHorizontalItems[indexPath.item])
            return cell
            
        case secondHorizontalCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoveryHorizontalCell.identifier, for: indexPath) as! DiscoveryHorizontalCell
            cell.configure(with: secondHorizontalItems[indexPath.item])
            return cell
            
        case twoColumnCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoveryTwoColumnCell.identifier, for: indexPath) as! DiscoveryTwoColumnCell
            cell.configure(with: twoColumnItems[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoveryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case firstHorizontalCollectionView:
            let width: CGFloat = 160
            let imageHeight = width
            let titleHeight: CGFloat = 48
            let priceStackHeight: CGFloat = 70
            let totalPadding: CGFloat = 0
            
            return CGSize(width: width, height: imageHeight + titleHeight + priceStackHeight + totalPadding)
            
        case secondHorizontalCollectionView:
            let width: CGFloat = 120
            let imageHeight = width
            let titleHeight: CGFloat = 48
            let priceStackHeight: CGFloat = 40
            let totalPadding: CGFloat = 0
            
            return CGSize(width: width, height: imageHeight + titleHeight + priceStackHeight + totalPadding)
            
        case twoColumnCollectionView:
            let spacing: CGFloat = 16
            let horizontalInset: CGFloat = 16
            let availableWidth = collectionView.bounds.width - (horizontalInset * 2) - spacing
            let cellWidth = (availableWidth / 2).rounded(.down)
            
            let imageHeight = cellWidth
            let titleHeight: CGFloat = 48
            let priceHeight: CGFloat = 30
            let ratingHeight: CGFloat = 24
            let totalPadding: CGFloat = 48
            
            return CGSize(width: cellWidth, height: imageHeight + titleHeight + priceHeight + ratingHeight + totalPadding)
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - DiscoveryViewProtocol
extension DiscoveryViewController: DiscoveryViewProtocol {
    func showLoading() {
        refreshControl.beginRefreshing()
    }
    
    func hideLoading() {
        refreshControl.endRefreshing()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "discovery.error.title".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
        present(alert, animated: true)
    }
    
    func updateFirstHorizontalList(_ items: [DiscoveryItem]) {
        firstHorizontalItems = items
        firstHorizontalCollectionView.reloadData()
    }
    
    func updateSecondHorizontalList(_ items: [DiscoveryItem]) {
        secondHorizontalItems = items
        secondHorizontalCollectionView.reloadData()
    }
    
    func updateTwoColumnList(_ items: [DiscoveryItem]) {
        twoColumnItems = items
        twoColumnCollectionView.reloadData()
        
        let spacing: CGFloat = 16
        let horizontalInset: CGFloat = 16
        let availableWidth = twoColumnCollectionView.bounds.width - (horizontalInset * 2) - spacing
        let cellWidth = (availableWidth / 2).rounded(.down)
        
        let imageHeight = cellWidth
        let titleHeight: CGFloat = 48
        let priceHeight: CGFloat = 30
        let ratingHeight: CGFloat = 24
        let totalPadding: CGFloat = 48
        let cellHeight = imageHeight + titleHeight + priceHeight + ratingHeight + totalPadding
        
        let itemCount = CGFloat(items.count)
        let rows = ceil(itemCount / 2)
        let totalHeight = (rows * cellHeight) + ((rows + 1) * spacing)
        
        twoColumnCollectionView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
    }
} 
