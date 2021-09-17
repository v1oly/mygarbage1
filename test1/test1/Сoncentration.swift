import Foundation

class Сoncentration {
    
    private(set) var сards = [Card]()
    private(set) var scores = 0
    private(set) var flipCount = 0
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return сards.indices.filter { сards[$0].isFacedUp }.oneAndOnly
        }
        set {
            for index in сards.indices {
                сards[index].isFacedUp = (index == newValue)
            }
        }
    }
    private(set) var arrayOfEmojiChoices: [String] = []
    private(set) var emoji = [Int: String]()
    private(set) var cardColor: String = ""
    private(set) var timeIntervalBuffer = Date()
    
    init(numberOfPairsCards: Int) {
        selectRandomEmojiPack()
        for _ in 0..<numberOfPairsCards {
            let card = Card()
            сards += [card, card]
        }
        for _ in сards.indices {
            let randomIndex1 = Int.random(in: 0..<сards.count)
            let randomIndex2 = Int.random(in: 0..<сards.count)
            сards.swapAt(randomIndex1, randomIndex2)
        }
    }
    
    func selectRandomEmojiPack() {
        let randomIndex = Int.random(in: 0...6)
        switch randomIndex {
        case 0:
            arrayOfEmojiChoices = ["🐶", "🐱", "🐭", "🐹", "🦊", "🐸", "🦁"]
            cardColor = "Orange"
        case 1:
            arrayOfEmojiChoices = ["🍑", "🥥", "🍉", "🍒", "🥝", "🍅", "🍓"]
            cardColor = "Light Green"
        case 2:
            arrayOfEmojiChoices = ["🥐", "🍔", "🍟", "🍕", "🥪", "🥙", "🍱"]
            cardColor = "Light Red"
        case 3:
            arrayOfEmojiChoices = ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🎱"]
            cardColor = "Yellow"
        case 4:
            arrayOfEmojiChoices = ["🇺🇸", "🇺🇦", "🇫🇷", "🇷🇺", "🇵🇱", "🇨🇦", "🇧🇾"]
            cardColor = "Purple"
        case 5:
            arrayOfEmojiChoices = ["😀", "😎", "😇", "🤢", "🤓", "🤪", "😍"]
            cardColor = "Pink"
        default:
            break
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            if !arrayOfEmojiChoices.isEmpty {
                let randomIndex = Int.random(in: 0..<arrayOfEmojiChoices.count)
                emoji[card.identifier] = arrayOfEmojiChoices.remove(at: randomIndex)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func chooseCard(at index: Int) {
        if !сards[index].isMatched {
            flipCount += 1
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                let secondClick = Date().timeIntervalSince(timeIntervalBuffer)
                
                if сards[matchIndex].identifier == сards[index].identifier {
                    сards[matchIndex].isMatched = true
                    сards[index].isMatched = true
                    
                    if secondClick < 3 {
                        scores += 3
                    } else {
                        scores += 2
                    }
                } else {
                    if  сards[matchIndex].isOpenedOnce || сards[index].isOpenedOnce {
                        scores -= 1
                    }
                }
                
                сards[matchIndex].isOpenedOnce = true
                сards[index].isOpenedOnce = true
                сards[index].isFacedUp = true
            } else {
                let firstClick = Date()
                timeIntervalBuffer = firstClick
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
