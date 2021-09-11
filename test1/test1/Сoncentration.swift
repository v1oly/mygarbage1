import Foundation

class Сoncentration {
    
    var сards = [Card]()
    var scores = 0
    var flipCount = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    var arrayOfEmojiChoices: [String] = []
    var emoji = [Int: String]()
    var cardColor: String = ""
    var timeInterval = 0.0
    var countOperations = 0
    var buff = 0.0
    
    init(numberOfPairsCards: Int) {
        randomEmojiPack()
        for _ in 0..<numberOfPairsCards {
            let card = Card()
            сards += [card, card]
        }
        for _ in сards.indices {
            let randomIndex1 = Int(arc4random_uniform(UInt32(сards.count)))
            let randomIndex2 = Int(arc4random_uniform(UInt32(сards.count)))
            сards.swapAt(randomIndex1, randomIndex2)
        }
    }
    
    func randomEmojiPack() {
        let randomIndex = Int(arc4random_uniform(6))
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
        default:()
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            if !arrayOfEmojiChoices.isEmpty {
                let randomIndex = Int(arc4random_uniform(UInt32(arrayOfEmojiChoices.count)))
                emoji[card.identifier] = arrayOfEmojiChoices.remove(at: randomIndex)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func chooseCard(at index: Int) {
        dateDiffernce()
        if !сards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if сards[matchIndex].identifier == сards[index].identifier {
                    сards[matchIndex].isMatched = true
                    сards[index].isMatched = true
                    if timeInterval <= 3 {
                        scores += 3
                        countOperations = 0
                    } else {
                        scores += 2
                        countOperations = 0
                    }
                } else {
                    if  сards[matchIndex].isOpenedOnce || сards[index].isOpenedOnce {
                        scores -= 1
                        countOperations = 0
                    }
                }
                сards[matchIndex].isOpenedOnce = true
                сards[index].isOpenedOnce = true
                сards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else { 
                for flipDownIndex in сards.indices {
                    сards[flipDownIndex].isFacedUp = false
                }
                сards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    @discardableResult
    func dateDiffernce() -> Double {
        if countOperations == 0 {
            let firstClick = Date().timeIntervalSinceReferenceDate
            buff = firstClick
        }
        
        if countOperations == 1 {
            let secondClick = Date().timeIntervalSinceReferenceDate
            timeInterval = secondClick - buff
        }
        countOperations += 1
        return(timeInterval)
    }
}
