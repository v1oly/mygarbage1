import Foundation
import UIKit

final class ImageDownloadingOperation: Operation {
    private let parsingService = ParsingService()
    private let completion: (UIImage?) -> ()
    private let randomCatUrl = "https://api.thecatapi.com/v1/images/search"
    
    init(completion: @escaping (UIImage?) -> ()) {
        self.completion = completion
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        var result: UIImage?
        
        getImageFromNetwork { image in
            result = image
            semaphore.signal()
        }
        
        semaphore.wait()
        
        guard !isCancelled else { return }
        
        completion(result)
    }
    
    private func getImageFromNetwork(completion: @escaping (UIImage?) -> ()) {
        guard !isCancelled else { return }
        
        parsingService.getDataFromUrl(
            url: randomCatUrl,
            codableStruct: [CatPictureUrl].self,
            toType: [CatPictureUrl].self,
            completion: { [weak self] decocedData in
                guard let decocedData = decocedData else {
                    return completion(nil)
                }
                
                self?.loadImageFromUrl(
                    path: [decocedData].description.stripped,
                    completion: completion
                )
            }
        )
    }
    
    private func loadImageFromUrl(path: String, completion: @escaping (UIImage?) -> ()) {
        guard !isCancelled else { return }
        
        guard
            let url = URL(string: path),
            let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData)
        else { return completion(nil) }
        
        completion(image)
    }
}

private extension String {
    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-=().!_:/")
        return self.filter { okayChars.contains($0) }
    }
}
