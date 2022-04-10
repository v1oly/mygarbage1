import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    var photoView: PhotoView
    var scrollView = UIScrollView()
     
    init(photoView: PhotoView) {
        self.photoView = photoView
        super.init(nibName: nil, bundle: nil)
        scrollViewSetup()
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewSetup() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        photoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(photoView)
        
        NSLayoutConstraint.activate([
        scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
        photoView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
        photoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        photoView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        photoView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoView
    }
}
