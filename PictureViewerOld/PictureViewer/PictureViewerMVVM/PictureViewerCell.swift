import UIKit

class PictureViewerCell: UICollectionViewCell {
    
    var cellId: String?
    private var imageView = UIImageView()
    private var loadingCircle = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(loadingCircle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoadingCircle() {
        imageView.image = nil
        loadingCircle.startAnimating()
        setNeedsLayout()
    }
    
    func setImage(image: UIImage?, id: String) {
        guard id == cellId else { return }
        
        imageView.image = image.isExist ? image : nil
        
        self.loadingCircle.stopAnimating()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        loadingCircle.sizeToFit()
        loadingCircle.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        imageView.frame.size = self.frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
