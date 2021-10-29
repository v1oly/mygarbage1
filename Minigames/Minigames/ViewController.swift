import UIKit

class ViewController: UIViewController {
    
    var coin: Coin? = nil
    var mainView: CoinView { return self.view as! CoinView}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = CoinView(frame: UIScreen.main.bounds)
    }
}



class CoinView: UIView {
    
    let coinView: UIView = {
        let cWeight = UIScreen.main.bounds.width
        let cHeight = UIScreen.main.bounds.height
        let view = UIView()
        view.frame.size = CGSize(width: 100,
                                 height: 100)
        view.center = CGPoint(x: cWeight * 0.5,
                              y: cHeight * 0.5)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.red.cgColor
        view.layer.backgroundColor = UIColor.gray.cgColor
        return view
    }()
    
    let scoreLabel: UILabel = {
        let cWeight = UIScreen.main.bounds.width
        let cHeight = UIScreen.main.bounds.height
        let label = UILabel()
        label.frame.size = CGSize(width: 150,
                                  height: 25)
        label.center = CGPoint(x: cWeight * 0.5,
                               y: cHeight * 0.5)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Score: "
        return label
    }()
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.backgroundColor = .white
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupViews() {
        self.addSubview(coinView)
        self.addSubview(scoreLabel)
    }
    
}


    


