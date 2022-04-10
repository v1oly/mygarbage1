import UIKit

struct PictureViewerModel {
    var images = [Int: UIImage]()
}

struct CatPictureUrl: Codable, CustomStringConvertible {
    var description: String {
        return "\(url)"
    }
    let url: String
}
