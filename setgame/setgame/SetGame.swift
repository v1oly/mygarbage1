//
//  SetGame.swift
//  setgame
//
//  Created by Марк Некрашевич on 18.09.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import Foundation
import UIKit


class SetGame {
    
    var cards = [Card]()
    var buttonShape: [Int: String] = [:]
    
    
    
    init() {
      createArrayOfCards()
        
    }
    
    
    
    
    
    
    func createArrayOfCards() {
        var cardIndex = 0
        for _ in 1...81 {
            cards += [Card()]
        }
        for shapeIndex in 1...3 {
            if cardIndex < 81 {
                
                for colorIndex in 1...3 {
                    
                    for hatchingIndex in 1...3 {
                        
                        for countIndex in 1...3 {
                            switch shapeIndex {
                            case 1:   cards[cardIndex].shape = CardShape.triangle
                            case 2:   cards[cardIndex].shape = CardShape.circle
                            case 3:   cards[cardIndex].shape = CardShape.square
                            default: break
                            }
                            
                            switch colorIndex {
                            case 1:   cards[cardIndex].color = CardColor.green
                            case 2:   cards[cardIndex].color = CardColor.purple
                            case 3:   cards[cardIndex].color = CardColor.red
                            default: break
                            }
                            
                            switch hatchingIndex {
                            case 1:   cards[cardIndex].hatching = CardHatching.full
                            case 2:   cards[cardIndex].hatching = CardHatching.half
                            case 3:   cards[cardIndex].hatching = CardHatching.none
                            default: break
                            }
                            
                            switch countIndex {
                            case 1:   cards[cardIndex].count = CardCount.one
                            case 2:   cards[cardIndex].count = CardCount.two
                            case 3:   cards[cardIndex].count = CardCount.three
                            default: break
                            }
                            cardIndex += 1
                        }
                    }
                }
            }
        }
    }
    
    func drawShapes() -> [String] {
        var arrayOfDrawCardShapes:[String] = []
        var symbol: String = ""
        
        for index in cards.indices {
            
            switch cards[index].shape {
            case .triangle?: symbol = "▲"
            case .circle?: symbol = "●"
            case .square?: symbol = "■"
            default: break
            }
            
            switch cards[index].count {
            case .one?: ()
            case .two?: symbol = symbol + symbol
            case .three?: symbol = symbol + symbol + symbol
            default: break
            }
            
            switch cards[index].color {
            case .green?:
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.green ]
                _ = NSAttributedString(string: symbol, attributes: myAttribute)
            case .purple?:
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.purple ]
                _ = NSAttributedString(string: symbol, attributes: myAttribute)
            case .red?:
                let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.red ]
                _ = NSAttributedString(string: symbol, attributes: myAttribute)
            default: break
            }
            
            switch cards[index].hatching {
            case .full?:
                let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.yellow ]
                _ = NSAttributedString(string: symbol, attributes: myAttribute)
            case .half?:
                let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.gray ]
                _ = NSAttributedString(string: symbol, attributes: myAttribute)
            case .none?:
                let myAttribute = [ NSAttributedString.Key.backgroundColor: UIColor.white ]
                _ = NSAttributedString(string: symbol, attributes: myAttribute)
            default: break
            }
        arrayOfDrawCardShapes += [symbol]
    }
    return arrayOfDrawCardShapes
}
    
}
