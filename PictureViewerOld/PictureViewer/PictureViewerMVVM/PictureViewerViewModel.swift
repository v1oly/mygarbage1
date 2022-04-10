import Foundation
import UIKit

class PictureViewerViewModel {
    
    private let parsingService = ParsingService()
    private let imageDownloader = ImageDownloader()
    private var model = PictureViewerModel()
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
    
    var images: [Int: UIImage] { return model.images }
    
    func getImage(
        fileName: String,
        indexPath: IndexPath,
        completion: @escaping (UIImage, String) -> ()
    ) -> String? {
        
        let identifier = UUID().uuidString
        
        let filePath = url.appendingPathComponent(fileName).path
        
        if self.fileManager.fileExists(atPath: filePath) == true {
            fileManagmentQueue.async { [weak self] in
                filePath.loadImage(fileManager: FileManager.default, completion: { image in
                    if let image = image {
                        DispatchQueue.main.async {
                            self?.model.images[indexPath.row] = image // пришлось эту строку добавить сюда тк иначе был краш почему то в потоке файлменедженткью
                            completion(image, identifier)
                        }
                    }
                }
                )
            }
        } else {
            fileManagmentQueue.async(flags: .barrier) { [weak self] in
                self?.imageDownloader.downloadImage { [weak self] image in
                    self?.model.images[indexPath.row] = image
                    self?.saveImageToDict(image: image, imageName: fileName)
                    DispatchQueue.main.async {
                        completion(image, identifier)
                    }
                }
            }
        }
        return identifier
    }
    
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
        fileManagmentQueue.async {
            image.saveToDocuments(filename: imageName, documentsDirectory: self.url) { }
        }
    }
}
