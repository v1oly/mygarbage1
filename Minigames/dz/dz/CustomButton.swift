import Foundation
import UIKit

@IBDesignable
final class CustomButton: UIButton {
    
    var borderWidth: CGFloat = 2.0
    var borderColor = UIColor.white.cgColor
    @IBInspectable var buttonFont: Int = 40 {
        didSet {
            self.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(buttonFont))
        }
    }
    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(UIColor.black, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2.0
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
    }
}
