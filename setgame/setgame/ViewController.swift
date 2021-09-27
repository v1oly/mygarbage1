//
//  ViewController.swift
//  setgame
//
//  Created by Марк Некрашевич on 18.09.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
lazy var game = SetGame()
var countOfAvaibleCards = 12

    
    
    @IBAction func buttonCard(_ sender: UIButton) {
        let cardNumber = arrayOfButtons.firstIndex(of: sender) ?? -1
        game.choosing3Cards(for: cardNumber)
        game.compareCards()
        updateViewFromModel()
    }
    
    @IBAction func buttonOfAddCards(_ sender: UIButton) {
        add3MoreCards()
    }
    
    @IBOutlet var arrayOfButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSettings()
    }

 
    
    
    
    
    func updateViewFromModel() {
        for index in arrayOfButtons.indices {
            let card = game.cards[index]
            let button = arrayOfButtons[index]
            if !game.cards[index].isEnabled {
                button.setTitle("", for: .normal)
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
            if game.cards[index].isEnabled {
                drawShape(index: index, buttons: arrayOfButtons)
            }
                if card.isEnabled && card.isChosen {
                    button.backgroundColor =  #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                } else {
                    button.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
            }
        }
    
    
    func startSettings() {
        for index in 12...23 {
            arrayOfButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            game.cards[index].isEnabled = false
        }
        for index in 0...11 {
            drawShape(index: index, buttons: arrayOfButtons)
        }
        
    }
    
    func add3MoreCards() {
        if countOfAvaibleCards != 24 {
            for index in countOfAvaibleCards...countOfAvaibleCards + 2 {
                arrayOfButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                game.cards[index].isEnabled = true
            }
            countOfAvaibleCards += 3
        }
    }
    
    
    
    func drawShape (index: Int, buttons: [UIButton]) {
    
        var shape = self.chooseShape(for: game.cards[index])
        let color = self.chooseColor(for: game.cards[index])
        let hatching = self.chooseHatching(for: game.cards[index])
        let count = self.chooseCount(for: game.cards[index] )
        if count == 2 { shape = shape + shape }
        if count == 3 { shape = shape + shape + shape }
        
        let string = NSAttributedString (
        string: shape,
            attributes:  [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.backgroundColor: hatching
            ]
        )
        buttons[index].setAttributedTitle(string, for: .normal)
        
    }
    
    
    
    func chooseShape (for card: Card) -> String {
        switch card.shape {
        case .triangle:
            return "▲"
        case .square:
            return "■"
        case .circle:
            return "●"
        }
    }
    
    func chooseColor (for card: Card) -> UIColor {
        switch card.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    func chooseHatching (for card: Card) -> UIColor {
        switch card.hatching {
        case .full:
            return .orange
        case .half:
            return .yellow
        case .none:
            return .white
        }
    }
    func chooseCount (for card: Card) -> Int {
        switch card.count {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
    }
    }
    
}

