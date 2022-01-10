import Foundation
import UIKit

class LoginVM {
    let userAccounts = AccountsList()
    var statusText = Dynamic("")
    var statusColor = Dynamic(UIColor.clear)
    
    func checkUserLogInToMatchInBase(login: String, password: String) {
        var isMatchFound = false
        let userList = userAccounts.list
        let compareLogInData = UserAccount(login: login, password: password)
        for index in userList.indices {
            if compareLogInData == userList[index] {
                statusText.value = "Logged In"
                statusColor.value = UIColor.green
                isMatchFound = true
                print("true")
            }
        }
        if isMatchFound == false {
            statusText.value = "Login Failed"
            statusColor.value = UIColor.red
            print("false")
        }
    }
}
