import UIKit

class PictureViewerCell: UICollectionViewCell {
    
    var imageDownloadingId: String?
    private var imageView = UIImageView()
    private var loader = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(loader)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showLoader() {
        imageView.image = nil
        loader.startAnimating()
        setNeedsLayout()
    }
    
    func setImage(_ image: UIImage?, downloadingId: String) {
        guard downloadingId == imageDownloadingId else { return }
        
        if let image = image {            
            imageView.image = image
            imageView.backgroundColor = .white
        } else {
            imageView.image = nil
            imageView.backgroundColor = .red
        }
        
        loader.stopAnimating()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        loader.sizeToFit()
        loader.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        imageView.frame.size = self.frame.size
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
