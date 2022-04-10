import Foundation
import UIKit

class PhotoView: UIView {
    
    let imageView = UIImageView()
    let dateOfCreationLabel = UILabel()
    
    init(image: inout UIImage, date: String) {
        super.init(frame: CGRect.zero)
        setImage(image: &image)
        setDateOfCreationText(date: date)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDateOfCreationText(date: String) {
        self.addSubview(dateOfCreationLabel)
        let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let myAttrString = NSAttributedString(string: date, attributes: myAttribute)
        dateOfCreationLabel.attributedText = myAttrString
        dateOfCreationLabel.backgroundColor = .white
        layoutSubviews()
    }
    
    func setImage(image: inout UIImage) {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor)
        ])
        
        if image.size.width > UIScreen.main.bounds.width && image.size.height < UIScreen.main.bounds.height {
            image = image.scalePreservingAspectRatio(
                targetSize: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: image.size.height
                )
            )
        } else if image.size.height > UIScreen.main.bounds.height && image.size.width < UIScreen.main.bounds.width {
            image = image.scalePreservingAspectRatio(
                targetSize: CGSize(
                    width: image.size.width,
                    height: UIScreen.main.bounds.height
                )
            )
        } else if image.size.height > UIScreen.main.bounds.height && image.size.width > UIScreen.main.bounds.width {
            image = image.scalePreservingAspectRatio(
                targetSize: CGSize(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
            )
        }
        
        imageView.image = image
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        imageView.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        imageView.contentMode = .scaleAspectFit
        
        dateOfCreationLabel.textAlignment = .center
        dateOfCreationLabel.center = CGPoint(x: self.frame.width / 2, y: self.bounds.height - 30)
        dateOfCreationLabel.sizeToFit()
    }
}

private extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}
