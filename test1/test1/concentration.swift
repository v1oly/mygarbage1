//
//  concentration.swift
//  test1
//
//  Created by Марк Некрашевич on 02.09.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import Foundation

class concentration
{
    var Cards = [Card]()
    
    var scores = 0
    var flipCount = 0
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int){
        if !Cards[index].isMatched{ //если isMatched false
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if Cards[matchIndex].identifier == Cards[index].identifier {
                    Cards[matchIndex].isMatched = true
                    Cards[index].isMatched = true
                    scores += 2
                } else{
                    scores -= 1
                }
                Cards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else { // если isMatched true
                for flipDownIndex in Cards.indices {
                    Cards[flipDownIndex].isFacedUp = false
                }
                Cards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = index
                flipCount += 1
            }
        }
    }
    init(numberOfPairsCards: Int){
        for _ in 0..<numberOfPairsCards{
            let card = Card()
            Cards += [card, card]
        }
        for _ in Cards.indices{
            let randomIndex1 = Int (arc4random_uniform(UInt32(Cards.count)))
            let randomIndex2 = Int (arc4random_uniform(UInt32(Cards.count)))
            Cards.swapAt(randomIndex1, randomIndex2)
        }
    }
}
