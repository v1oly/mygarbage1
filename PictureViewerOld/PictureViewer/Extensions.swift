import Foundation
import UIKit

extension Optional {
    var isExist: Bool {
        if self != nil {
            return true
        } else {
            return false
        }
    }
}

extension String {
    func loadImage(fileManager: FileManager, completion: @escaping (UIImage?) -> ()) {
        guard
            let data = fileManager.contents(atPath: self),
            let image = UIImage(data: data)
        else {
            completion(nil)
            return
        }
        completion(image)
    }
}

extension String {
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_:/")
        return self.filter { okayChars.contains($0) }
    }
}

extension UIImage {
    
    func saveToDocuments(
        filename: String,
        documentsDirectory: URL,
        completion: @escaping () -> ()
    ) {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        if let data = self.jpegData(compressionQuality: 1.0) {
            do {
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    try FileManager.default.removeItem(at: fileURL)
                }
                try data.write(to: fileURL)
                completion()
            } catch {
                print("error saving file to documents:", error)
            }
        }
    }
}
