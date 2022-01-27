import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    
    private var registrationView: RegistrationView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var viewModel: RegistrationViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    private var updateLoginState: () -> ()
    
    init(updateLoginState: @escaping () -> ()) {
        self.updateLoginState = updateLoginState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel(onModelChange: { [weak self] model in
            self?.setTuringForStatusCondition(statusCondition: model.currentStatusCondition)
        })
    }
    
    override func loadView() {
        registrationView = RegistrationView(onRegConfirm: { [weak self] login, passwd, passwd2 in
            self?.viewModel.checkIsRegistrationDataHaveMistakesAndSetNewAccountIfHavent(
                login: login,
                password: passwd,
                confirmPassword: passwd2
            )
        })
        view = registrationView
    }
    
    private func setTuringForStatusCondition(statusCondition: RegistrationStatusCondition) {
        switch statusCondition {
        case .neutral:
            registrationView.setStatusText("")
            registrationView.setStatusColor(UIColor.clear)
        case .succes:
            navigationController?.popViewController(animated: true)
            updateLoginState()
        case .emptyLoginError:
            registrationView.setStatusText("Error: Empty Login")
            registrationView.setStatusColor(UIColor.red)
        case .emptyPasswordError:
            registrationView.setStatusText("Error: Empty Password")
            registrationView.setStatusColor(UIColor.red)
        case .passwordMismatchError:
            registrationView.setStatusText("Error: Passwords Mismatch")
            registrationView.setStatusColor(UIColor.red)
        case .loginAlreadyExistError:
            registrationView.setStatusText("Error: Login Already Exists")
            registrationView.setStatusColor(UIColor.red)
        }
    }
}
