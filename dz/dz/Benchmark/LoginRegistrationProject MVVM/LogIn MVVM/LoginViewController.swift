import UIKit

class LoginViewController: UIViewController {
    
    private var loginView: LoginView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var viewModel: LoginViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(onModelUpdate: { [weak self] model in
            self?.setTuringForStatusCondition(model.currentStatusCondition)
        })
    }
    
    override func loadView() {
        loginView = LoginView(onConfirm: { [weak self] login, password in
            self?.viewModel.checkUserLogInToMatchInBase(login: login, password: password)
        }, onOpenRegistrationView: { [weak self] in
            let registrationViewController = RegistrationViewController(updateLoginState: { [weak self] in
                self?.viewModel.updateAccountList()
            })
            self?.navigationController?.pushViewController(registrationViewController, animated: false)
        })
        view = loginView
    }
    
    func setTuringForStatusCondition(_ statusCondition: LogInStatusCondition) {
        switch statusCondition {
        case .neutral:
            loginView.setStatusText("")
            loginView.setStatusColor(UIColor.clear)
        case .failureLogin:
            loginView.setStatusText("Login Failed")
            loginView.setStatusColor(UIColor.red)
        case .succesLogin:
            loginView.setStatusText("Logged In")
            loginView.setStatusColor(UIColor.green)
        }
    }
}
