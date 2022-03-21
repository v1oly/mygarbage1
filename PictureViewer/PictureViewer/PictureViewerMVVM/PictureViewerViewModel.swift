import Foundation
import UIKit

class PictureViewerViewModel {
    
    private let parsingService = ParsingService()
    private let dateFormatter = DateFormatter()
    private let userDefaults = UserDefaults()
    private var urlToDirectory: URL?
    private var model = PictureViewerModel()
    
    var imageDictionary: [Int: UIImage] {
        return model.imageDict
    }
    
    init() {
        setup()
    }
    
    func setupForFileManager(fileName: String,
                             indexPath: IndexPath,
                             completion: @escaping (IndexPath) -> ()) {
        let url = self.urlToDirectory
        if let pathComponent = url?.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                if let data = FileManager.default.contents(atPath: filePath) {
                    if let image = UIImage(data: data) {
                        self.model.imageDict[indexPath.row] = image
                        completion(indexPath)
                        print("FILE AVAILABLE")
                    }
                }
            } else {
                self.downloadCatImageFromAPI(indexPath: indexPath) {
                    completion(indexPath)
                }
                print("FILE NOT AVAILABLE")
            }
        }
    }
    
    func getFileCreatedDate(fileName: String) -> String? {
        let url = self.urlToDirectory
        var creationDateString: String? 
        if let pathComponent = url?.appendingPathComponent(fileName) {
            let filePath = pathComponent.path
            var theCreationDate = Date()
            
            do {
                let aFileAttributes = try FileManager.default.attributesOfItem(atPath: filePath)
                as [FileAttributeKey: Any]
                // swiftlint:disable:next force_cast
                theCreationDate = aFileAttributes[FileAttributeKey.creationDate] as! Date
                print(theCreationDate)
                creationDateString = self.dateFormatter.string(from: theCreationDate)
            } catch let err {
                print(err)
            }
        }
        return creationDateString
    }
    
    func clearDirectory(completion: @escaping () -> ()) {
        var countOfFiles = 0
        let fileManager = FileManager.default
        let url = urlToDirectory
        if let urlPath = url?.path {
            let dirContents = try? fileManager.contentsOfDirectory(atPath: urlPath)
            countOfFiles = dirContents?.count ?? 0
        }
        DispatchQueue.global(qos: .background).async {
            while countOfFiles != 0 {
                for num in 0...999 {
                    if let pathComponent = url?.appendingPathComponent("CatImage \(num)") {
                        let filePath = pathComponent.path
                        if fileManager.fileExists(atPath: filePath) {
                            do {
                                try fileManager.removeItem(at: pathComponent)
                                countOfFiles -= 1
                            } catch let err {
                                print(err)
                            }
                        }
                    }
                }
            }
            self.model.imageDict.removeAll()
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func getURLOfDictionary(for dir: Directory) -> URL? {
        var searchDir: FileManager.SearchPathDirectory
        switch dir {
        case .documents:
            searchDir = .documentDirectory
        case .caches:
            searchDir = .cachesDirectory
        }
        
        guard let url = FileManager.default.urls(for: searchDir, in: .userDomainMask).first else {
            print("Error BAD URL")
            return nil
        }
        return url
    }
        
    private func setup() {
        self.dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        self.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter.timeZone = .current
        
        urlToDirectory = self.getURLOfDictionary(for: .documents)
        print(urlToDirectory!)
    }
    
    func downloadCatImageFromAPI(indexPath: IndexPath, completion: @escaping () -> ()) {
        let randomCatUrlToJSON = "https://api.thecatapi.com/v1/images/search"
        self.parsingService.getDataFromUrl(
            url: randomCatUrlToJSON,
            codableStruct: [CatPictureUrl].self,
            decodeType: [CatPictureUrl].self,
            sendDecodedData: { decocedData in
                let catPictureURL = [decocedData].description.stripped
                self.loadImageFromUrl(url: catPictureURL) { image in
                    self.model.imageDict[indexPath.row] = image
                    completion()
                }
            }
        )
    }
    
    func saveImageToDict(image: UIImage, imageName: String) {
        if let urlToDirectory = urlToDirectory {
            image.saveToDocuments(filename: imageName, documentsDirectory: urlToDirectory) {
            }
        }
    }
    
    private func loadImageFromUrl(url: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global(qos: .utility).async {
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    completion(image)
                }
            }
        }
    }
}

extension String {
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_:/")
        return self.filter { okayChars.contains($0) }
    }
}

extension UIImage {
    
    func saveToDocuments(filename:String,
                         documentsDirectory: URL,
                         completion: @escaping () -> ()) {
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
