import Foundation

class ParsingService {
    
    private var urlSession = URLSession.shared
    
    func getDataFromUrl<T, U: Decodable>(
        url: String,
        codableStruct: U.Type,
        toType: T.Type,
        completion: @escaping (T?) -> ()
    ) {
        self.getRawDataFromUrl(url: url) { data in
            guard let data = data else {
                return completion(nil)
            }
            
            self.decodeResponse(
                data: data,
                codableStruct: codableStruct.self,
                completion: completion
            )
        }
    }
    
 
    private func getRawDataFromUrl(url: String, completion: @escaping (Data?) -> ()) {
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

            completion(data)
        }

        task.resume()
    }
    
    private func decodeResponse<T, U: Decodable>(
        data: Data,
        codableStruct: U.Type,
        completion: (T?) -> ()
    ) {
        let decoder = JSONDecoder()
        if let decodedText = try? decoder.decode(codableStruct.self, from: data) {
            return completion(decodedText as? T)
        } else {
            return completion(nil)
        }
    }
}
