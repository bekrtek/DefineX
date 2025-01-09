import UIKit
import SnapKit

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: LoginPresenterProtocol?
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "login.app_title".localized
        label.numberOfLines = 2
        label.textAlignment = .center
        label.setTypography(.headlin24)
        label.textColor = Colors.primary
        return label
    }()
    
    private lazy var emailTextField: CustomTextField = {
        let textField = CustomTextField(title: "login.email.title".localized)
        textField.setPlaceholder("login.email.placeholder".localized)
        textField.setKeyboardType(.emailAddress)
        let email = UIImage(named: "email")?.withRenderingMode(.alwaysTemplate).withTintColor(.darkGray)
        textField.setImage(email)
        return textField
    }()
    
    private lazy var passwordTextField: CustomTextField = {
        let textField = CustomTextField(title: "login.password.title".localized)
        textField.setPlaceholder("login.password.placeholder".localized)
        textField.setSecureTextEntry(true)
        let lock = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate).withTintColor(.darkGray)
        textField.setImage(lock)
        return textField
    }()
    
    private lazy var loginButton: GradientButton = {
        let button = GradientButton()
        button.setTitle("login.button.title".localized, for: .normal)
        button.setTypography(.medium14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("login.forgot_password.title".localized, for: .normal)
        button.setTypography(.regular12)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        button.configureBorder(color: UIColor(hex: "#304FFE"), width: 1, cornerRadius: 6)
        return button
    }()
    
    private lazy var socialButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var facebookButton: SocialButton = {
        let button = SocialButton(
            title: "login.social.facebook".localized,
            image: UIImage(named: "Facebook")
        )
        button.setBackgroundColor(Colors.Button.facebook)
        button.addTarget(self, action: #selector(socialButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var twitterButton: SocialButton = {
        let button = SocialButton(
            title: "login.social.twitter".localized,
            image: UIImage(named: "Twitter")
        )
        button.setBackgroundColor(Colors.Button.twitter)
        button.addTarget(self, action: #selector(socialButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(socialButtonsStackView)
        view.addSubview(activityIndicator)
        
        socialButtonsStackView.addArrangedSubview(facebookButton)
        socialButtonsStackView.addArrangedSubview(twitterButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(24)
            make.leading.trailing.equalTo(emailTextField)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(44)
        }
        
        forgotPasswordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(32)
            make.bottom.equalTo(socialButtonsStackView.snp.top).offset(-32)
        }
        
        socialButtonsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(emailTextField)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(44)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.getText(), !email.isEmpty else {
            emailTextField.setState(.error, errorMessage: "login.error.email_required".localized)
            return
        }
        
        guard let password = passwordTextField.getText(), !password.isEmpty else {
            passwordTextField.setState(.error, errorMessage: "login.error.password_required".localized)
            return
        }
        
        // Reset error states
        emailTextField.setState(.default)
        passwordTextField.setState(.default)
        
        presenter?.loginButtonTapped(email: email, password: password)
    }
    
    @objc private func socialButtonTapped() {
        let alert = UIAlertController(
            title: "common.coming_soon.title".localized,
            message: "common.coming_soon.message".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
        present(alert, animated: true)
    }
    
    @objc private func forgotPasswordTapped() {
        let alert = UIAlertController(
            title: "common.coming_soon.title".localized,
            message: "common.coming_soon.message".localized,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
            self?.loginButton.isEnabled = false
            self?.emailTextField.setState(.disabled)
            self?.passwordTextField.setState(.disabled)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.loginButton.isEnabled = true
            self?.emailTextField.setState(.default)
            self?.passwordTextField.setState(.default)
        }
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(
                title: "common.error".localized,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "common.ok".localized, style: .default))
            self?.present(alert, animated: true)
            
            self?.emailTextField.setState(.error)
            self?.passwordTextField.setState(.error)
        }
    }
} 
