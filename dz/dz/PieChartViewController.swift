import UIKit

class PieChartViewController: UIViewController {
    
    let pieChartView = PieChartView()
    
    override func viewDidLoad() {
    }
    
    override func loadView() {
        view = pieChartView
        view.backgroundColor = .white
    }
}
