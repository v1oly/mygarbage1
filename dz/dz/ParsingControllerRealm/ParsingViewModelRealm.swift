import Foundation
import RealmSwift
import UIKit

class ParsingViewModelRealm {
    
    private var model = ParsingModelRealm() {
        didSet {
            self.parseDataClosure()
        }
    }
    var modelData: ParsingDataStructure? {
        return model.data
    }
    
    private var realmDBService: RealmDBService = ServiceLocator.shared.getService()
    private var parsingService: ParsingService = ServiceLocator.shared.getService()
    private var parseDataClosure: () -> ()
    private var dispatchTimerSource: DispatchSourceTimer?
    
    init(parseDataClosure: @escaping () -> () ) {
        self.parseDataClosure = parseDataClosure
        autocallToURLEvery15Min()
    }
    
    func addToRealmDB(name: String, text: String, someInt: Int) {
        realmDBService.addToRealmDB(name: name, text: text, someInt: someInt)
    }
    
    func deleteFromRealmDB(name: String) {
        realmDBService.deleteFromRealmDB(name: name)
    }
    
    func getDataFromRealm() -> String {
        return realmDBService.getDataFromRealm()
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
