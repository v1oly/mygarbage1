import Foundation
import UIKit

public class ArrayListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    private var arrayOfNames = [""]
    
    private let onTableCellSelect: (String) -> ()
    
    public init(
    onTableCellSelect: @escaping (String) -> ()
    ) {
        self.onTableCellSelect = onTableCellSelect
        super.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateDataOfTableView(arrayListOfFieldsNames: [String]) {
        arrayOfNames = arrayListOfFieldsNames
        self.reloadData()
    }
    
    private func setup() {
        
        self.frame = CGRect(x: 210, y: 105, width: 150, height: 200)
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.dataSource = self
        self.delegate = self
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
        
        onTableCellSelect(selectedValue)
    }
}
