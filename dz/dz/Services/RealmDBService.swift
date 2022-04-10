import Foundation
import RealmSwift

class RealmDBService {
    
    func addToRealmDB(name: String, text: String, someInt: Int) {
        guard let realm = try? Realm() else { return }
        try? realm.write {
            let newRecord = TestRealmModel()
            newRecord.name = name
            newRecord.text = text
            newRecord.someInt = someInt
            realm.add(newRecord)
        }
    }
    
    func deleteFromRealmDB(name: String) {
        guard let realm = try? Realm() else { return }
        
        let deleteObject = realm.objects(TestRealmModel.self).where {
            $0.name == name
        }.first
        
        do {
            realm.beginWrite()
            if let deletedObject = deleteObject {
                realm.delete(deletedObject)
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getDataFromRealm() -> String {
        guard let realm = try? Realm() else { return "" }
        
        var returnValue = ""
        let realmModel = realm.objects(TestRealmModel.self)
        
        for object in realmModel {
            returnValue += "\(object.name) \(object.text) \(object.someInt) \n"
        }
        return returnValue
    }
}
