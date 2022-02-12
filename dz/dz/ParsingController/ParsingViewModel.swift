import Foundation

class ParsingViewModel {
    
    private var model = ParsingModel()
    private var autocallTask: () -> ()
    private var dispatchTimerSource: DispatchSourceTimer?
    
    var url: URL? {
        get { model.url }
        set { model.url = newValue }
    }
    
    init(autoCallsTask: @escaping () -> () ) {
        self.autocallTask = autoCallsTask
        autocallToURLEvery15Min()
    }
    
    func getResources(url: URL, completion: @escaping (Data) -> ()) {
        let request = URLRequest(url: url)
        
        let task = model.urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
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
    
    private func autocallToURLEvery15Min() {
        DispatchQueue.global(qos: .background).async {
            var secondsCounter = 0
            
            self.dispatchTimerSource = DispatchSource.makeTimerSource()
        
            self.dispatchTimerSource?.setEventHandler { [weak self] in
                print(secondsCounter)
                if secondsCounter >= 900 {
                    print("autocall executing")
                    self?.autocallTask()
                    secondsCounter = 0
                }
                secondsCounter += 1
                print(secondsCounter)
            }
            self.dispatchTimerSource?.schedule(deadline: .now(), repeating: 1)
            self.dispatchTimerSource?.activate()
        }
    }
    
    func setNewUrl(url: String) {
        guard url.isValidURL == true else { return }
        let url = URL(string: url)
        model.url = url
    }
    
    func decodeJSON(data: Data) -> CustomStringConvertible? {
        let decoder = JSONDecoder()
        
        if let decodedText = try? decoder.decode(PeopleDescriotion.self, from: data) {
            return decodedText
        } else {
            return nil
        }
    }
    
    deinit {
        guard dispatchTimerSource?.isCancelled == false else { return }
        dispatchTimerSource?.cancel()
        print("deinited")
    }
}
