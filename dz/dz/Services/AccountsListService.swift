import Foundation

class AccountsListService {
    
    private let userDefaults = UserDefaults()
    private var userAcccountsDict = [String: String]()
    
    init() {
        if let userDefaults = userDefaults.object(forKey: "Accounts") as? [String: String] {
            userAcccountsDict = userDefaults
        }
    }
    
    func addToAccountsList(login: String, password: String) {
        if let userDefaults = userDefaults.object(forKey: "Accounts") as? [String: String] {
            userAcccountsDict = userDefaults
        }
        userAcccountsDict[login] = password
        userDefaults.set(userAcccountsDict, forKey: "Accounts")
    }
    
    func deleteFromAccountsList(login: String) {
        if let arrayOfAccounts = userDefaults.object(forKey: "Accounts") as? [String: String] {
            if (arrayOfAccounts[login]?.isEmpty) != nil {
                userAcccountsDict.removeValue(forKey: login)
                userDefaults.set(userAcccountsDict, forKey: "Accounts")
            }
        }
    }
    
    func getAccountsList() -> [UserAccount] {
        var returnUserAccounts: [UserAccount] = []
        if let accountsList = userDefaults.object(forKey: "Accounts") as? [String: String] {
            accountsList.forEach {
                let newAccount = UserAccount(login: $0.key, password: $0.value)
                returnUserAccounts.append(newAccount)
            }
        }
        return returnUserAccounts
    }
}
