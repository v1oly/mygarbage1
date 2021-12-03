import UIKit

struct SuffixIterator: IteratorProtocol {
    let string: String
    var last: String.Index
    var offset: String.Index
    
    init (string: String) {
        self.string = string
        self.last = string.endIndex
        self.offset = string.startIndex
    }
    
    mutating func next() -> Substring? {
        guard offset < last else {
            return nil
        }
        
        let sub: Substring = string[offset..<last]
        string.formIndex(after: &offset)
        return sub
    }
}

struct SuffixSequence: Sequence {
    let string: String
    
    func makeIterator() -> SuffixIterator {
        return SuffixIterator(string: string)
    }
}

class SequenceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let algoProvider = AlgoProvider()
    
    let arrayViewController = ArrayViewController()
    let setViewController = SetViewController()
    let dictionaryViewController = DictionaryViewController()
    
    let tableView = UITableView()
    let tableViewCellsNames = [
        "Array",
        "Set",
        "Dictionary"
    ]
    
    var algoArray = [String]()
    var suffixArray = [(algoName: String, suffix: Substring)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        algoArray = algoProvider.all
        suffixArrayMake()
    }
    
    func setup() {
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
    
    func suffixArrayMake() {
        for index in 0...algoArray.count - 1 {
            for suffix in SuffixSequence(string: algoArray[index]) {
                suffixArray.append((algoName: algoArray[index], suffix: suffix))
            }
        }
        suffixArray = suffixArray.sorted(by: { $0.algoName < $1.algoName } )
        print(suffixArray)
    }
}

extension SequenceViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCellsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = "\(tableViewCellsNames[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(arrayViewController, animated: false)
        case 1:
            self.navigationController?.pushViewController(setViewController, animated: false)
        case 2:
            self.navigationController?.pushViewController(dictionaryViewController, animated: false)
        default:
            break
        }
    }
}
