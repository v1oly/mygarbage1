import Foundation
import UIKit

class LoginViewModel {
    private let loginModel = LoginModel()
    private(set) var statusText = Dynamic("")
    private(set) var statusColor = Dynamic(UIColor.clear)
    
    func checkUserLogInToMatchInBase(login: String, password: String) {
        var isMatchFound = false
        let userList = loginModel.accountList
        let compareLogInData = UserAccount(login: login, password: password)
        
        for user in userList {
            if compareLogInData == user {
                statusText.value = "Logged In"
                statusColor.value = UIColor.green
                isMatchFound = true
                break
            }
        }
        
        if isMatchFound == false {
            statusText.value = "Login Failed"
            statusColor.value = UIColor.red
        }
    }
}
