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
        
    }
    
    func startSettings() {
        for index in 12...23 {
            arrayOfButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) 
        }
        for index in 0...11 {
            arrayOfButtons[index].setTitle(game.drawShapes()[index], for: .normal)
        }
    }
    
    func add3MoreCards() {
        if countOfAvaibleCards != 24 {
            for index in countOfAvaibleCards...countOfAvaibleCards + 2 {
                arrayOfButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            countOfAvaibleCards += 3
        }
    }

}

