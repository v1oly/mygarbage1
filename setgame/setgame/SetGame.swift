//
//  SetGame.swift
//  setgame
//
//  Created by Марк Некрашевич on 18.09.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import Foundation

class SetGame {
    
    var cards = [Card]()

    
    
    
    init() {
      createArrayOfCards()
        
    }
    
    func choosing3Cards(for index: Int) {
        let card = cards[index]
        
        guard card.isEnabled else { return }
        
        card.isChosen = !card.isChosen
    }
        
        
        
    func compareCards () {
        let chosenCards = cards.filter { $0.isChosen }
        
        guard chosenCards.count == 3 else { return }
        
        let isColorMatch = Set(chosenCards.map { $0.color }).count == 3
        let isShapeMatch = Set(chosenCards.map { $0.shape }).count == 3
        let isHatchingMatch = Set(chosenCards.map { $0.hatching }).count == 3
        let isCountMatch = Set(chosenCards.map { $0.count }).count == 3
        
        let matches = [isColorMatch, isShapeMatch, isHatchingMatch, isCountMatch]
        
        let matchesCount = matches.filter { $0 }.count
        
        if matchesCount >= 3 {
            cards.remove(at: chosenCards[0].identifier)
            if chosenCards[0].identifier != cards.last!.identifier {
                for index in stride(from: chosenCards[0].identifier + 1, to: cards.last!.identifier, by: 1) {
                    cards[index].identifier -= 1
                }
            }
            cards.remove(at: chosenCards[1].identifier)
            if chosenCards[1].identifier != cards.last!.identifier {
                for index in stride(from: chosenCards[1].identifier + 1, to: cards.last!.identifier, by: 1) {
                    cards[index].identifier -= 1
                }
            }
            cards.remove(at: chosenCards[2].identifier)
            if chosenCards[2].identifier != cards.last!.identifier {
                for index in stride(from: chosenCards[2].identifier + 1, to: cards.last!.identifier, by: 1) {
                    cards[index].identifier -= 1
                }
            }
            for index in cards.indices {
                cards[index].isChosen = false
            }
            
        } else {
            for index in cards.indices {
                cards[index].isChosen = false
            }
        }
    }
    

    
    
    
    
    func createArrayOfCards() {
        
        cards = CardShape.allCases.flatMap { shape in
            CardColor.allCases.flatMap { color in
                CardHatching.allCases.flatMap { hatching in
                    CardCount.allCases.map { count in
                        return Card (shape: shape, color: color, count: count, hatching: hatching)
                    }
                }
            }
        }.shuffled()
    }
       
    
}
