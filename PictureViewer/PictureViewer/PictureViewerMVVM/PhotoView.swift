import Foundation
import UIKit

class PhotoView: UIView {
    var isOpened = false
    private var imageView = UIImageView()
    private var dateLabel = UILabel()
    private var gestureTapRecognizer: UITapGestureRecognizer! // swiftlint:disable:this implicitly_unwrapped_optional
    private let onExit: (UIView) -> ()
    
    init(onExit: @escaping (UIView) -> ()) {
        self.onExit = onExit
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
    
    func setDateDescription(dateText: String, textSize: CGFloat) {
        self.addSubview(dateLabel)
        let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: textSize)]
        let myAttrString = NSAttributedString(string: dateText, attributes: myAttribute)
        dateLabel.attributedText = myAttrString
        dateLabel.backgroundColor = .white
        layoutSubviews()
    }
    
    func setImage(image: UIImage) {
        print("image size - \(image.size)")
        if image.size.height > bounds.height {
            imageView.frame.size.height = bounds.height
        } else {
            imageView.frame.size.height = image.size.height
        }
        
        if image.size.width > bounds.width {
            imageView.frame.size.width = bounds.width
        } else {
            imageView.frame.size.width = image.size.width
        }
        print("image view size - \(imageView.frame.size)")
        print("bounds size - \(bounds.size)")
        
        self.addSubview(imageView)
        imageView.image = image
        layoutSubviews()
    }
    
    private func setup() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        self.isUserInteractionEnabled = true
        gestureTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        gestureTapRecognizer.numberOfTapsRequired = 1
        self.addGestureRecognizer(gestureTapRecognizer)
        
        let colorTop =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.75).cgColor
        let colorBottom =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.75).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        imageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        imageView.contentMode = .scaleAspectFit
        
        dateLabel.textAlignment = .center
        dateLabel.center = CGPoint(x: self.frame.width / 2, y: self.bounds.height - 30)
        dateLabel.sizeToFit()
    }
    
    @objc
    func viewTapped() {
        onExit(self)
        print("cool")
    }
}
