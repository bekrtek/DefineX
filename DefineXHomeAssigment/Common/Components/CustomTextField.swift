//
//  SceneDelegate.swift
//  DefineXHomeAssigment
//
//  Created by Bekir Tek on 9.01.2025.
//

import UIKit
import SnapKit

enum CustomTextFieldState {
    case `default`
    case disabled
    case focused
    case error
    
    var lineColor: UIColor {
        switch self {
        case .default:
            return Colors.TextField.Line.default
        case .disabled:
            return Colors.TextField.Line.default
        case .focused:
            return Colors.TextField.Line.focused
        case .error:
            return Colors.TextField.Line.error
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default, .focused:
            return Colors.TextField.text
        case .disabled:
            return Colors.TextField.placeholder
        case .error:
            return Colors.TextField.text
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .default, .focused, .error:
            return .white
        case .disabled:
            return Colors.TextField.Line.default.withAlphaComponent(0.1)
        }
    }
}

class CustomTextField: UIView {
    // MARK: - Properties
    private var state: CustomTextFieldState = .default {
        didSet {
            updateStyle()
        }
    }
    
    private var title: String
    private var rightImageTapAction: (() -> Void)?
    
    var isSecureTextEntry: Bool {
        get { textField.isSecureTextEntry }
        set { textField.isSecureTextEntry = newValue }
    }
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setTypography(.regular14)
        label.textColor = Colors.TextField.title
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.setTypography(.regular14)
        textField.borderStyle = .none
        textField.delegate = self
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = state.lineColor
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.setTypography(.regular12)
        label.textColor = Colors.TextField.Line.error
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(imageView)
        addSubview(bottomLine)
        addSubview(errorLabel)
        
        titleLabel.text = title
        
        setupConstraints()
        updateStyle()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(textField).offset(-7)
            make.width.height.equalTo(32)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(imageView.snp.leading).offset(-8)
            make.height.equalTo(44)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(bottomLine.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func updateStyle() {
        bottomLine.backgroundColor = state.lineColor
        textField.textColor = state.textColor
        textField.backgroundColor = state.backgroundColor
        textField.isEnabled = state != .disabled
        imageView.tintColor = .gray
        
        // Update placeholder color
        let placeholderColor: UIColor = state == .disabled ? Colors.TextField.placeholder : Colors.TextField.placeholder
        if let placeholder = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: placeholderColor]
            )
        }
    }
    
    // MARK: - Public Methods
    func setState(_ state: CustomTextFieldState, errorMessage: String? = nil) {
        self.state = state
        errorLabel.text = errorMessage
        errorLabel.isHidden = state != .error
    }
    
    func setPlaceholder(_ placeholder: String) {
        textField.placeholder = placeholder
        updateStyle()
    }
    
    func setText(_ text: String?) {
        textField.text = text
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func setSecureTextEntry(_ isSecure: Bool) {
        textField.isSecureTextEntry = isSecure
    }
    
    func setKeyboardType(_ type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    func setImage(_ image: UIImage?) {
        guard let image = image else {
            imageView.isHidden = true
            return
        }
        
        imageView.image = image
        imageView.isHidden = false
        
        textField.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            if self.isRTL {
                make.trailing.equalTo(imageView.snp.leading).offset(8)
            } else {
                make.trailing.equalTo(imageView.snp.trailing).offset(-8)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if state != .disabled {
            state = .focused
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if state == .focused {
            state = .default
        }
    }
} 
