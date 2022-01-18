import Foundation
import UIKit

public class ArrayListView: UIView, UITableViewDelegate, UITableViewDataSource {
    private var arrayOfNames = [""]
    private let refreshControl = UIRefreshControl()
    
    private let onTableCellSelect: (String) -> ()
    
    private let table = UITableView()
    
    public init(onTableCellSelect: @escaping (String) -> () ) {
        self.onTableCellSelect = onTableCellSelect
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateDataOfTableView(arrayListOfFieldsNames: [String]) {
        arrayOfNames = arrayListOfFieldsNames
        self.table.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    private func setup() {
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

    extension ArrayListView {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfNames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(arrayOfNames[indexPath.row])"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedValue = arrayOfNames[indexPath.row]
        print(arrayOfNames[indexPath.row])
        
        onTableCellSelect(selectedValue)
    }
}
