import UIKit

class CollectionViewController: UIViewController,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITabBarControllerDelegate {
    
    let diagramCell = DiagramCell()
    let array = Array(1...3)
    var collectionView: UICollectionView! // swiftlint:disable:this implicitly_unwrapped_optional

    let nextButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self

        collectionViewSetup()
        buttonSetup()
    }
    
    func collectionViewSetup() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 200)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.register(DiagramCell.self, forCellWithReuseIdentifier: "super-identifier-cell")
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
    
    func buttonSetup() {
        nextButton.addTarget(self, action: #selector(showSelectionViewController(_:)), for: .touchUpInside)
        nextButton.frame.size = CGSize(width: 50, height: 50)
        view.addSubview(nextButton)
        nextButton.frame.origin = CGPoint(x: view.bounds.width - 50, y: view.bounds.minY + 100)
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.contentHorizontalAlignment = .center
        nextButton.backgroundColor = .white
    }
    
    @objc
    func showSelectionViewController(_ sender: UIButton) {
        let newSessionViewController = SessionSummaryViewController()
        self.navigationController?.pushViewController(newSessionViewController, animated: false)
    }
}

extension CollectionViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "super-identifier-cell", for: indexPath)
        guard let myCell = cell as? DiagramCell else {
            return UICollectionViewCell()
        }
        return myCell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
    }
}
