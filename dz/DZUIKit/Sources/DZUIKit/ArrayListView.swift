import Foundation
import UIKit

public class ArrayListView: UIView, UITableViewDelegate, UITableViewDataSource {
    public var arrayOfNames = [""]
    private let refreshControl = UIRefreshControl()
    
    private let closure: (String) -> ()
    
    private let table = UITableView()
    
    public init(closure: @escaping (String) -> () ) {
        self.closure = closure
        super.init(frame: CGRect.zero)
        tableViewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func tableViewUpdateData() {
        self.table.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func tableViewSetup() {
        self.frame = CGRect(x: 210, y: 105, width: 150, height: 200)
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.dataSource = self
        table.delegate = self
        addSubview(table)
        
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}

public extension ArrayListView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(arrayOfNames[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = arrayOfNames[indexPath.row]
        print(arrayOfNames[indexPath.row])

        closure(selectedValue)
    }
}
