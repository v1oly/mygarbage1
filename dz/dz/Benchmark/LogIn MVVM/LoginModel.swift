import Foundation // swiftlint:disable:this file_name

class AccountsList {
    let list: [UserAccount] = [
        UserAccount(login: "Violy", password: "12345" ),
        UserAccount(login: "WE_STOR", password: "10delivery"),
        UserAccount(login: "Mama", password: "Papa"),
        UserAccount(login: "Admin", password: "Masterkey")
    ]
}

struct UserAccount: Equatable {
    let login: String
    let password: String
}
