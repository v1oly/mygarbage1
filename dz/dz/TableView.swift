import UIKit
// fuck this warning

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let array: Array = { () -> [Any] in
        var arr = [Int]()
        for index in 1...20 {
            arr += [index]
        }
        return arr
    }()
    
    let table = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }
    
    func tableViewSetup() {
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension TableViewController {
// i dont think is it true warning, a lot of ppl used extensions in the same file
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSessionViewController = SessionSummaryViewController()
        self.navigationController?.pushViewController(newSessionViewController, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(array[indexPath.row])"
        return cell
    }
}
