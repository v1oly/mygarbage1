import UIKit

class PieChartViewController: UIViewController, PieChartDelegate {
    
    let pieChartView = PieChartView()
    let detailsView = DetailsView()
    let colorPicker = ColorPickerView()
    let addSegment = UIButton()
    var selectedColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func loadView() {
        view = pieChartView
        view.backgroundColor = .white
    }
    func setup() {
        colorPicker.tag = 3
        detailsView.tag = 2
        
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
        colorPicker.delegate = self
    }
    func quitDetailsViewController() {
        self.view.viewWithTag(2)?.removeFromSuperview()
    }
    
    func submitColorPicker() {
        self.view.viewWithTag(3)?.removeFromSuperview()
        selectedColor = colorPicker.pickedColor
        detailsView.selectColorButton.setTitleColor(selectedColor, for: .normal)
    }
    
    func openColorPickerView() {
        view.addSubview(colorPicker)
    }
    
    @objc
    func addSegmentToDiagram(_ sender: UIButton) {
        view.addSubview(detailsView)
        print ("got it")
    }
}

protocol PieChartDelegate: AnyObject {
    func quitDetailsViewController()
    func submitColorPicker()
    func openColorPickerView()
}
