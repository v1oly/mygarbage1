import UIKit

class ViewController: UIViewController {
    
    lazy var game = SetGame()
    var myTimer: Timer?
    
    @IBOutlet private var arrayOfButtons: [UIButton]!
    
    @IBOutlet private var scoreLabel: UILabel!
    
    @IBOutlet private var cardsInDeckLabel: UILabel!
    
    @IBOutlet private var addLineButton: UIButton!
    
    @IBOutlet private var hintButton: UIButton!
    
    @IBOutlet private var playerVersusPhoneButton: UIButton!
    
    @IBOutlet private var restartButton: UIButton!
    
    @IBOutlet weak var buttonsCollection: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        updateViewFromModel()
        
        addBorderTo(scoreLabel)
        addBorderTo(cardsInDeckLabel)
        addBorderTo(addLineButton)
        addBorderTo(hintButton)
        addBorderTo(playerVersusPhoneButton)
        addBorderTo(restartButton)
    }
    
    @IBAction private func setPlayerVersusPhoneMode(_ sender: UIButton) {
        self.game.phoneMoveState.toNextState()
        self.updateViewFromModel()
        self.setTimerForPVPhone()
    }
    
    @IBAction private func selectCard(_ sender: UIButton) {
        let cardNumber = sender.tag - 1
        print("button pressed \(cardNumber)")
        game.choose3Cards(for: cardNumber)
        game.compareCards()
        updateViewFromModel()
        
        game.nilMatch()
    }
    
    @IBAction private func showAvailableCards(_ sender: UIButton) {
        game.setMatchedCardsHinted()
        game.score -= 3
        updateViewFromModel()
    }
    
    @IBAction private func add3Cards(_ sender: UIButton) {
        add3MoreCards()
        updateViewFromModel()
    }
    
    @IBAction private func restartGame(_ sender: UIButton) {
        game.cards.forEach { $0.isHinted = false }
        game.cards.forEach { $0.isChosen = false }
        game = SetGame()
        addLineButton.isEnabled = true
        updateViewFromModel()
        setUpButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    return cell
    }
    
    func setUpButtons() {
        for index in 0...11 {
            arrayOfButtons[index].isEnabled = true
        }
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
        playerVersusPhoneButton.isEnabled = !game.phoneMoveState.isEnabled
        
        if game.phoneMoveState.isEnabled {
            playerVersusPhoneButton.setTitle("\(emoji(for: game.phoneMoveState, userWon: game.isUserWon)): \(game.phoneScore) ", for: .normal)
        } else {
            playerVersusPhoneButton.setTitle("PvPhone", for: .normal)
        }
        
        scoreLabel.text = " Scores: \(game.score)"
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
        
        if let isMatch = game.isMatch {
            let matchtColor = isMatch ? #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.arrayOfButtons.forEach { if $0.isEnabled { $0.backgroundColor = matchtColor } }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.arrayOfButtons.forEach { if $0.isEnabled { $0.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) } }
                self.updateViewFromModel()
                self.emptyCardsDisable()
            }
        }
    }
    
    func add3MoreCards() {
        
        game.add3MoreCards()
        
        for index in game.cards.count - 3...game.cards.count {
            let button = arrayOfButtons.first { $0.tag == index }
            button?.isEnabled = true
        }
        
        if game.cards.count == 24 {
            addLineButton.isEnabled = false
        }
    }
    
    func shapeString(for index: Int) -> NSAttributedString {
        
        let card = game.cards[index]
        
        var shape = self.chooseShape(for: card)
        let color = self.chooseColor(for: card)
        let strokeWidth = self.chooseStrokeWidth(for: card)
        let hatching = self.chooseHatching(for: card)
        let count = self.chooseCount(for: card)
        if count == 2 { shape = shape + shape }
        if count == 3 { shape = shape + shape + shape }
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
        let randomTime: Double
        
        if game.phoneMoveState == .done {
            randomTime = 3
        } else {
            randomTime = .random(in: 5...10)
        }
                
        myTimer = Timer.scheduledTimer(withTimeInterval: randomTime, repeats: false) { timer in
            
            if self.game.phoneMoveState == .done {
                self.game.isUserWon = false
            }
            
            guard self.game.phoneMoveState.isEnabled else {
                timer.invalidate()
                return
            }
            
            defer {
                self.game.phoneMoveState.toNextState()
                self.updateViewFromModel()
                self.emptyCardsDisable()
                self.setTimerForPVPhone()
            }
                        
            guard self.game.phoneMoveState == .done else {
                return
            }
            
            guard self.game.randomMatchAvaible() else {
                if !self.game.deck.isEmpty {
                    self.add3MoreCards()
                }
                
                return
            }
            
            self.game.setMatchedCardsChosen()
            self.game.swapSelectedCards()
            self.game.calculateIphoneScoresByTime(for: Int(randomTime))
        }
    }
    
    func emptyCardsDisable() {
        guard game.deck.isEmpty else {
            return
        }
        
        for button in arrayOfButtons {
            if button.backgroundColor == #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) {
                button.isEnabled = false
            }
        }
    }
    
    func chooseShape(for card: Card) -> String {
        switch card.shape {
        case .triangle:
            return "▲"
        case .square:
            return "■"
        case .circle:
            return "●"
        }
    }
    
    func chooseColor(for card: Card) -> UIColor {
        switch card.color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
    
    func chooseStrokeWidth(for card: Card) -> CGFloat {
        switch card.hatching {
        case .full:
            return -10
        case .half:
            return 10
        case .none:
            return -10
        }
    }
    
    func chooseHatching(for card: Card) -> CGFloat {
        switch card.hatching {
        case .full:
            return 1
        case .half:
            return 0.25
        case .none:
            return 0.25
        }
    }
    
    func chooseCount(for card: Card) -> Int {
        switch card.count {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
    
    func emoji(for state: PhoneMoveState, userWon: Bool) -> String {
        switch state {
        case .none:
            return ""
        case .started:
            return "🤔"
        case .ready:
            return "🤩"
        case .done:
            return userWon ? "👍" : "👎"
        }
    }
}
