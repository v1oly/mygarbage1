import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let array = Array(1...30)
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetup()
    }
    
    func collectionViewSetup() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 60, height: 60)
        
        collectionView = UICollectionView(frame:.zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(MyCell.self, forCellWithReuseIdentifier: "super-identifier-cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "super-identifier-cell", for: indexPath)
        guard let myCell = cell as? MyCell else {
            return UICollectionViewCell()
        }
        myCell.backgroundColor = .purple
        myCell.setText("\(array[indexPath.item])")
        
        return myCell
    }
}

class MyCell: UICollectionViewCell {
    let label = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = ""
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
}
