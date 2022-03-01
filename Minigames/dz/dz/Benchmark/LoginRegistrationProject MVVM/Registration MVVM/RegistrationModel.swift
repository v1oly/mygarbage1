import Foundation

struct RegistrationModel {
    var usersAccountList = [UserAccount]()
    var currentStatusCondition: RegistrationStatusCondition = .neutral
}

enum RegistrationStatusCondition {
    case neutral
    case succes
    case emptyLoginError
    case emptyPasswordError
    case passwordMismatchError
    case loginAlreadyExistError
}
