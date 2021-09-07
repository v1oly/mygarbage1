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
    var arrayOfEmojiChoices: [String] = []
    var countOfRngOperations = 0
    var emoji = [Int: String]()
    
    @IBOutlet var emojiArray: [UIButton]!
    
    @IBAction func Restart(_ sender: UIButton) {
        restartGame()
    }
    
    @IBOutlet weak var totalScores: UILabel!
    
    @IBOutlet weak var totalFlips: UILabel!
    
    @IBAction func mainButtonFunc(_ sender: UIButton) {
        let cardNumber = emojiArray.index(of: sender)!
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    func updateViewFromModel (){
        totalScores.text = "Total Scrores: \(game.scores)"
        totalFlips.text = "Flips: \(game.flipCount)"
        for index in emojiArray.indices {
            let button = emojiArray[index]
            let card = game.сards[index]
            if card.isFacedUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    func emoji(for card: Card) -> String {
        randomEmojiPack()
        if emoji[card.identifier] == nil{
            if arrayOfEmojiChoices.count > 0 {
                let randomIndex = Int (arc4random_uniform(UInt32(arrayOfEmojiChoices.count)))
                emoji[card.identifier] = arrayOfEmojiChoices.remove(at: randomIndex)
            }
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func restartGame(){
        countOfRngOperations = 0
        emoji = [:]
        game = concentration(numberOfPairsCards: (emojiArray.count + 1) / 2)
        updateViewFromModel()
    }
    
    func randomEmojiPack() {
        if countOfRngOperations == 0 {
            let randomIndex = Int(arc4random_uniform(6))
            switch randomIndex {
            case 0: arrayOfEmojiChoices = ["🐶","🐱","🐭","🐹","🦊","🐸","🦁"]
            case 1: arrayOfEmojiChoices = ["🍑","🥥","🍉","🍒","🥝","🍅","🍓"]
            case 2: arrayOfEmojiChoices = ["🥐","🍔","🍟","🍕","🥪","🥙","🍱"]
            case 3: arrayOfEmojiChoices = ["⚽️","🏀","🏈","⚾️","🎾","🏐","🎱"]
            case 4: arrayOfEmojiChoices = ["🇺🇸","🇺🇦","🇫🇷","🇷🇺","🇵🇱","🇨🇦","🇧🇾"]
            case 5: arrayOfEmojiChoices = ["😀","😎","😇","🤢","🤓","🤪","😍"]
            default:()
            }
        }
        countOfRngOperations += 1
    }    
}

