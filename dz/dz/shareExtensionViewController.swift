import UIKit

class ShareExtensionViewController: UIViewController {
    let textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .red
    }
    
    func setup() {
        textView.frame.size = CGSize(width: 200, height: 200)
        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        textView.backgroundColor = .gray
        view.addSubview(textView)
    }
}
