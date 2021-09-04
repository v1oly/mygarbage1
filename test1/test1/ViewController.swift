//
//  ViewController.swift
//  test1
//
//  Created by Марк Некрашевич on 31.08.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var game = concentration(numberOfPairsCards: (emojiArray.count + 1) / 2)
    var flipCount = 0 {
        didSet {
          totalFlips.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet var emojiArray: [UIButton]!
    
   
    @IBAction func Restart(_ sender: UIButton) {
    }
    
    @IBOutlet weak var totalFlips: UILabel!
    
    @IBAction func mainButtonFunc(_ sender: UIButton) {
        flipCount += 1
        let cardNumber = emojiArray.index(of: sender)!
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
   
    func updateViewFromModel (){
        for index in emojiArray.indices {
            let button = emojiArray[index]
            let card = game.Cards[index]
            if card.isFacedUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    var arrayOfEmojiChoices = ["🤖","😎","🤓","😡","🤯","🤢","💩"]
    
    var emoji = [Int: String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil{
            if arrayOfEmojiChoices.count > 0 {
            let randomIndex = Int (arc4random_uniform(UInt32(arrayOfEmojiChoices.count)))
            emoji[card.identifier] = arrayOfEmojiChoices.remove(at: randomIndex)
            }
        }
        
        
     return emoji[card.identifier] ?? "?"
    }
    
    }

