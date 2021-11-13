import UIKit

class PieChartViewController: UIViewController, PieChartDelegate {
    
    let pieChartView = PieChartView()
    let detailsView = DetailsView()
    let addSegment = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func loadView() {
        view = pieChartView
        pieChartView.tag = 1
        view.backgroundColor = .white
    }
    func setup() {
        addSegment.addTarget(self, action: #selector(addSegmentToDiagram(_:)), for: .touchUpInside)
        addSegment.frame.size = CGSize(width: 100, height: 50)
        view.addSubview(addSegment)
        addSegment.frame.origin = CGPoint(x: UIScreen.main.bounds.minX + 100,
                                          y: UIScreen.main.bounds.minY + 150)
        addSegment.setTitle("Add Segment", for: .normal)
        addSegment.sizeToFit()
        addSegment.setTitleColor(.black, for: .normal)
        addSegment.contentHorizontalAlignment = .center
        addSegment.backgroundColor = .clear
        
        detailsView.delegate = self
    }
    func quitDetailsViewController() {
        self.view.viewWithTag(2)?.removeFromSuperview()
    }
    
    @objc
    func addSegmentToDiagram(_ sender: UIButton) {
        view.addSubview(detailsView)
        detailsView.tag = 2
        print ("got it")
    }
}

protocol PieChartDelegate: AnyObject {
    func quitDetailsViewController()
}
