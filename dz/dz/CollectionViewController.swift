import UIKit

class CollectionViewController: UIViewController,
UICollectionViewDelegate,
UICollectionViewDataSource,
UITabBarControllerDelegate {
    
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
        guard let myCell = cell as? MyCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == 0 {
            myCell.setStack()
            myCell.setText("00:00:00")
            myCell.count = 0
            myCell.setTimer(invalidate: true)
        } else {
            myCell.backgroundColor = . gray
            myCell.setText("\(array[indexPath.item])")
        }
        
        return myCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MyCell {
            if indexPath.item == 0 {
                cell.setTimer(invalidate: true)
            }
            cell.backgroundColor = .gray
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? MyCell {
            if indexPath.item == 0 && !cell.myTimer.isValid {
                cell.setTimer(invalidate: false)
                print("set timer")
            } else if indexPath.item == 0 && cell.myTimer.isValid {
                cell.setTimer(invalidate: true)
                print("timer paused")
            }
            cell.backgroundColor = .red
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        print("selected tab - \(tabBarIndex)")
        if tabBarIndex != 1 {
            let indexPath = IndexPath(item: 0, section: 0)
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

class MyCell: UICollectionViewCell {
    let label = UILabel()
    lazy var stack = UIStackView()
    var myTimer = Timer()
    var count = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        addSubview(stack)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = ""
    }
    
    func setTimer(invalidate: Bool) {
        if !invalidate {
            myTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                count += 1
                countdown(count: count, lableC: label)
            }
        } else {
            myTimer.invalidate()
        }
    }
    
    func setStack() {
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.backgroundColor = .red
        stack.addArrangedSubview(label)
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    @objc
    func countdown(count: Int, lableC: UILabel) {
        var hours: Int
        var minutes: Int
        var seconds: Int
        
        hours = count / 3_600
        minutes = (count % 3_600) / 60
        seconds = (count % 3_600) % 60
        lableC.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stack.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
}
