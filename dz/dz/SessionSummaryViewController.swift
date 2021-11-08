import UIKit

class SessionSummaryViewController: UIViewController {
    
    let lable = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        lable.textColor = UIColor.black
        lable.numberOfLines = 0
        lable.text = "SessionSummaryViewController"
        lable.sizeToFit()
        lable.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        lable.textAlignment = .center
        view.backgroundColor = .white
        self.view.addSubview(lable)
    }
}
