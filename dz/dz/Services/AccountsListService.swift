import Foundation

class AccountsListService {
    
    private let userDefaults = UserDefaults(suiteName: "group.MN.dz")
    private var userAcccountsArray = [String]()
    
    init() {
        if let userDefaults = userDefaults?.object(forKey: "Accounts") as? [String] {
            userAcccountsArray = userDefaults
        }
    }
    
    func addToAccountsList(login: String, password: String) {
        if let userDefaults = userDefaults?.object(forKey: "Accounts") as? [String] {
            userAcccountsArray = userDefaults
        }
        userAcccountsArray.append(login)
        userAcccountsArray.append(password)
        userDefaults?.set(userAcccountsArray, forKey: "Accounts")
    }
    
    func deleteFromAccountsList(login: String) {
        if var arrayOfAccounts = userDefaults?.object(forKey: "Accounts") as? [String] {
            if arrayOfAccounts.contains(login) {
                if let firstIndexToDelete = arrayOfAccounts.firstIndex(where: { $0 == login }) {
                    arrayOfAccounts.remove(at: firstIndexToDelete + 1) // удаляем сначала пароль из массива потом логин
                    arrayOfAccounts.remove(at: firstIndexToDelete)
                    
                    userDefaults?.set(arrayOfAccounts, forKey: "Accounts")
                }
            }
        }
    }
    
    private func convertToUserAccount(array: [String]) -> [UserAccount] {
        var convertedArray = [UserAccount]()
        if (array.count % 2) == 0 { // перестраховачная проверка на то что массив паролей и логинов кратен 2
            for index in array.indices {
                if (index + 1) % 2 == 0 { // проверка на расположение пароля, который всегда идет на 2ой шаг в массиве типа [логин, пароль, логин, пароль]
                    convertedArray.append(UserAccount(login: array[index - 1], password: array[index]))
                }
            }
        }
        return convertedArray
    }
    
    func getAccountsList() -> [UserAccount] {
        if let accountList = userDefaults?.object(forKey: "Accounts") as? [String] {
            return convertToUserAccount(array: accountList)
        } else {
            return []
        }
    }
}
