import Foundation
import UIKit

class RegistrationView: UIView {
    
    private let regLoginField = UITextField()
    private let regPasswordField = UITextField()
    private let regConfirmPasswordField = UITextField()
    
    private let registrationLable = UILabel()
    private let regLoginLable = UILabel()
    private let regPasswordLable = UILabel()
    private let regConfirmPasswordLable = UILabel()
    
    private var statusLable = UILabel()
    private var onRegConfirm: (String, String, String) -> ()

    private let confirmRegistrationButton = UIButton()
    
    init(onRegConfirm: @escaping (String, String, String) -> ()) {
        self.onRegConfirm = onRegConfirm
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
        
        regLoginField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        regLoginField.center = CGPoint(x: bounds.width / 2, y: bounds.minY + 175)
        
        regPasswordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        regPasswordField.center = CGPoint(x: bounds.width / 2, y: regLoginField.frame.maxY + 80)
        
        regConfirmPasswordField.frame.size = CGSize(width: bounds.width / 1.25, height: 30)
        regConfirmPasswordField.center = CGPoint(x: bounds.width / 2, y: regPasswordField.frame.maxY + 80)
        
        regLoginLable.frame.size = CGSize(width: 100, height: 25)
        regLoginLable.center = CGPoint(x: self.bounds.center.x, y: regLoginField.frame.minY - 20)
        regLoginLable.sizeThatFits(regLoginLable.frame.size)
        
        regPasswordLable.frame.size = CGSize(width: 125, height: 25)
        regPasswordLable.center = CGPoint(x: self.bounds.center.x, y: regPasswordField.frame.minY - 20)
        regPasswordLable.sizeThatFits(regPasswordLable.frame.size)
        
        regConfirmPasswordLable.frame.size = CGSize(width: 185, height: 25)
        regConfirmPasswordLable.center = CGPoint(x: self.bounds.center.x, y: regConfirmPasswordField.frame.minY - 20)
        regConfirmPasswordLable.sizeThatFits(regConfirmPasswordLable.frame.size)
        
        confirmRegistrationButton.frame.size = CGSize(width: 100, height: 30)
        confirmRegistrationButton.center = CGPoint(x: bounds.width / 2, y: regConfirmPasswordField.frame.maxY + 50)
        
        statusLable.sizeToFit()
        statusLable.center = CGPoint(x: bounds.width / 2, y: regConfirmPasswordField.frame.maxY + 15)
    }
    
    private func setup() {
        backgroundColor = .white
        
        registrationLable.font = UIFont.boldSystemFont(ofSize: 20)
        registrationLable.text = "Registration"
        addSubview(registrationLable)
        
        regLoginField.backgroundColor = .lightGray
        addSubview(regLoginField)
        
        regPasswordField.backgroundColor = .lightGray
        addSubview(regPasswordField)
        
        regConfirmPasswordField.backgroundColor = .lightGray
        addSubview(regConfirmPasswordField)
        
        regLoginLable.text = "New Login:"
        addSubview(regLoginLable)
        
        regPasswordLable.text = "New Password:"
        addSubview(regPasswordLable)
        
        regConfirmPasswordLable.text = "Confirm New Password:"
        addSubview(regConfirmPasswordLable)
        
        confirmRegistrationButton.addTarget(self, action: #selector(confirmRegistration(_:)), for: .touchUpInside)
        confirmRegistrationButton.backgroundColor = .clear
        confirmRegistrationButton.setTitle("Confirm", for: .normal)
        confirmRegistrationButton.setTitleColor(.blue, for: .normal)
        addSubview(confirmRegistrationButton)
        
        addSubview(statusLable)
    }
    
    @objc
    private func confirmRegistration(_ sender: UIButton) {
        onRegConfirm(regLoginField.text ?? "", regPasswordField.text ?? "", regConfirmPasswordField.text ?? "")
    }
}
