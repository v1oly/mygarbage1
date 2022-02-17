import Foundation

struct ParsingModel {
    var data: Data?
}

struct PeopleDescription: Codable, CustomStringConvertible {
    var description: String {
        return "\(name) \(mass) \(birth_year)"
    }
    let name: String
    let mass: String
    let birth_year: String // swiftlint:disable:this identifier_name
}

struct ParseConfiguration: Codable {
    let url: String
    let parsedData: String
}
