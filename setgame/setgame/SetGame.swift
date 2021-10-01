import Foundation

class SetGame {
    
    var deck = [Card]()
    var cards = [Card]()
    var totalCards = 81
    var scores = 0
    var funcCounter = 0
    var progressiveMinus = 1
    var firstClickTime = Date()
    
    init() {
        createArrayOfCards()
    }
    
    func choosing3Cards(for index: Int) {
        let card = cards[index]
        
        guard card.isEnabled else {
            return }
        
        if funcCounter != 1 {
            firstClickTime = Date()
            funcCounter += 1
        }
        
        card.isChosen = !card.isChosen
    }
        @discardableResult
        func randomMatchEvaible(silentmode: Bool) -> Bool {
        var attempts = 0
        var randomCards = [Card]()
        var isMatchFound = false
        cards.forEach { $0.isHelped = false }
        cards.forEach { $0.isChosen = false }
        
        while !isMatchFound {
            attempts += 1
            
            guard attempts != 999 else {
                break
            }
            
            randomCards = Array(cards.filter { $0.isEnabled && !$0.isChosen }.shuffled().prefix(3))
            isMatchFound = isMatch(inputCards: randomCards)
        }
        
        guard isMatchFound && randomCards.count == 3 else {
            return false }
            if !silentmode {
                randomCards.forEach { $0.isHelped = true }
            }
      
        return true
    }
    
    func isMatch(inputCards: [Card]) -> Bool {
        let isColorMatch = Set(inputCards.map { $0.color }).count == 3
        let isShapeMatch = Set(inputCards.map { $0.shape }).count == 3
        let isHatchingMatch = Set(inputCards.map { $0.hatching }).count == 3
        let isCountMatch = Set(inputCards.map { $0.count }).count == 3
        
        return [isColorMatch, isShapeMatch, isHatchingMatch, isCountMatch].filter { $0 }.count >= 3
    }
    
    func compareCards () {
        let chosenCards = cards.filter { $0.isChosen }
        
        guard chosenCards.count == 3 else {
            return }
        
        if isMatch(inputCards: chosenCards) {
            swapSelectedCards()
            calculateScoresByTime()
            totalCards -= 3
        } else {
            scores -= progressiveMinus
            progressiveMinus += 1
        }
        cards.forEach { $0.isChosen = false }
    }
    
    func swapSelectedCards() {
        cards
            .enumerated()
            .filter { $0.element.isChosen }
            .map { $0.offset }
            .forEach {
                if let newCard = deck.popLast() {
                    cards[$0] = newCard
                    newCard.isEnabled = true
                    newCard.isChosen = false
                } else {
                    cards.remove(at: $0)
                }
            }
    }
    
    func add3MoreCards() {
        if randomMatchEvaible(silentmode: true) == true {
            scores -= 3
        }
        for _ in 1...3 {
            if cards.count < 24, let newCard = deck.popLast() {
                cards.append(newCard)
                }
            }
    }
    
    func createArrayOfCards() {
        deck = CardShape.allCases.flatMap { shape in
            CardColor.allCases.flatMap { color in
                CardHatching.allCases.flatMap { hatching in
                    CardCount.allCases.map { count in
                        return Card(shape: shape, color: color, count: count, hatching: hatching)
                    }
                }
            } // swiftlint:disable:next multiline_function_chains
        }.shuffled()
        
        for _ in 0...11 {
            if let newCard = deck.popLast() {
                cards.append(newCard)
            }
        }
    }
    
    func calculateScoresByTime() {
        let finaMatchTime = Date().timeIntervalSince(firstClickTime)
        switch finaMatchTime {
        case 0...10:
            scores += 5
        case 10...15:
            scores += 4
        case 15...25:
            scores += 3
        case 25...45:
            scores += 2
        default:
            scores += 1
        }
        funcCounter = 0
    }
}
