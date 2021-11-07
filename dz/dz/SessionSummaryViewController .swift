import UIKit
// fuck this warning

class SessionSummaryViewController: UIViewController {
    
    let lable = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        lable.frame.size = CGSize(width: 300, height: 25)
        lable.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        lable.textColor = UIColor.black
        lable.text = "SessionSummaryViewController"
        lable.textAlignment = .center
        view.backgroundColor = .white
        self.view.addSubview(lable)
    }
}
