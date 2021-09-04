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
    
    var indexOfOneAndOnlyFaceUoCard: Int?
    
    func chooseCard(at index: Int){
        if !Cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUoCard, matchIndex != index {
                if Cards[matchIndex].identifier == Cards[index].identifier {
                    Cards[matchIndex].isMatched = true
                    Cards[index].isMatched = true
                }
                Cards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUoCard = nil
            } else {
                for flipDownIndex in Cards.indices {
                    Cards[flipDownIndex].isFacedUp = false
                }
                Cards[index].isFacedUp = true
                indexOfOneAndOnlyFaceUoCard = index
            }
        }
    }
    init(numberOfPairsCards: Int){
        for _ in 0..<numberOfPairsCards{
            let card = Card()
            Cards += [card, card]
            
        }
    }
}
