import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let array: Array = { () -> [Any] in
        var arr = [Int]()
        for index in 1...20 {
            arr += [index]
        }
        return arr
    }()
    
    let cellLabel: UILabel = {
        let cellLbl = UILabel()
        cellLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 25)
        cellLbl.textAlignment = .center
        cellLbl.textColor = .black
        return cellLbl
    }()
    
    let collectionView = UICollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetup()
    }
    
    func collectionViewSetup() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        self.view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension CollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cellLabel.text = "\(array[indexPath.row])"
        cell.contentView.addSubview(cellLabel)
        return cell
    }
}
