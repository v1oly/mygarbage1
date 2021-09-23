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
    var buttonShape: [Int: String] = [:]
    
    
    
    init() {
      createArrayOfCards()
        
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
