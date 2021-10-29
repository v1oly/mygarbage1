import Foundation

class Coin {
    var flipside: CoinSides
    
    init(
        flipside: CoinSides
        ) {
        self.flipside = flipside
        }
}

enum CoinSides: CaseIterable {
    case head
    case tails
}

