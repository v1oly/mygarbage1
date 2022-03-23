import UIKit

class PictureViewerController: UIViewController {
    
    weak var collectionView: UICollectionView! // swiftlint:disable:this implicitly_unwrapped_optional
    private let refreshControl = UIRefreshControl()
    private var viewModel = PictureViewerViewModel()
    private var rowsCount = 10
    private let pictureCellId = "PictureCell"
        
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
        refreshControl.addTarget(self, action: #selector(self.onRefresh), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
        self.collectionView.register(PictureViewerCell.self, forCellWithReuseIdentifier: pictureCellId)
    }
    
    @objc
    func onRefresh() {
        viewModel.removeAllImages { [weak self] in
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
            withReuseIdentifier: pictureCellId,
            for: indexPath
        ) as? PictureViewerCell else {
            return UICollectionViewCell()
        }
                
        cell.showLoader()
        
        cell.imageDownloadingId = viewModel.getImage(
            fileName: "cat_image_\(indexPath.row)",
            index: indexPath.row,
            completion: { image, downloadingId in
                cell.setImage(image, downloadingId: downloadingId)
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
        let imageName = "CatImage \(indexPath.row)"
        let fullPhotoView = PhotoView { photoView in
            photoView.removeFromSuperview()
        }
        
        guard let image = viewModel.images[indexPath.row] else { return }

        self.view.addSubview(fullPhotoView)

        viewModel.getImageCreationDate(fileName: imageName) { date in
            fullPhotoView.setImage(image: image)
            fullPhotoView.setDateDescription(dateText: date ?? "", textSize: 20)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard indexPath.row == rowsCount - 5 else { return }
             
        let oldRowsCount = rowsCount
        rowsCount += 10
        
        collectionView.performBatchUpdates {
            let indexes = (oldRowsCount - 1...oldRowsCount + 8)
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
        return CGSize(
            width: ceil(collectionView.bounds.size.width / 1.1),
            height: ceil(collectionView.bounds.size.height / 4)
        )
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
