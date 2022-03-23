import Foundation
import UIKit

class PictureViewerViewModel {
    
    private let parsingService = ParsingService()
    private let dateFormatter = DateFormatter()
    private var imageCacheUrl: URL
    private let fileManager = FileManager.default
    private var model = PictureViewerModel()
    private let syncQueue = DispatchQueue(label: "imageSyncQueue", attributes: .concurrent)
    private let downloadingQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        queue.qualityOfService = .userInitiated
        return queue
    }()
    private var downloadingOperations = [Int: Operation]()
    
    var images: [Int: UIImage] { model.images }
    
    init() {
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        imageCacheUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            .first ?? URL(fileURLWithPath: "")
            .appendingPathComponent("images")
    }
    
    func getImage(
        fileName: String,
        index: Int,
        completion: @escaping (UIImage?, String) -> ()
    ) -> String {
        let downloadingId = UUID().uuidString
        
        let saveAndFinish: (UIImage?, Bool) -> () = { [weak self] image, toFile in
            self?.saveImage(image: image, name: fileName, index: index, toFile: toFile) {
                self?.decodeImage(image) { decodedImage in
                    DispatchQueue.main.async {
                        completion(decodedImage, downloadingId)
                    }
                }
            }
        }
        
        syncQueue.async(flags: .barrier) { [weak self] in
            self?.getLocalImage(fileName: fileName) { image in
                if let image = image {
                    saveAndFinish(image, false)
                } else {
                    self?.getImageFromNetwork(index: index) { image in
                        saveAndFinish(image, true)
                    }
                }
            }
        }
        
        return downloadingId
    }
    
    private func decodeImage(_ image: UIImage?, completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard
                let image = image,
                let cgImage = image.cgImage
            else {
                return completion(image)
            }
            
            let size = CGSize(width: cgImage.width, height: cgImage.height)
            
            guard let context = CGContext(
                data: nil,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
            ) else {
                return completion(image)
            }
            
            context.draw(cgImage, in: CGRect(origin: .zero, size: size))
            
            guard let decodedImage = context.makeImage() else {
                return completion(image)
            }
            
            let result = UIImage(
                cgImage: decodedImage,
                scale: image.scale,
                orientation: image.imageOrientation
            )
            
            completion(result)
        }
    }
    
    func getImageCreationDate(fileName: String, completion: @escaping (String?) -> ()) {
        syncQueue.async {
            let imagePath = self.imageCacheUrl.appendingPathComponent(fileName).path
            
            guard
                let attributes = try? self.fileManager.attributesOfItem(atPath: imagePath) as [FileAttributeKey: Any],
                let creationDate = attributes[.creationDate] as? Date
            else {
                return DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
            let date = self.dateFormatter.string(from: creationDate)
            
            DispatchQueue.main.async {
                completion(date)
            }
        }
    }
    
    func removeAllImages(completion: @escaping () -> ()) {
        syncQueue.async(flags: .barrier) { [weak self] in
            self?.downloadingQueue.cancelAllOperations()
            self?.downloadingOperations.removeAll()
            self?.model.images.removeAll()
            
            guard
                let basePath = self?.imageCacheUrl.path,
                let dirContents = try? self?.fileManager.contentsOfDirectory(atPath: basePath) else {
                    return completion()
                }
            
            for fileName in dirContents {
                if let fileUrl = self?.imageCacheUrl.appendingPathComponent(fileName) {
                    try? self?.fileManager.removeItem(at: fileUrl)
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func getLocalImage(fileName: String, completion: (UIImage?) -> ()) {
        let imagePath = self.imageCacheUrl.appendingPathComponent(fileName).path
        
        guard
            let data = fileManager.contents(atPath: imagePath),
            let image = UIImage(data: data)
        else { return completion(nil) }

        completion(image)
    }
    
    private func getImageFromNetwork(index: Int, completion: @escaping (UIImage?) -> ()) {
        let operation = ImageDownloadingOperation(completion: completion)
        
        downloadingOperations[index]?.cancel()
        downloadingOperations[index] = operation
        downloadingQueue.addOperation(operation)
    }
    
    private func saveImage(image: UIImage?, name: String, index: Int, toFile: Bool, completion: @escaping () -> ()) {
        guard let image = image else {
            return completion()
        }
            
        syncQueue.async(flags: .barrier) { [weak self] in
            self?.model.images[index] = image
            completion()
        }
        
        if toFile {
            image.saveToDocuments(filename: name, documentsDirectory: imageCacheUrl, completion: completion)
        }
    }
}

private extension UIImage {
    func saveToDocuments(
        filename: String,
        documentsDirectory: URL,
        completion: @escaping () -> ()
    ) {
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        guard let data = self.jpegData(compressionQuality: 1.0) else {
            return completion()
        }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
        
        try? data.write(to: fileURL)
        completion()
    }
}
