//
//  ViewController.swift
//  test1
//
//  Created by Марк Некрашевич on 31.08.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var flipCount = 0 {
        didSet {
          totalFlips.text = "Flips: \(flipCount)"
        }
    }
    
    @IBOutlet var emojiArray: [UIButton]!
    
    var arrayOfEmojiChoices = ["🤖","😎","🤖","😎"]
    
    @IBOutlet weak var totalFlips: UILabel!
    
    @IBAction func mainButtonFunc(_ sender: UIButton) {
        flipCount += 1
        let cardNumber = emojiArray.index(of: sender)!
        flipButton(withEmoji: arrayOfEmojiChoices[cardNumber], on: sender)
    }
    
   
    
    func flipButton(withEmoji emoji: String, on button: UIButton){
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
                button.setTitle(emoji, for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
        }
    }
}

