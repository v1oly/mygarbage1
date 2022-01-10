import UIKit

class LoginVC: UIViewController, PassDelegate {
    
    let loginView = LoginView()
    let loginVM = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = loginView
        bindVM()
        loginView.delegate = self
    }
    
    func checkUserLogInToMatchInBase() {
        loginVM.checkUserLogInToMatchInBase(
            login: loginView.loginField.text ?? "",
            password: loginView.passwordField.text ?? ""
        )
        loginView.layoutSubviews()
    }

    func bindVM() {
        loginVM.statusText.bind({ (statusText) in
            DispatchQueue.main.async {
                self.loginView.statusLabel.text = statusText
            }
        })
        loginVM.statusColor.bind({ (statusColor) in
            DispatchQueue.main.async {
                self.loginView.statusLabel.textColor = statusColor
            }
        })
    }
}

protocol PassDelegate: AnyObject {
    func checkUserLogInToMatchInBase()
}

class LoginView: UIView {
    
    let loginField = UITextField()
    let passwordField = UITextField()
    
    let loginLabel = UILabel()
    let passwordLabel = UILabel()
    let statusLabel = UILabel()
    
    let confirmButton = UIButton()
    weak var delegate: PassDelegate?
    
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
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY)
        
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
    
    func setup() {
        
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
        
        statusLabel.text = ""
        statusLabel.textColor = .clear
        addSubview(statusLabel)
        
        layoutSubviews()
    }
    
    @objc
    func confirmLoggingIn(_ sender: UIButton) {
        delegate?.checkUserLogInToMatchInBase()
    }
}
