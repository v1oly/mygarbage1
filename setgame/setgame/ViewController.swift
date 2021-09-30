import UIKit

class ViewController: UIViewController {
    
    lazy var game = SetGame()
    
    @IBOutlet private var arrayOfButtons: [UIButton]!
    
    @IBOutlet private var scoresLabel: UILabel!
    
    @IBOutlet private var cardsLeftLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        
        /* Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if self.game.randomMatchForDebug() {
                print("match!")
                self.updateViewFromModel()
            } else {
                print("stop timer")
                timer.invalidate()
            }
        } */
    }
    
    @IBAction private func buttonCard(_ sender: UIButton) {
        let cardNumber = arrayOfButtons.firstIndex(of: sender) ?? -1
        game.choosing3Cards(for: cardNumber)
        game.compareCards()
        updateViewFromModel()
    }
    
    @IBAction private func showAvaibleCards(_ sender: UIButton) {
        game.randomMatchEvaible()
        updateViewFromModel()
    }
    
    @IBAction private func buttonOfAddCards(_ sender: UIButton) {
        add3MoreCards()
        updateViewFromModel()
    }
    
    @IBAction private func restartGameButton(_ sender: UIButton) {
        game = SetGame()
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        scoresLabel.text = "Scores: \(game.scores)"
        cardsLeftLabel.text = "Cards left: \(game.totalCards)"
        for (index, card) in game.cards.enumerated() {
            let button = arrayOfButtons[index]
            
            if card.isEnabled {
                button.setAttributedTitle(shapeString(for: index), for: .normal)
                
                if card.isChosen {
                    button.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                } else {
                if card.isHelped {
                    button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                } else {
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                }
            } else {
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                button.setAttributedTitle(nil, for: .normal)
            }
        }

        for index in stride(from: game.cards.count, to: arrayOfButtons.count, by: 1) {
            arrayOfButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            arrayOfButtons[index].setAttributedTitle(nil, for: .normal)
        }
    }
    
    func add3MoreCards() {
        game.add3MoreCards()
    }
    
    func shapeString(for index: Int) -> NSAttributedString {
        
        let card = game.cards[index]
        
        var shape = self.chooseShape(for: card)
        let color = self.chooseColor(for: card)
        let hatching = self.chooseHatching(for: card)
        let count = self.chooseCount(for: card)
        if count == 2 { shape = shape + shape }
        if count == 3 { shape = shape + shape + shape }
        return NSAttributedString(
            string: shape,
            attributes: [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.backgroundColor: hatching
            ]
        )
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
