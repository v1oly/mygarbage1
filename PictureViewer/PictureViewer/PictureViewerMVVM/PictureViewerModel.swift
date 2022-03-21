import UIKit

struct PictureViewerModel {
    var imageDict: [Int: UIImage] = [:]
}

struct CatPictureUrl: Codable, CustomStringConvertible {
    var description: String {
        return "\(url)"
    }
    let url: String
}

enum Directory {
    case documents
    case caches
}
