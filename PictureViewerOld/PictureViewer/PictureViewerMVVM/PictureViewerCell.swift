import UIKit

class PictureViewerCell: UICollectionViewCell {
    
    private var imageView = UIImageView()
    private var image: UIImage?
    private var loadingCircle = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoadingCircle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLoadingCircle() {
        loadingCircle.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        loadingCircle.startAnimating()
        self.addSubview(loadingCircle)
    }
    
    func setImage(image: UIImage) {
        DispatchQueue.main.async {
            self.addSubview(self.imageView)
            self.imageView.image = image
            self.loadingCircle.stopAnimating()
            self.loadingCircle.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        imageView.frame.size = self.frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
