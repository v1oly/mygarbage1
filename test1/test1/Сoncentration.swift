import Foundation

class Сoncentration {
    
    var сards = [Card]()
    var scores = 0
    var flipCount = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    var arrayOfEmojiChoices: [String] = []
    var emoji = [Int: String]()
    var cardColor: String = ""
    var timeIntervalBuffer = Date()
    
    init(numberOfPairsCards: Int) {
        selectRandomEmojiPack()
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
    
    func selectRandomEmojiPack() {
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
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                let firstClick = Date()
                timeIntervalBuffer = firstClick
                
                for flipDownIndex in сards.indices {
                    сards[flipDownIndex].isFacedUp = false
                }
                
                сards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
}
