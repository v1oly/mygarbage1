import Foundation

class ParsingService {
    
    private var urlSession = URLSession.shared
    private var queue = DispatchQueue(label: "ParsingServiceQueue", qos: .background)
    private var semaphore = DispatchSemaphore(value: 0)
    
    func getDataFromUrl<T, U: Decodable>(
        url: String,
        codableStruct: U.Type,
        decodeType: T.Type
    ) -> T? {
        var returnData: T?
        var parsedData: Data?
        
        queue.sync {
            self.getRawDataFromUrl(url: url) { data in
                parsedData = data
                self.semaphore.signal()
            }
        }
        semaphore.wait()
        queue.sync {
            if let data = parsedData {
                returnData = self.decodeJSON(data: data, codableStruct: codableStruct.self, decodeType: decodeType.self)
            }
        }
        return returnData
    }
    
    func getRawDataFromUrl(url: String, receiveDataFromTask: @escaping (Data?) -> ()) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard data != nil else {
                print("No Data")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server Error")
                return
            }
            
            guard let mimeType = response.mimeType, mimeType == "application/json" else {
                print("Wrong mimeType")
                return
            }
            receiveDataFromTask(data)
        }
        task.resume()
    }
    
    func decodeJSON<T, U: Decodable>(data: Data, codableStruct: U.Type, decodeType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let decodedText = try? decoder.decode(codableStruct.self, from: data) {
            return decodedText as? T
        } else {
            return nil
        }
    }    
}
