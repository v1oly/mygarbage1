import Foundation
import UIKit

class ParsingView: UIView {
    
    private let textView = UITextView()
    private let parseButton = UIButton()
    private let urlField = UITextField()
    private let urlFieldLabel = UILabel()
    
    private let parseFromUrl: (_ url: String) -> ()
    
    init (parseFromUrl: @escaping (_ url: String) -> ()) {
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
        
        urlField.frame = CGRect(x: textView.frame.midX, y: textView.frame.midY, width: 400, height: 30)
        urlField.center = CGPoint(x: textView.frame.midX, y: textView.frame.minY - 50)
        
        urlFieldLabel.frame = CGRect(x: textView.frame.midX, y: textView.frame.midY, width: 150, height: 30)
        urlFieldLabel.center = CGPoint(x: urlField.frame.midX, y: urlField.frame.maxY - 40)
        urlFieldLabel.sizeToFit()
    }
    
    private func setup() {
        self.backgroundColor = .white
        
        textView.backgroundColor = .lightGray
        textView.text = "Waiting parse"
        self.addSubview(textView)
        
        parseButton.addTarget(self, action: #selector(getData(_:)), for: .touchUpInside)
        parseButton.setTitle("Parse from Url", for: .normal)
        parseButton.backgroundColor = .lightGray
        self.addSubview(parseButton)
        
        urlField.backgroundColor = .lightGray
        urlField.text = "https://swapi.dev/api/people/1"
        self.addSubview(urlField)
        
        urlFieldLabel.text = "Set url to parse here:"
        self.addSubview(urlFieldLabel)
    }
    
    func setText(_ text: String) {
        DispatchQueue.main.async {
            self.textView.text = text
        }
    }
    
    @objc
    func getData(_ sender: UIButton) {
        if let string = urlField.text {
            parseFromUrl(string)
        }
    }
}
