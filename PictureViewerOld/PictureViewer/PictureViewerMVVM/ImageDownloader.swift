import Foundation
import UIKit

class ImageDownloader {
    
    private let parsingService = ParsingService()
    private let catImageUrl = "https://api.thecatapi.com/v1/images/search"
    let queue = DispatchQueue(label: "imageDownloaderQueue", qos: .userInitiated, attributes: .concurrent)
    var downloadWorkItem: DispatchWorkItem?
   
    func downloadImage(completion: @escaping (UIImage) -> ()) {
        downloadWorkItem?.cancel()
        
        downloadWorkItem = DispatchWorkItem { [weak self] in
            self?.parsingService.getDataFromUrl(
                url: self?.catImageUrl ?? "",
                codableStruct: [CatPictureUrl].self,
                decodeType: [CatPictureUrl].self,
                sendDecodedData: { decocedData in
                    let catPictureURL = [decocedData].description.stripped
                    self?.loadImageFromUrl(url: catPictureURL) { image in
                        completion(image)
                    }
                }
            )
        }
        
        if let downloadWorkItem = self.downloadWorkItem {
            queue.async(execute: downloadWorkItem)
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
