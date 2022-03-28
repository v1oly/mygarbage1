import UIKit

class PictureViewerController: UIViewController {
    
    weak var collectionView: UICollectionView! // swiftlint:disable:this implicitly_unwrapped_optional
    private let refreshControl = UIRefreshControl()
    private let debouncer = Debouncer()
    private var viewModel = PictureViewerViewModel()
    private var rowsCount = 10
    
    lazy var debouncedUpdateNewImages = debouncer.debounce(delay: 5.0, action: self.updateNewImages)
    
    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading data")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        self.collectionView.register(PictureViewerCell.self, forCellWithReuseIdentifier: "PictureCell")
    }
    
    func updateNewImages(string: String) {
        print(string)
        rowsCount += 10
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc
    func refresh(_ sender: AnyObject) {
        print("refreshing")
        viewModel.clearDirectory { [weak self] in
            self?.rowsCount = 10
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension PictureViewerController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowsCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath)
        as! PictureViewerCell // swiftlint:disable:this force_cast
        let imageName = "CatImage \(indexPath.row)"
        
        viewModel.setupForFileManager(fileName: imageName, indexPath: indexPath) { indexPath in
            if let image = self.viewModel.imageDictionary[indexPath.row] {
                cell.setImage(image: image)
                self.viewModel.saveImageToDict(image: image, imageName: imageName)
            }
        }
        return cell
    }
}

extension PictureViewerController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let imageName = "CatImage \(indexPath.row)"
        let fullPhotoView = PhotoView { photoView in
            photoView.removeFromSuperview()
        }
        if let image = viewModel.imageDictionary[indexPath.row] {
            if let date = viewModel.getFileCreatedDate(fileName: imageName) {
                fullPhotoView.setImage(image: image)
                fullPhotoView.setDateDescription(dateText: date, textSize: 20)
            }
            self.view.addSubview(fullPhotoView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        print(indexPath.row + 1)
        if indexPath.row > rowsCount / 2 {
            debouncedUpdateNewImages("debounce!")
        }
    }
}

extension PictureViewerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width / 1.1, height: collectionView.bounds.size.height / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 15, left: 8, bottom: 8, right: 8)
    }
}
