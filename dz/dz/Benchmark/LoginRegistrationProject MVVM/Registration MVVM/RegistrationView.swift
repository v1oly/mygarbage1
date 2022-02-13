import Foundation
import UIKit

class RegistrationView: UIView {
    
    private let loginField = UITextField()
    private let passwordField = UITextField()
    private let confirmPasswordField = UITextField()
    
    private let registrationLable = UILabel()
    private let loginLable = UILabel()
    private let passwordLable = UILabel()
    private let confirmPasswordLable = UILabel()
    
    private var statusLable = UILabel()
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
        statusLable.textColor = color
        setNeedsLayout()
    }
    
    func setStatusText(_ text: String) {
        statusLable.text = text
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        registrationLable.frame.size = CGSize(width: 115, height: 40)
        registrationLable.center = CGPoint(x: self.bounds.center.x, y: self.bounds.minY + 100)
        
        loginField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        loginField.center = CGPoint(x: bounds.width / 2, y: bounds.minY + 175)
        
        passwordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        passwordField.center = CGPoint(x: bounds.width / 2, y: loginField.frame.maxY + 80)
        
        confirmPasswordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        confirmPasswordField.center = CGPoint(x: bounds.width / 2, y: passwordField.frame.maxY + 80)
        
        loginLable.frame.size = CGSize(width: 100, height: 25)
        loginLable.center = CGPoint(x: self.bounds.center.x, y: loginField.frame.minY - 20)
        loginLable.sizeThatFits(loginLable.frame.size)
        
        passwordLable.frame.size = CGSize(width: 125, height: 25)
        passwordLable.center = CGPoint(x: self.bounds.center.x, y: passwordField.frame.minY - 20)
        passwordLable.sizeThatFits(passwordLable.frame.size)
        
        confirmPasswordLable.frame.size = CGSize(width: 185, height: 25)
        confirmPasswordLable.center = CGPoint(x: self.bounds.center.x, y: confirmPasswordField.frame.minY - 20)
        confirmPasswordLable.sizeThatFits(confirmPasswordLable.frame.size)
        
        confirmRegistrationButton.frame.size = CGSize(width: 100, height: 30)
        confirmRegistrationButton.center = CGPoint(x: bounds.width / 2, y: confirmPasswordField.frame.maxY + 50)
        
        statusLable.sizeToFit()
        statusLable.center = CGPoint(x: bounds.width / 2, y: confirmPasswordField.frame.maxY + 15)
    }
    
    private func setup() {
        backgroundColor = .white
        
        registrationLable.font = UIFont.boldSystemFont(ofSize: 20)
        registrationLable.text = "Registration"
        addSubview(registrationLable)
        
        loginField.backgroundColor = .lightGray
        addSubview(loginField)
        
        passwordField.backgroundColor = .lightGray
        addSubview(passwordField)
        
        confirmPasswordField.backgroundColor = .lightGray
        addSubview(confirmPasswordField)
        
        loginLable.text = "New Login:"
        addSubview(loginLable)
        
        passwordLable.text = "New Password:"
        addSubview(passwordLable)
        
        confirmPasswordLable.text = "Confirm New Password:"
        addSubview(confirmPasswordLable)
        
        confirmRegistrationButton.addTarget(self, action: #selector(confirmRegistration(_:)), for: .touchUpInside)
        confirmRegistrationButton.backgroundColor = .clear
        confirmRegistrationButton.setTitle("Confirm", for: .normal)
        confirmRegistrationButton.setTitleColor(.blue, for: .normal)
        addSubview(confirmRegistrationButton)
        
        addSubview(statusLable)
    }
    
    @objc
    private func confirmRegistration(_ sender: UIButton) {
        onRegConfirm(loginField.text ?? "", passwordField.text ?? "", confirmPasswordField.text ?? "")
    }
}
