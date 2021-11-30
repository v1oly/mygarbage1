import UIKit

class ViewController: UIViewController {
    
    var coin: Bool? = nil
    var counter: Int = 0
    var countArray = [Int]()
    var coinButton = UIButton()
    var scoreLabel = UILabel()
    var recordLabel = UILabel()
    let headImage = UIImage(named: "head") as UIImage?
    let tailsImage = UIImage(named: "tails") as UIImage?
    
    override func viewDidLoad() {
        coinButton.frame.size = CGSize(width: 175, height: 200)
        coinButton.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        coinButton.addTarget(self, action: #selector(coinPlay(_:)), for: .touchUpInside)
        coinButton.setBackgroundImage(headImage, for: .normal)
        view.addSubview(coinButton)
        
        scoreLabel.frame.size = CGSize(width: 50, height: 25)
        scoreLabel.center = CGPoint(x: coinButton.frame.origin.x + coinButton.frame.width/2,
                                    y: coinButton.frame.origin.y)
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)
        
        recordLabel.frame.size = CGSize(width: 75, height: 25)
        recordLabel.center = CGPoint(x: coinButton.frame.origin.x - recordLabel.frame.width,
                                     y: coinButton.frame.origin.y + coinButton.frame.height/2)
        recordLabel.textAlignment = .center
        recordLabel.text = "record: 0"
        view.addSubview(recordLabel)
    }

    @objc
    func coinPlay(_ sender: UIButton) {
        let random = Int.random(in: 1...2)
        switch random {
        case 1:
            if coin == true {
                counter += 1
                scoreLabel.text = "X\(counter)"
            } else {
                countArray.append(counter)
                counter = 0
                scoreLabel.text = ""
            }
            coin = true; coinButton.setBackgroundImage(headImage, for: .normal)
            
        case 2:
            if coin == false {
                counter += 1
                scoreLabel.text = "X\(counter)"
            } else {
                countArray.append(counter)
                counter = 0
                scoreLabel.text = ""
            }
            coin = false; coinButton.setBackgroundImage(tailsImage, for: .normal)
            
        default:
            break
        }
        let maxScore = countArray.sorted(by: >).first
        recordLabel.text = "record: \(maxScore ?? 0)"
        recordLabel.sizeToFit()
        countArray.removeAll()
        countArray.append(maxScore!)
        print(countArray)
    }
    
//    func autoPlayTest() {
//        for _ in 1...10_000 {
//            self.coinPlay(coinButton)
//        }
//    }
//
    
}

    


