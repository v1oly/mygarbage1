import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()
    private let loginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginView
        bind()
    }
    
    func checkUserLogInToMatchInBase(login: String, password: String) {
        loginViewModel.checkUserLogInToMatchInBase(
            login: login,
            password: password
        )
    }
    
    private func bind() {
        loginViewModel.statusText.bind { [weak self] statusText in
            DispatchQueue.main.async {
                self?.loginView.setStatusText(statusText)
            }
        }
        
        loginViewModel.statusColor.bind { [weak self] statusColor in
            DispatchQueue.main.async {
                self?.loginView.setStatusColor(statusColor)
            }
        }
        
        loginView.onConfirm = { [weak self] login, password in
            self?.checkUserLogInToMatchInBase(login: login, password: password)
        }
    }
}

class LoginView: UIView {
    
    private let loginField = UITextField()
    private let passwordField = UITextField()
    
    private let loginLabel = UILabel()
    private let passwordLabel = UILabel()
    private let statusLabel = UILabel()
    
    private let confirmButton = UIButton()
    
    var onConfirm: ((_ login: String, _ password: String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                
        loginField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        loginField.center = CGPoint(x: bounds.width / 2, y: bounds.minY + 175)
        
        passwordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        passwordField.center = CGPoint(x: bounds.width / 2, y: loginField.frame.maxY + 80)
        
        loginLabel.frame.size = CGSize(width: 100, height: 25)
        loginLabel.sizeToFit()
        loginLabel.center = CGPoint(x: bounds.width / 2, y: loginField.frame.minY - 20)
        
        passwordLabel.frame.size = CGSize(width: 100, height: 25)
        passwordLabel.sizeToFit()
        passwordLabel.center = CGPoint(x: bounds.width / 2, y: passwordField.frame.minY - 20)
        
        confirmButton.frame.size = CGSize(width: 100, height: 30)
        confirmButton.center = CGPoint(x: bounds.center.x, y: passwordField.frame.maxY + 50)
        
        statusLabel.frame.size = CGSize(width: 50, height: 15)
        statusLabel.sizeToFit()
        statusLabel.center = CGPoint(x: bounds.center.x, y: passwordField.frame.maxY + 10)
    }
    
    private func setup() {
        backgroundColor = .white
    
        loginField.backgroundColor = UIColor.lightGray
        addSubview(loginField)
        
        passwordField.backgroundColor = UIColor.lightGray
        addSubview(passwordField)
        
        loginLabel.text = "Login:"
        addSubview(loginLabel)
        
        passwordLabel.text = "Password:"
        addSubview(passwordLabel)
        
        confirmButton.addTarget(self, action: #selector(confirmLoggingIn(_:)), for: .touchUpInside)
        confirmButton.backgroundColor = .clear
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.blue, for: .normal)
        addSubview(confirmButton)
        
        addSubview(statusLabel)
    }
    
    func setStatusColor(_ color: UIColor) {
        statusLabel.textColor = color
        setNeedsLayout()
    }
    
    func setStatusText(_ text: String) {
        statusLabel.text = text
        setNeedsLayout()
    }
    
    @objc
    private func confirmLoggingIn(_ sender: UIButton) {
        onConfirm?(loginField.text ?? "", passwordField.text ?? "")
    }
}
