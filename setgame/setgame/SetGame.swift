import Foundation

class SetGame {
    
    var deck = [Card]()
    var cards = [Card]()
    var score = 0
    var phoneScore = 0
    private (set) var firstClickDate: Bool = true
    private (set) var progressiveMinus = 1
    private (set) var firstClickTime = Date()
    private (set) var randomCards = [Card]()
    private (set) var forthCardBuffer = [Card]() // swiftlint:disable:next discouraged_optional_boolean
    private (set) var isMatch: Bool?
    
    init() {
        createArrayOfCards()
    }
    
    func choose3Cards(for index: Int) {
        let card = cards[index]
        
        guard card.isEnabled else {
            return
        }
        
        if firstClickDate {
            firstClickTime = Date()
            firstClickDate = false
        }
        card.isChosen = !card.isChosen
        forthCardBuffer = [card]
    }
    
    @discardableResult
    func randomMatchAvaible() -> Bool {
        var attempts = 0
        var isMatchFound = false
        
        while !isMatchFound {
            attempts += 1
            
            // Костыль, нужный чтобы цикл вайл в случае не нахождения матча не работал бесконечно
            guard attempts != 999 else {
                break
            }
            
            randomCards = Array(cards.filter { $0.isEnabled && !$0.isChosen }.shuffled().prefix(3))
            isMatchFound = isMatch(inputCards: randomCards)
        }
        
        guard isMatchFound && randomCards.count == 3 else {
            return false
        }
        
        return true
    }
    
    func setMatchedCardsChosen() {
        if randomMatchAvaible() {
            randomCards.forEach { $0.isChosen = true }
        }
    }
    
    func setMatchedCardsHinted() {
        cards.forEach { $0.isHinted = false }
        if randomMatchAvaible() {
            randomCards.forEach { $0.isHinted = true }
        }
    }
    
    func isMatch(inputCards: [Card]) -> Bool {
        let isColorMatch = Set(inputCards.map { $0.color }).count == 3
        let isShapeMatch = Set(inputCards.map { $0.shape }).count == 3
        let isHatchingMatch = Set(inputCards.map { $0.hatching }).count == 3
        let isCountMatch = Set(inputCards.map { $0.count }).count == 3
        
        return [isColorMatch, isShapeMatch, isHatchingMatch, isCountMatch].filter { $0 }.count >= 3
    }
    
    func compareCards() {
        var chosenCardsBuffer = cards.filter { $0.isChosen }
        
        guard chosenCardsBuffer.count == 4 else {
            return
        }
        
        chosenCardsBuffer.removeAll { $0 == forthCardBuffer.first }
        forthCardBuffer.first?.isChosen = false
        
        if isMatch(inputCards: chosenCardsBuffer) {
            swapSelectedCards()
            isMatch = true
            calculateScoresByTime()
        } else {
            score -= progressiveMinus
            progressiveMinus += 1
            isMatch = false
        }
        
        cards.forEach { $0.isChosen = false }
        forthCardBuffer.first?.isChosen = true
    }
    
    func swapSelectedCards() {
        cards
            .enumerated()
            .filter { $0.element.isChosen }
            .map { $0.offset }
            .sorted(by: >)
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
        if randomMatchAvaible() {
            score -= 3
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
            }
        }
            .shuffled()
        
        for _ in 0...11 {
            if let newCard = deck.popLast() {
                cards.append(newCard)
            }
        }
    }
    
    func nilMatch() {
        isMatch = nil
    }
    
    func timerReset(for timer: Timer, reset: (Timer) -> (), funcCall: () -> ()) {
        reset(timer)
        funcCall()
    }
    
    func calculateScoresByTime() {
        let finalMatchTime = Date().timeIntervalSince(firstClickTime)
        if isMatch == true {
            switch finalMatchTime {
            case 0...10:
                score += 5
            case 10...15:
                score += 4
            case 15...25:
                score += 3
            case 25...45:
                score += 2
            default:
                score += 1
            }
            
            firstClickDate = true
        }
    }
    
    func calculateIphoneScoresByTime(for timeInterval: Int) {
        switch timeInterval {
        case 0...10:
            phoneScore += 5
        case 10...15:
            phoneScore += 4
        case 15...25:
            phoneScore += 3
        case 25...45:
            phoneScore += 2
        default:
            phoneScore += 1
        }
    }
}
