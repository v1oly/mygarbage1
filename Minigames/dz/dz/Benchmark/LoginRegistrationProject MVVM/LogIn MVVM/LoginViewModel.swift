import Foundation
import UIKit

class LoginViewModel {
    
    private var accountsListService: AccountsListService = ServiceLocator.shared.getService()
    private var model = LoginModel() {
        didSet {
            onModelUpdate(model)
        }
    }
    
    private var onModelUpdate: (LoginModel) -> ()
    
    init(onModelUpdate: @escaping (LoginModel) -> ()) {
        self.onModelUpdate = onModelUpdate
        model.usersAccountList = accountsListService.getAccountsList()
    }
    
    func updateAccountList() {
        model.usersAccountList = accountsListService.getAccountsList()
    }
    
    func setNewAccount(login: String, password: String) {
        accountsListService.addToAccountsList(login: login, password: password)
        model.usersAccountList = accountsListService.getAccountsList()
    }
    
    func deleteAccount(login: String) {
        accountsListService.deleteFromAccountsList(login: login)
        model.usersAccountList = accountsListService.getAccountsList()
    }
    
    func checkLoginDataToMatchInBase(login: String, password: String) {
        let usersList = model.usersAccountList
        let accountToCheck = UserAccount(login: login, password: password)
        var isMatched = false
        
        for account in usersList {
            if accountToCheck == account {
                model.currentStatusCondition = .succesLogin
                isMatched = true
            }
        }
        if isMatched == false {
            model.currentStatusCondition = .failureLogin
        }
    }
}
