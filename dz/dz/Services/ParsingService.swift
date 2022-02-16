import Foundation

class ParsingService {
    
    private var urlSession = URLSession.shared
    
    func getDataFromUrl(url: URL, receiveDataFromTask: @escaping (Data?) -> ()) {
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
