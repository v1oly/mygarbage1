//
//  Card.swift
//  setgame
//
//  Created by Марк Некрашевич on 18.09.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import Foundation

class Card {
    
    private static var identifierFactory = 0
    
    var shape: CardShape?
    var color: CardColor?
    var count: CardCount?
    var hatching: CardHatching?
    
    var isCardAlreadyOpen = false
    var isEnabled = true
    var identifier = Int()
    
    init() {
        self.identifier = Card.getCardIdentifier()
    }
    
    
    private static func getCardIdentifier () -> Int {
        identifierFactory += 1
        return identifierFactory
    }
}

enum CardShape {
    case triangle
    case circle
    case square
}
enum CardColor {
    case red
    case green
    case purple
}
enum CardCount {
    case one
    case two
    case three
}
enum CardHatching{
    case none
    case half
    case full
}

