import Foundation

struct ParsingModel: ParsingData {
    var data: ParsingDataStructure?
}

struct PeopleDescription: Codable, CustomStringConvertible, ParsingDataStructure {
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

protocol ParsingDataStructure {
    var description: String { get }
}

protocol ParsingData {
    var data: ParsingDataStructure? { get set }
}
