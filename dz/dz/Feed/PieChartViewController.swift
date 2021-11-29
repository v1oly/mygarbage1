import UIKit

class PieChartViewController: UIViewController, PieChartDelegate {
    
    let pieChartView = PieChartView()
    let detailsView = DetailsView()
    let colorPicker = ColorPickerView()
    let arrayListOfColorNamesView = ArrayListView()
    let addSegment = UIButton()
    let selectPieToDelete = UIButton()
    let confirmDelete = UIButton()
    var selectedColor = UIColor()
    var isColorPickerAlreadyOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func loadView() {
        view = pieChartView
        view.backgroundColor = .white
    }
    func setup() {
        arrayListOfColorNamesView.tag = 4
        colorPicker.tag = 3
        detailsView.tag = 2
        
        selectPieToDelete.addTarget(self, action: #selector(selectPieToDelete(_:)), for: .touchUpInside)
        selectPieToDelete.frame.size = CGSize(width: 150, height: 50)
        view.addSubview(selectPieToDelete)
        selectPieToDelete.frame.origin = CGPoint(
            x: 210,
            y: 105
        )
        selectPieToDelete.setTitle("Select Pie To Delete", for: .normal)
        selectPieToDelete.sizeToFit()
        selectPieToDelete.setTitleColor(.black, for: .normal)
        selectPieToDelete.contentHorizontalAlignment = .center
        selectPieToDelete.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        addSegment.addTarget(self, action: #selector(addSegmentToDiagram(_:)), for: .touchUpInside)
        addSegment.frame.size = CGSize(width: 100, height: 50)
        view.addSubview(addSegment)
        addSegment.frame.origin = CGPoint(
            x: UIScreen.main.bounds.minX + 100,
            y: UIScreen.main.bounds.minY + 150
        )
        addSegment.setTitle("Add Segment", for: .normal)
        addSegment.sizeToFit()
        addSegment.setTitleColor(.black, for: .normal)
        addSegment.contentHorizontalAlignment = .center
        addSegment.backgroundColor = .clear
        
        confirmDelete.addTarget(self, action: #selector(deletePie(_:)), for: .touchUpInside)
        confirmDelete.frame.size = CGSize(width: 100, height: 50)
        view.addSubview(confirmDelete)
        confirmDelete.frame.origin = CGPoint(
            x: selectPieToDelete.frame.origin.x + 45,
            y: selectPieToDelete.frame.origin.y + 45
        )
        confirmDelete.setTitle("Delete Pie", for: .normal)
        confirmDelete.sizeToFit()
        confirmDelete.setTitleColor(.black, for: .normal)
        confirmDelete.contentHorizontalAlignment = .center
        confirmDelete.backgroundColor = .clear
        
        detailsView.delegate = self
        colorPicker.delegate = self
        arrayListOfColorNamesView.delegate = self
    }
    
    func quitDetailsViewController() {
        print("helloworld")
        self.view.viewWithTag(2)?.removeFromSuperview()
    }
    
    func submitColorPicker() {
        self.view.viewWithTag(3)?.removeFromSuperview()
        selectedColor = colorPicker.pickedColor
        detailsView.selectColorButton.setTitleColor(selectedColor, for: .normal)
        isColorPickerAlreadyOpened = false
    }
    
    func openColorPickerView() {
        if isColorPickerAlreadyOpened != true {
            view.addSubview(colorPicker)
            isColorPickerAlreadyOpened = true
        } else {
            self.view.viewWithTag(3)?.removeFromSuperview()
            isColorPickerAlreadyOpened = false
        }
    }
    
    func addPieToDiagram() {
        guard colorPicker.pickedColor != UIColor.clear else {
            return
        }
        let pieLable = detailsView.setTextToSegmentField.text ?? "" 
        let pieValue = detailsView.pieValueStepper.value
        pieChartView.segments.append(Segment(color: selectedColor, value: CGFloat(pieValue), title: pieLable))
        updateListView()
        quitDetailsViewController()
    }
    func updateListView() {
        arrayListOfColorNamesView.arrayOfNames = pieChartView.arrayOfSegmentsNames
        arrayListOfColorNamesView.tableViewUpdateData()
        pieChartView.updateArrayOfNames()
    }
    
    func selectArrayListView() {
        updateListView()
        selectPieToDelete.setTitle(arrayListOfColorNamesView.selectedValue, for: .normal)
        self.view.viewWithTag(4)?.removeFromSuperview()
    }
    
    @objc
    func addSegmentToDiagram(_ sender: UIButton) {
        view.addSubview(detailsView)
        updateListView()
    }
    @objc
    func selectPieToDelete(_ sender: UIButton) {
        updateListView()
        view.addSubview(arrayListOfColorNamesView)
    }
    @objc
    func deletePie(_ sender: UIButton) {
        guard (arrayListOfColorNamesView.selectedValue != nil) && (pieChartView.segments.count != 1) else {
            return
        }
        let deleteIndex = pieChartView.segments.firstIndex { $0.title == arrayListOfColorNamesView.selectedValue }
        pieChartView.segments.remove(at: deleteIndex!) // swiftlint:disable:this force_unwrapping
        updateListView()
        selectPieToDelete.setTitle("Select Pie To Delete", for: .normal)
    }
}

protocol PieChartDelegate: AnyObject {
    func quitDetailsViewController()
    func selectArrayListView()
    func submitColorPicker()
    func openColorPickerView()
    func addPieToDiagram()
}
