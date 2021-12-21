import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let resultViewController = ResultViewController()
    
    var array = [FeedData]()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        let searchController = UISearchController(searchResultsController: resultViewController)
        super.viewDidLoad()
        title = "Search"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        tableViewSetup()
    }
    
    func tableViewSetup() {
        array = resultViewController.feedDataProvider.feedMockData()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension TableViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSessionViewController = PieChartViewController()
        self.navigationController?.pushViewController(newSessionViewController, animated: false)
        print("1")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(array[indexPath.row].name)"
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        resultViewController.resultArray.removeAll()
        var matchFound = false
        var clearFound = false
        
        for item in resultViewController.originalArray {
            if item.name.prefix(text.count) == text {
                resultViewController.resultArray += [item]
                resultViewController.resultTableView.reloadData()
                matchFound = true
            } else if (!matchFound) && (!clearFound) {
                resultViewController.resultArray.removeAll()
                resultViewController.resultTableView.reloadData()
                clearFound = true
            }
        }
    }
}
