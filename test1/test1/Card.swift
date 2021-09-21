import Foundation

struct Card: Hashable {
    
    private static var identifierFactory = 0
    
    var isFacedUp = false
    var isMatched = false
    var isOpenedOnce = false
    private var identifier: Int
     
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}
