import Foundation
import UIKit

class FileManagmentService {
    
    private var fileManagmentQueue = DispatchQueue(label: "FileManagmentQueue", qos: .utility, attributes: .concurrent)
    private let fileManager = FileManager.default
    private var url: URL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first ?? URL(fileURLWithPath: "")
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    func getFileCreatedDate(fileName: String, completion: @escaping (String) -> ()) {
        fileManagmentQueue.async {
            let pathComponent = self.url.appendingPathComponent(fileName)
            let filePath = pathComponent.path
            
            guard
                let aFileAttributes = try? self.fileManager.attributesOfItem(atPath: filePath)
                    as [FileAttributeKey: Any],
                let theCreationDate = aFileAttributes[FileAttributeKey.creationDate] as? Date
            else { return }
            
            let creationDateString = self.dateFormatter.string(from: theCreationDate)
            DispatchQueue.main.async {
                completion(creationDateString)
            }
        }
    }
    
    func clearDirectory(completion: @escaping () -> ()) {
        fileManagmentQueue.async {
            let urlPath = self.url.path
            
            guard let dirContents = try? self.fileManager.contentsOfDirectory(atPath: urlPath) else {
                return
            }
            
            for dirComponent in dirContents {
                let delUrl = self.url.appendingPathComponent(dirComponent)
                try? self.fileManager.removeItem(at: delUrl)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func saveImageToDict(image: UIImage, imageName: String) {
        image.saveToDocuments(filename: imageName, documentsDirectory: url) { }
    }
}
