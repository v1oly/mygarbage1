import Foundation

class Card: Equatable {
    
    private static var identifierFactory = -1
    
    var shape: CardShape
    var color: CardColor
    var count: CardCount
    var hatching: CardHatching
    
    var isEnabled = true
    var isHinted = false
    var isChosen = false
    var identifier = Int()
    
    init(
        shape: CardShape,
        color: CardColor,
        count: CardCount,
        hatching: CardHatching
        ) {
        self.shape = shape
        self.color = color
        self.count = count
        self.hatching = hatching
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.shape == rhs.shape &&
            lhs.color == rhs.color &&
            lhs.count == rhs.count &&
            lhs.hatching == rhs.hatching }
}

enum CardShape: CaseIterable {
    case triangle
    case circle
    case square
}
enum CardColor: CaseIterable {
    case red
    case green
    case purple
}
enum CardCount: CaseIterable {
    case one
    case two
    case three
}
enum CardHatching: CaseIterable {
    case none
    case half
    case full
}
