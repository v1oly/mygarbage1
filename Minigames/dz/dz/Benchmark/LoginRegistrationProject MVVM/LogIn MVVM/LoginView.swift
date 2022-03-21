import Foundation
import UIKit

class LoginView: UIView {
    
    private let loginField = UITextField()
    private let passwordField = UITextField()
    
    private let loginLabel = UILabel()
    private let passwordLabel = UILabel()
    private let statusLabel = UILabel()
    
    private let confirmLogInButton = UIButton()
    private let openRegistarionViewButton = UIButton()
    
    var onConfirm: ((_ login: String, _ password: String) -> ())
    var onOpenRegistrationView: () -> ()
    
    init(
        onConfirm: @escaping ((_ login: String, _ password: String)-> ()),
        onOpenRegistrationView: @escaping () -> ()
    ) {
        self.onOpenRegistrationView = onOpenRegistrationView
        self.onConfirm = onConfirm
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError( "fatal error: coder doesn't found")
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
        
        confirmLogInButton.frame.size = CGSize(width: 100, height: 30)
        confirmLogInButton.center = CGPoint(x: bounds.center.x, y: passwordField.frame.maxY + 50)
        
        openRegistarionViewButton.frame.size = CGSize(width: 100, height: 30)
        openRegistarionViewButton.center = CGPoint(x: bounds.center.x, y: confirmLogInButton.frame.maxY + 50)
        
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
        
        confirmLogInButton.addTarget(self, action: #selector(confirmLoggingIn(_:)), for: .touchUpInside)
        confirmLogInButton.backgroundColor = .clear
        confirmLogInButton.setTitle("Confirm", for: .normal)
        confirmLogInButton.setTitleColor(.blue, for: .normal)
        addSubview(confirmLogInButton)
        
        openRegistarionViewButton.addTarget(self, action: #selector(openRegistarionView(_:)), for: .touchUpInside)
        openRegistarionViewButton.backgroundColor = .clear
        openRegistarionViewButton.setTitle("Sing Up", for: .normal)
        openRegistarionViewButton.setTitleColor(.blue, for: .normal)
        addSubview(openRegistarionViewButton)
        
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
        onConfirm(loginField.text ?? "", passwordField.text ?? "")
    }
    
    @objc
    private func openRegistarionView(_ sender: UIButton) {
        onOpenRegistrationView()
    }
}
