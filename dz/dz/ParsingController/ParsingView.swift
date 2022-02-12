import Foundation
import UIKit

class ParsingView: UIView {
    
    private let textView = UITextView()
    private let parseButton = UIButton()
    
    private let parseFromUrl: () -> ()
    
    init (parseFromUrl: @escaping () -> ()) {
        self.parseFromUrl = parseFromUrl
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required coder not founded!")
    }
    
    override func layoutSubviews() {
        textView.frame = CGRect(x: bounds.midX, y: bounds.midY, width: 400, height: 400)
        textView.center = self.center
        
        parseButton.frame = CGRect(x: textView.frame.midX, y: textView.frame.maxY + 50, width: 150, height: 50)
        parseButton.center = CGPoint(x: textView.frame.midX, y: textView.frame.maxY + 50)
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        textView.backgroundColor = .lightGray
        textView.text = "Waiting parse"
        self.addSubview(textView)
        
        parseButton.addTarget(self, action: #selector(parseFromUrl(_:)), for: .touchUpInside)
        parseButton.setTitle("Parse from Url", for: .normal)
        parseButton.backgroundColor = .lightGray
        self.addSubview(parseButton)
    }
    
    func setTextViewText(_ text: String) {
        DispatchQueue.main.async {
            self.textView.text = text
        }
    }
    
    @objc
    func parseFromUrl(_ sender: UIButton) {
        parseFromUrl()
        print("parsing...")
    }
}
