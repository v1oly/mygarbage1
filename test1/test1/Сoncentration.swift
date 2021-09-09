//
//  concentration.swift
//  test1
//
//  Created by Марк Некрашевич on 02.09.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

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
    var count = 0
    var buff = 0.0
    
    
    func randomEmojiPack() {
        let randomIndex = Int(arc4random_uniform(6))
        switch randomIndex {
        case 0: arrayOfEmojiChoices = ["🐶","🐱","🐭","🐹","🦊","🐸","🦁"]
        cardColor = "Orange"
        case 1: arrayOfEmojiChoices = ["🍑","🥥","🍉","🍒","🥝","🍅","🍓"]
        cardColor = "Light Green"
        case 2: arrayOfEmojiChoices = ["🥐","🍔","🍟","🍕","🥪","🥙","🍱"]
        cardColor = "Light Red"
        case 3: arrayOfEmojiChoices = ["⚽️","🏀","🏈","⚾️","🎾","🏐","🎱"]
        cardColor = "Yellow"
        case 4: arrayOfEmojiChoices = ["🇺🇸","🇺🇦","🇫🇷","🇷🇺","🇵🇱","🇨🇦","🇧🇾"]
        cardColor = "Purple"
        case 5: arrayOfEmojiChoices = ["😀","😎","😇","🤢","🤓","🤪","😍"]
        cardColor = "Pink"
        default:()
        }
    }
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil {
            if arrayOfEmojiChoices.count > 0 {
                let randomIndex = Int (arc4random_uniform(UInt32(arrayOfEmojiChoices.count)))
                emoji[card.identifier] = arrayOfEmojiChoices.remove(at: randomIndex)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func chooseCard(at index: Int) {
        flipCount += 1
        dateDiffernce()
        if !сards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if сards[matchIndex].identifier == сards[index].identifier {
                    сards[matchIndex].isMatched = true
                    сards[index].isMatched = true
                    if timeInterval <= 3 {
                        scores += 3
                        count = 0
                    } else {
                        scores += 2
                        count = 0
                    }
                } else {
                    
                    if  сards[matchIndex].isOpenedOnce || сards[index].isOpenedOnce {
                        scores -= 1
                        count = 0
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
    
    func dateDiffernce() {
        if count == 0 {
            let firstClick = Date().timeIntervalSinceReferenceDate
            buff = firstClick
        }
        if count == 1 {
            let secondClick = Date().timeIntervalSinceReferenceDate
            timeInterval = secondClick - buff
        }
        count += 1
    }
    
    
    
    init(numberOfPairsCards: Int) {
        randomEmojiPack()
        for _ in 0..<numberOfPairsCards {
            let card = Card()
            сards += [card, card]
        }
        for _ in сards.indices{
            let randomIndex1 = Int (arc4random_uniform(UInt32(сards.count)))
            let randomIndex2 = Int (arc4random_uniform(UInt32(сards.count)))
            сards.swapAt(randomIndex1, randomIndex2)
        }
    }
}
