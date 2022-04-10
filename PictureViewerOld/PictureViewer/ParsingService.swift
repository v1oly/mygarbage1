import Foundation

class ParsingService {
    
    let urlSession = URLSession.shared
    
    func getDataFromUrl<T, U: Decodable>(
        url: String,
        codableStruct: U.Type,
        decodeType: T.Type,
        sendDecodedData: @escaping (Any) -> ()
    ) {
        self.getRawDataFromUrl(url: url) { data in
            if let data = data {
                if let decodedData = self.decodeJSON(
                    data: data,
                    codableStruct: codableStruct.self,
                    decodeType: decodeType.self
                ) {
                    sendDecodedData(decodedData)
                }
            }
        }
    }
    
//    @available(iOS 15.0.0, *)
//    private func getRawDataFromUrl<T>(url: String) async throws -> T {
//
//        guard let url = URL(string: url) else { throw ParsingError.parseError("Url is not valid") }
//
//        let (data, response) = try await URLSession.shared.data(from: url)
//
//        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
//            throw ParsingError.parseError("Response is not valid")
//        }
//
//        guard let mimeType = response.mimeType, mimeType == "application/json" else {
//            throw ParsingError.parseError("Data in not JSON")
//        }
//        return data as? T ??
//    }
// }
//
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
