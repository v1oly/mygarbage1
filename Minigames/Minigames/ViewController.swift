    import UIKit

class ViewController: UIViewController {
    
    var coin: Coin? = nil
    let coinView = CoinView()
    
    override func viewDidLoad() {
    }
    
    override func loadView() {
        view = coinView
        view.backgroundColor = .white
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
            if UIApplication.shared.statusBarOrientation.isLandscape {
                self.coinView.setNeedsLayout()
                self.coinView.scoreLabel.text = "1111"
            } else {
                self.coinView.setNeedsLayout()
                self.coinView.scoreLabel.text = "2222"
            }
        })
        
        
    }
}
    
    class CoinView: UIView {
        
        let cWeight = UIScreen.main.bounds.width
        let cHeight = UIScreen.main.bounds.height
        
        let scoreLabel = UILabel()
        let coinView = UIView()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setUp()
        }
        
        
        
        override func layoutSubviews() {
            super.layoutSubviews()
            

            
        }
        
        func updateView(text: String) {
            scoreLabel.text = text
            setNeedsLayout()
        }
        
        func setUp(){
            coinView.frame.size = CGSize(width: 100,
                                         height: 100)
            coinView.center = CGPoint(x: cWeight * 0.5,
                                      y: cHeight * 0.5)
            coinView.layer.borderWidth = 1.0
            coinView.layer.borderColor = UIColor.red.cgColor
            coinView.layer.backgroundColor = UIColor.gray.cgColor
            addSubview(coinView)
            
            scoreLabel.frame.size = CGSize(width: 150,
                                           height: 25)
            scoreLabel.center = CGPoint(x: coinView.frame.origin.x * 1.7,
                                        y: coinView.frame.origin.y - 20)
            scoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
            scoreLabel.text = "Score: "
            addSubview(scoreLabel)
        }
}







//    var mainView: CoinView { return self.view as! CoinView }
    
//    let coinView: UIView = {
//        let cWeight = UIScreen.main.bounds.width
//        let cHeight = UIScreen.main.bounds.height
//        let view = UIView()
//        view.frame.size = CGSize(width: 100,
//                                 height: 100)
//        view.center = CGPoint(x: cWeight * 0.5,
//                              y: cHeight * 0.5)
//        view.layer.borderWidth = 1.0
//        view.layer.borderColor = UIColor.red.cgColor
//        view.layer.backgroundColor = UIColor.gray.cgColor
//        return view
//    }()
//
//    let scoreLabel: UILabel = {
//        let label = UILabel()
//        label.frame.size = CGSize(width: 150,
//                                  height: 25)
//        label.center = CGPoint(x: coinView.frame.origin.x * 1.6,
//                               y: coinView.frame.origin.y - 20)
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.text = "Score: "
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.addSubview(coinView)
//        self.view.addSubview(scoreLabel)
//    }
//}




//class CoinView: UIView {
//
//    let coinView: UIView = {
//
//        let cWeight = UIScreen.main.bounds.width
//        let cHeight = UIScreen.main.bounds.height
//        let view = UIView()
//        view.frame.size = CGSize(width: 100,
//                                 height: 100)
//        view.center = CGPoint(x: cWeight * 0.5,
//                              y: cHeight * 0.5)
//        view.layer.borderWidth = 1.0
//        view.layer.borderColor = UIColor.red.cgColor
//        view.layer.backgroundColor = UIColor.gray.cgColor
//        return view
//    }()
//
//    let scoreLabel: UILabel = {
//        let cWeight = UIScreen.main.bounds.width
//        let cHeight = UIScreen.main.bounds.height
//        let label = UILabel()
//        label.frame.size = CGSize(width: 150,
//                                  height: 25)
//        scoreLabel.center = CGPoint(x: coinView.frame.origin.x * 1.6,
//                                   y: coinView.frame.origin.y - 20)
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.text = "Score: "
//        return label
//    }()
//
//    override init(frame:CGRect) {
//        super.init(frame:frame)
//        self.backgroundColor = .white
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.setNeedsDisplay()
//    }
//
//    func setupViews() {
//        self.addSubview(coinView)
//        self.addSubview(scoreLabel)
//    }
//
//}


    


