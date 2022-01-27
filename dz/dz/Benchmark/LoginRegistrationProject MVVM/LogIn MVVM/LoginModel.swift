import Foundation

struct LoginModel {
    var usersAccountList = [UserAccount]()
    var currentStatusCondition: LogInStatusCondition = .neutral
}

struct UserAccount: Equatable {
    let login: String
    let password: String
}

enum LogInStatusCondition {
    case neutral
    case succesLogin
    case failureLogin
}
