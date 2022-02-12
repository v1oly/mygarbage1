import Foundation

struct ParsingModel {
    
    var urlComponents = URLComponents()
    var url: URL?
    var urlSession = URLSession.shared
    
    init() {
        // url by default
        urlComponents.scheme = "https"
        urlComponents.host = "swapi.dev"
        urlComponents.path = "/api/people/1"
        url = urlComponents.url
    }
}

struct PeopleDescriotion: Codable, CustomStringConvertible {
    var description: String {
        return "\(name) \(mass) \(birth_year)"
    }
    let name: String
    let mass: String
    let birth_year: String // swiftlint:disable:this identifier_name
}
