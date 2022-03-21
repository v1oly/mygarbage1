import Foundation
import UIKit

class RegistrationView: UIView {
    
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let confirmPasswordField = UITextField()
    
    private let registrationLabel = UILabel()
    private let loginLabel = UILabel()
    private let passwordLabel = UILabel()
    private let confirmPasswordLabel = UILabel()
    
    private var statusLabel = UILabel()
    private var onRegConfirm: (_ login: String, _ password: String, _ confirmPassword: String) -> ()

    private let confirmRegistrationButton = UIButton()
    
    init(onRegConfirm: @escaping (_ login: String, _ password: String, _ confirmPassword: String) -> ()) {
        self.onRegConfirm = onRegConfirm
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Coder doesn't found")
    }
    
    func setStatusColor(_ color: UIColor) {
        statusLabel.textColor = color
        setNeedsLayout()
    }
    
    func setStatusText(_ text: String) {
        statusLabel.text = text
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        registrationLabel.frame.size = CGSize(width: 115, height: 40)
        registrationLabel.center = CGPoint(x: self.bounds.center.x, y: self.bounds.minY + 100)
        
        loginField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        loginField.center = CGPoint(x: bounds.width / 2, y: bounds.minY + 175)
        
        passwordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        passwordField.center = CGPoint(x: bounds.width / 2, y: loginField.frame.maxY + 80)
        
        confirmPasswordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        confirmPasswordField.center = CGPoint(x: bounds.width / 2, y: passwordField.frame.maxY + 80)
        
        loginLabel.frame.size = CGSize(width: 100, height: 25)
        loginLabel.center = CGPoint(x: self.bounds.center.x, y: loginField.frame.minY - 20)
        loginLabel.sizeThatFits(loginLabel.frame.size)
        
        passwordLabel.frame.size = CGSize(width: 125, height: 25)
        passwordLabel.center = CGPoint(x: self.bounds.center.x, y: passwordField.frame.minY - 20)
        passwordLabel.sizeThatFits(passwordLabel.frame.size)
        
        confirmPasswordLabel.frame.size = CGSize(width: 185, height: 25)
        confirmPasswordLabel.center = CGPoint(x: self.bounds.center.x, y: confirmPasswordField.frame.minY - 20)
        confirmPasswordLabel.sizeThatFits(confirmPasswordLabel.frame.size)
        
        confirmRegistrationButton.frame.size = CGSize(width: 100, height: 30)
        confirmRegistrationButton.center = CGPoint(x: bounds.width / 2, y: confirmPasswordField.frame.maxY + 50)
        
        statusLabel.sizeToFit()
        statusLabel.center = CGPoint(x: bounds.width / 2, y: confirmPasswordField.frame.maxY + 15)
    }
    
    private func setup() {
        backgroundColor = .white
        
        registrationLabel.font = UIFont.boldSystemFont(ofSize: 20)
        registrationLabel.text = "Registration"
        addSubview(registrationLabel)
        
        loginField.backgroundColor = .lightGray
        addSubview(loginField)
        
        passwordField.backgroundColor = .lightGray
        addSubview(passwordField)
        
        confirmPasswordField.backgroundColor = .lightGray
        addSubview(confirmPasswordField)
        
        loginLabel.text = "New Login:"
        addSubview(loginLabel)
        
        passwordLabel.text = "New Password:"
        addSubview(passwordLabel)
        
        confirmPasswordLabel.text = "Confirm New Password:"
        addSubview(confirmPasswordLabel)
        
        confirmRegistrationButton.addTarget(self, action: #selector(confirmRegistration(_:)), for: .touchUpInside)
        confirmRegistrationButton.backgroundColor = .clear
        confirmRegistrationButton.setTitle("Confirm", for: .normal)
        confirmRegistrationButton.setTitleColor(.blue, for: .normal)
        addSubview(confirmRegistrationButton)
        
        addSubview(statusLabel)
    }
    
    @objc
    private func confirmRegistration(_ sender: UIButton) {
        onRegConfirm(loginField.text ?? "", passwordField.text ?? "", confirmPasswordField.text ?? "")
    }
}
