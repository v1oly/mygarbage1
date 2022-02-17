import Foundation

class CodableFileStorage {
    
    enum Directory {
        case documents
        case caches
    }
    
    private func getURL(for dir: Directory) -> URL? {
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
    
    func createDocumentDirectory() {
        var documentDir: String! // swiftlint:disable:this implicitly_unwrapped_optional
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        documentDir = dirPaths[0] as String
        print("path : \(String(describing: documentDir))")
    }
    
    func store<T: Encodable>(_ obj: T, to dir: Directory, as filename: String) {
        if let dir = getURL(for: dir) {
            let url = dir.appendingPathComponent(filename)
            do {
                let data = try JSONEncoder().encode(obj)
                if FileManager.default.fileExists(atPath: url.path) {
                    try FileManager.default.removeItem(at: url)
                }
                FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
            } catch let err {
                print(err)
            }
        }
    }
    
    func retrieve<T: Decodable>(_ filename: String, from dir: Directory, as type: T.Type) -> T? {
        if let dir = getURL(for: dir) {
            let url = dir.appendingPathComponent(filename)
            
            guard FileManager.default.fileExists(atPath: url.path) else {
                print("No File")
                return nil
            }
            
            if let data = FileManager.default.contents(atPath: url.path) {
                do {
                    return try JSONDecoder().decode(type, from: data)
                } catch let err {
                    print(err)
                }
            }
        }
        return nil
    }
}
