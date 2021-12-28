import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let resultTableView = UITableView()
    let feedDataProvider = FeedDataProvider()
    var originalArray = [FeedData]()
    var resultArray = [FeedData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setup()
    }
    
    func setup() {
        
        originalArray = feedDataProvider.feedMockData()
        resultArray = originalArray
        
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        resultTableView.dataSource = self
        resultTableView.delegate = self
        self.view.addSubview(resultTableView)
        
        resultTableView.translatesAutoresizingMaskIntoConstraints = false
        
        resultTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        resultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        resultTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        resultTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension ResultViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = "\(resultArray[indexPath.row].name)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked")
    }
}
