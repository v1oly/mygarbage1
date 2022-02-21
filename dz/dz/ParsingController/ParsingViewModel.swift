import Foundation
import UIKit

class ParsingViewModel {
    
    private var model = ParsingModel() {
        didSet {
            self.parseDataClosure()
        }
    }
    var modelData: ParsingDataStructure? {
        return model.data
    }
    
    private var parsingService: ParsingService = ServiceLocator.shared.getService()
    private var parseDataClosure: () -> ()
    private var dispatchTimerSource: DispatchSourceTimer?
    
    init(parseDataClosure: @escaping () -> () ) {
        self.parseDataClosure = parseDataClosure
        autocallToURLEvery15Min()
    }
    
    func updateDataFromUrl(url: String) {
        model.data = parsingService.getDataFromUrl(
            url: url,
            codableStruct: PeopleDescription.self,
            decodeType: PeopleDescription.self
        )
    }
    
    func autocallToURLEvery15Min() {
        DispatchQueue.global(qos: .background).async {
            var secondsCounter = 0
            
            self.dispatchTimerSource = DispatchSource.makeTimerSource()
        
            self.dispatchTimerSource?.setEventHandler { [weak self] in
                print(secondsCounter)
                if secondsCounter >= 900 {
                    print("autocall executing")
                    self?.parseDataClosure()
                    secondsCounter = 0
                }
                secondsCounter += 1
                print(secondsCounter)
            }
            self.dispatchTimerSource?.schedule(deadline: .now(), repeating: 1)
            self.dispatchTimerSource?.activate()
        }
    }
    
    deinit {
        guard dispatchTimerSource?.isCancelled == false else { return }
        dispatchTimerSource?.cancel()
        print("deinited")
    }
}
