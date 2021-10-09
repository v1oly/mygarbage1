import UIKit

class ViewController: UIViewController {
    
    lazy var game = SetGame()
    var timer: Timer?
    
    @IBOutlet private var arrayOfButtons: [UIButton]!
    
    @IBOutlet private var scoreLabel: UILabel!
    
    @IBOutlet private var cardsInDeckLabel: UILabel!
    
    @IBOutlet private var addLineOutlet: UIButton!
    
    @IBOutlet private var hintOutlet: UIButton!
    
    @IBOutlet private var playerVersusPhoneOutlet: UIButton!
    
    @IBOutlet private var restartOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        disableButtons()
        updateViewFromModel()
        
        addBorderTo(scoreLabel)
        addBorderTo(cardsInDeckLabel)
        addBorderTo(addLineOutlet)
        addBorderTo(hintOutlet)
        addBorderTo(playerVersusPhoneOutlet)
        addBorderTo(restartOutlet)
    }
    
    @IBAction private func playerVersusPhone(_ sender: UIButton) {
        self.playerVersusPhoneOutlet.isEnabled = false
        self.updateViewFromModel()
        self.setTimerForPVPhone()
    }
    
    @IBAction private func cardClickFunc(_ sender: UIButton) {
        let cardNumber = sender.tag - 1
        print("button pressed \(cardNumber)")
        game.choosing3Cards(for: cardNumber)
        game.compareCards()
        updateViewFromModel()
        if game.isMatch == true && !playerVersusPhoneOutlet.isEnabled {
            timer?.invalidate()
            setTimerForPVPhone()
        }
        game.isMatch = nil
    }
    
    @IBAction private func showAvailableCards(_ sender: UIButton) {
        game.setMatchedCardsHinted()
        updateViewFromModel()
    }
    
    @IBAction private func buttonOfAddCards(_ sender: UIButton) {
        add3MoreCards()
        updateViewFromModel()
    }
    
    @IBAction private func restartGame(_ sender: UIButton) {
        game.cards.forEach { $0.isHinted = false }
        game.cards.forEach { $0.isChosen = false }
        game = SetGame()
        addLineOutlet.isEnabled = true
        playerVersusPhoneOutlet.isEnabled = true
        playerVersusPhoneOutlet.setTitle("PvPhone", for: .normal)
        updateViewFromModel()
        disableButtons()
    }
    
    func disableButtons() {
        for index in 12...23 {
            arrayOfButtons[index].isEnabled = false
        }
    }
    
    func addBorderTo(_ view: UIView) {
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 5
        view.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func updateViewFromModel() {
        if !playerVersusPhoneOutlet.isEnabled {
            self.playerVersusPhoneOutlet.setTitle("🤖: \(game.phoneScores) ", for: .normal)
        }
        scoreLabel.text = " Scores: \(game.scores)"
        cardsInDeckLabel.text = " Deck: \(game.deck.count)"
        for (index, card) in game.cards.enumerated() {
            guard let button = arrayOfButtons.first(where: { $0.tag == index + 1 }) else {
                print("cant find button with tag \(index + 1)")
                return
            }
            
            if card.isEnabled {
                button.setAttributedTitle(shapeString(for: index), for: .normal)
                
                if card.isChosen {
                    button.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
                    button.layer.borderWidth = 8.0
                    button.layer.cornerRadius = 5
                } else {
                    if card.isHinted {
                        button.layer.borderColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                        button.layer.borderWidth = 8.0
                        button.layer.cornerRadius = 5
                    } else {
                        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                        button.layer.borderWidth = 0
                        button.layer.cornerRadius = 5
                    }
                }
            } else {
                button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                button.setAttributedTitle(nil, for: .normal)
            }
        }
        
        for index in stride(from: game.cards.count, to: arrayOfButtons.count, by: 1) {
            guard let button = arrayOfButtons.first(where: { $0.tag == index + 1 }) else {
                print("cant find butBton with tag \(index + 1)")
                return
            }
            
            button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            button.setAttributedTitle(nil, for: .normal)
        }
        
        if game.isMatch == true {
            self.arrayOfButtons.forEach { if $0.isEnabled  { $0.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1) } }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.arrayOfButtons.forEach { if $0.isEnabled  { $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } }
                
            }
        } else {
            if game.isMatch == false {
                self.arrayOfButtons.forEach { if $0.isEnabled  { $0.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) } }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.arrayOfButtons.forEach { if $0.isEnabled  { $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } }
                }
            }
        }
    }
    
    func add3MoreCards() {
       
        game.add3MoreCards()
        print(game.cards.count)
        
        for index in game.cards.count - 3...game.cards.count {
            let button = arrayOfButtons.first { $0.tag == index }
            button?.isEnabled = true
        }
        
        if game.cards.count == 24 {
            addLineOutlet.isEnabled = false
        }
    }
    
    func shapeString(for index: Int) -> NSAttributedString {
        
        let card = game.cards[index]
        
        var strokeWidth = 0
        var shape = self.chooseShape(for: card)
        let color = self.chooseColor(for: card)
        let hatching = self.chooseHatching(for: card)
        let count = self.chooseCount(for: card)
        if count == 2 { shape = shape + shape }
        if count == 3 { shape = shape + shape + shape }
        if hatching == 0.3 { strokeWidth = 12 }
        return NSAttributedString(
            string: shape,
            attributes: [
                NSAttributedString.Key.foregroundColor: color.withAlphaComponent(hatching),
                NSAttributedString.Key.strokeWidth: strokeWidth,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)
            ]
        )
    }
    
    func setTimerForPVPhone() {
    var randomTime = Int.random(in: 10...50)
       timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            if !self.playerVersusPhoneOutlet.isEnabled {
                if self.game.randomMatchAvaible() {
                    print(randomTime)
                    self.game.setMatchedCardsChosen()
                    self.game.swapSelectedCards()
                    self.game.calculateIphoneScoresByTime(for: randomTime)
                    randomTime = Int.random(in: 10...50)
                    self.updateViewFromModel()
                } else {
                    if !self.game.deck.isEmpty {
                        self.add3MoreCards()
                    } else {
                        timer.invalidate()
                    }
                }
            } else {
                timer.invalidate()
            }
        }
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
    
    func chooseHatching (for card: Card) -> CGFloat {
        switch card.hatching {
        case .full:
            return 1
        case .half:
            return 0.3
        case .none:
            return 0.25
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
