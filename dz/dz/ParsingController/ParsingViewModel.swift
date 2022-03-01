import CoreData
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
    private var coreDataServise: CoreDataInstruments = ServiceLocator.shared.getService()
    private var parseDataClosure: () -> ()
    private var dispatchTimerSource: DispatchSourceTimer?
    
    lazy var persistenceContainer: NSPersistentContainer? = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return delegate.persistentContainer
    }()
    
    init(parseDataClosure: @escaping () -> () ) {
        self.parseDataClosure = parseDataClosure
        autocallToURLEvery15Min()
    }
    
    func saveDataToDataBase(text: String, index: Int) {
        coreDataServise.saveToDataBase(text: text, index: index)
    }
    
    func fetchDataFromDataBase() -> [String] {
        var returnArray: [String] = []
        coreDataServise.fetchFromDataBase { testModel in
            for object in testModel {
                let string = "\(object.text ?? "") \(Int(object.index))"
                returnArray += [string]
            }
        }
        return returnArray
    }
    
    func deleteDataFromDataBase(_where text: String) {
        coreDataServise.deleteFromDataBase(_where: text)
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
                if secondsCounter >= 900 {
                    print("autocall executing")
                    self?.parseDataClosure()
                    secondsCounter = 0
                }
                secondsCounter += 1
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
