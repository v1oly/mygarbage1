import UIKit

class PictureViewerController: UIViewController {
    
    weak var collectionView: UICollectionView! // swiftlint:disable:this implicitly_unwrapped_optional
    private let refreshControl = UIRefreshControl()
    private var viewModel = PictureViewerViewModel()
    private var rowsCount = 10
    
    override func loadView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView = collectionView
        self.view = collectionView
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "PictureCell",
            for: indexPath
        ) as? PictureViewerCell else {
            return UICollectionViewCell()
        }
        let imageName = "cat_image_\(indexPath.row)"
        
        cell.showLoadingCircle()
        
        cell.cellId = viewModel.getImage(
            fileName: imageName,
            indexPath: indexPath,
            completion: { image, id in
                cell.setImage(image: image, id: id)
            }
        )
        return cell
    }
}

extension PictureViewerController: UICollectionViewDelegate {
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        
        let imageName = "cat_image_\(indexPath.row)"
        
        guard var image = viewModel.images[indexPath.row] else { return }
        print(viewModel.images)
        viewModel.getFileCreatedDate(fileName: imageName) { creationDate in
            let photoVC = PhotoViewController(photoView: PhotoView(image: &image, date: creationDate))
            self.navigationController?.pushViewController(photoVC, animated: true)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        
        guard indexPath.row > rowsCount - 5 else { return }
        
        let previousRowCount = rowsCount
        rowsCount += 10
        
        collectionView.performBatchUpdates {
            let indexes = (previousRowCount - 1...previousRowCount + 8)
                .map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: indexes)
        }
    }
}

extension PictureViewerController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width / 1.1, height: collectionView.bounds.size.height / 4)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 15
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 8, bottom: 8, right: 8)
    }
}
