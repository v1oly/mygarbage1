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
    var dinamicalSwapValue = 0
    var countOfDeleting = 0
    var arrayOfPressedButtonsIndexes: [Int] = []


    
    
    
    init() {
      createArrayOfCards()
        
    }
    
    func choosing3Cards(for index: Int) {
        let card = cards[index]
        
        guard card.isEnabled else { return }
        
        card.isChosen = !card.isChosen
        
        if  card.isChosen{
        arrayOfPressedButtonsIndexes += [index]
        }
        if !card.isChosen {
            arrayOfPressedButtonsIndexes.removeLast()
        }
        
      
    }
        
        
        
    func compareCards () {
        let chosenCards = cards.filter { $0.isChosen }
        
        guard chosenCards.count == 3 else { return }
        
        let array = arrayOfPressedButtonsIndexes
        arrayOfPressedButtonsIndexes = []
        
        let isColorMatch = Set(chosenCards.map { $0.color }).count == 3
        let isShapeMatch = Set(chosenCards.map { $0.shape }).count == 3
        let isHatchingMatch = Set(chosenCards.map { $0.hatching }).count == 3
        let isCountMatch = Set(chosenCards.map { $0.count }).count == 3
        
        let matches = [isColorMatch, isShapeMatch, isHatchingMatch, isCountMatch]
        
        let matchesCount = matches.filter { $0 }.count
        
        if matchesCount >= 3 {
            deletedCardsSwapping(for: array)
        }
        for index in cards.indices {
            cards[index].isChosen = false
        }
        
    }
    

    func deletedCardsSwapping (for array: [Int]) {
        for index in 0...2 {
            if dinamicalSwapValue > 57 {
                cards[80 - dinamicalSwapValue].isEnabled = true
                cards[array[index]].isEnabled = false
                cards.swapAt(array[index], 80 - dinamicalSwapValue)
                dinamicalSwapValue += 1
            } else {
                if countOfDeleting != 1 {
                    countOfDeleting += 1
                    cards.removeSubrange(24...80)
                } else {
                    cards[array[index]].isEnabled = false
                }
                
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
