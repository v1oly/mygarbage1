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
    var сards = [Card]()
    var scores = 0
    var flipCount = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    func chooseCard(at index: Int){
        flipCount += 1
        if !сards[index].isMatched{ //если isMatched false
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if сards[matchIndex].identifier == сards[index].identifier {
                    сards[matchIndex].isMatched = true
                    сards[index].isMatched = true
                    scores += 2
                } else{
                    if  сards[matchIndex].isOpenedOnce ||  сards[index].isOpenedOnce {
                        scores -= 1
                    }
                }
                сards[matchIndex].isOpenedOnce = true
                сards[index].isOpenedOnce = true
                сards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = nil
            } else { // если isMatched true
                for flipDownIndex in сards.indices {
                    сards[flipDownIndex].isFacedUp = false
                }
                сards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    init(numberOfPairsCards: Int){
        for _ in 0..<numberOfPairsCards{
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
