import Foundation

class RegistrationViewModel {
    
    var accountsListService: AccountsListService = ServiceLocator.shared.getService()
    var model = RegistrationModel() {
        didSet {
            onModelChange(model)
        }
    }
    var onModelChange: (RegistrationModel) -> ()
    
    init(onModelChange: @escaping (RegistrationModel) -> ()) {
        self.onModelChange = onModelChange
        model.usersAccountList = accountsListService.getAccountsList()
    }
    
    fileprivate func setNewAccount(login: String, password: String) {
        accountsListService.addToAccountsList(login: login, password: password)
        model.usersAccountList = accountsListService.getAccountsList()
        model.currentStatusCondition = .succes
    }
    
    func checkIsRegistrationDataHaveMistakesAndSetNewAccountIfHavent(
        login: String,
        password: String,
        confirmPassword: String
    ) {
        
        guard (model.usersAccountList.contains(where: { $0.login == login }) == false) else {
            model.currentStatusCondition = .loginAlreadyExistError
            return
        }
        
        guard login.isEmpty == false else {
            model.currentStatusCondition = .emptyLoginError
            return
        }
        
        guard password.isEmpty == false else {
            model.currentStatusCondition = .emptyPasswordError
            return
        }
        
        guard password == confirmPassword else {
            model.currentStatusCondition = .passwordMismatchError
            return
        }
        setNewAccount(login: login, password: password)
    }
}
