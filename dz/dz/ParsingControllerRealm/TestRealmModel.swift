import Foundation
import RealmSwift

class TestRealmModel: Object {
    @Persisted var name: String
    @Persisted var text: String
    @Persisted var someInt: Int
    
    required convenience init(name: String, text: String, someInt: Int) {
        self.init()
        self.name = name
        self.text = text
        self.someInt = someInt
    }
}
