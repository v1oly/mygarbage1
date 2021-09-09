//
//  ViewController.swift
//  test1
//
//  Created by Марк Некрашевич on 31.08.2021.
//  Copyright © 2021 Mark Nekrashevich. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    lazy var game = Сoncentration(numberOfPairsCards: (emojiArray.count + 1) / 2)
    var cardColor: UIColor? 
    var backgroundColorGame: UIColor?
    
    @IBOutlet var emojiArray: [UIButton]!
    
    @IBAction func restart(_ sender: UIButton) {
        restartGame()
    }
    @IBOutlet weak var restartLabel: UIButton!
    
    @IBOutlet var backGround: UIView!
    
    @IBOutlet weak var totalScores: UILabel!
    
    @IBOutlet weak var totalFlips: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch game.cardColor {
        case "Orange": cardColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) ; self.backgroundColorGame = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case "Light Green": cardColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) ; self.backgroundColorGame = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        case "Light Red": cardColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) ; self.backgroundColorGame = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case "Yellow": cardColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1) ; self.backgroundColorGame = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        case "Purple": cardColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1) ; self.backgroundColorGame = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case "Pink": cardColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1) ; self.backgroundColorGame = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        default:()
        }
        for index in emojiArray.indices {
            let button = emojiArray[index]
            button.backgroundColor = cardColor
        }
        backGround.backgroundColor = backgroundColorGame
        totalFlips.textColor = cardColor
        totalScores.textColor = cardColor
        restartLabel.setTitleColor(cardColor, for: UIControlState.normal)
    }
    

    
    @IBAction func mainButtonFunc(_ sender: UIButton) {
        let cardNumber = emojiArray.index(of: sender)!
        game.chooseCard(at: cardNumber)
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        totalScores.text = "Total Scrores: \(game.scores)"
        totalFlips.text = "Flips: \(game.flipCount)"
        for index in emojiArray.indices {
            let button = emojiArray[index]
            let card = game.сards[index]
            if card.isFacedUp {
                button.setTitle(game.emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) : cardColor
            }
        }
    }
    
    func restartGame() {
        game = Сoncentration(numberOfPairsCards: (emojiArray.count + 1) / 2)
        updateViewFromModel()
        viewDidLoad()
    }
    
    
}

