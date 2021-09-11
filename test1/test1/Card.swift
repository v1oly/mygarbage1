import Foundation

struct Card {
    
    static var identifierFactory = 0
    
    var isFacedUp = false
    var isMatched = false
    var isOpenedOnce = false
    var identifier: Int
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
