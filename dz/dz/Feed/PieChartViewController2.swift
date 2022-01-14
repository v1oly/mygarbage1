//import DZUIKit
//import UIKit
//
//class PieChartViewController2: UIViewController {
//    
//    let pieChartView = PieChartView()
//    var detailsView: DetailsView! // swiftlint:disable:this implicitly_unwrapped_optional
//    var colorPicker: ColorPickerView! // swiftlint:disable:this implicitly_unwrapped_optional
//    var arrayListOfColorNamesView: ArrayListView! // swiftlint:disable:this implicitly_unwrapped_optional
//
//    let addSegment = UIButton()
//    let selectPieToDelete = UIButton()
//    let confirmDelete = UIButton()
//    var selectedColor = UIColor()
//    var selectedValue: String = ""
//    var pickedColor: UIColor = UIColor.clear
//    var isColorPickerAlreadyOpened = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        detailsView = DetailsView(quitDetailsViewController: { [weak self] in
//            self?.quitDetailsViewController()
//        }, openColorPickerView: { [weak self] in
//            self?.openColorPickerView()
//        }, addPieToDiagram: { [weak self] in
//            self?.addPieToDiagram()
//        })
//        
//        colorPicker = ColorPickerView { [weak self] pickedColor in
//            self?.pickedColor = pickedColor
//            self?.submitColorPicker()
//        }
//        
//        arrayListOfColorNamesView = ArrayListView { [weak self] selectedValue in
//            self?.selectedValue = selectedValue
//            self?.selectArrayListView()
//        }
//        
//        setup()
//    }
//    
//    override func loadView() {
//        view = pieChartView
//        view.backgroundColor = .white
//    }
//    
//    func setup() {
//        
//        arrayListOfColorNamesView.tag = 4
//        colorPicker.tag = 3
//        detailsView.tag = 2
//        
//        selectPieToDelete.addTarget(self, action: #selector(selectPieToDelete(_:)), for: .touchUpInside)
//        selectPieToDelete.frame.size = CGSize(width: 150, height: 50)
//        view.addSubview(selectPieToDelete)
//        selectPieToDelete.frame.origin = CGPoint(
//            x: 210,
//            y: 105
//        )
//        selectPieToDelete.setTitle("Select Pie To Delete", for: .normal)
//        selectPieToDelete.sizeToFit()
//        selectPieToDelete.setTitleColor(.black, for: .normal)
//        selectPieToDelete.contentHorizontalAlignment = .center
//        selectPieToDelete.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        
//        addSegment.addTarget(self, action: #selector(addSegmentToDiagram(_:)), for: .touchUpInside)
//        addSegment.frame.size = CGSize(width: 100, height: 50)
//        view.addSubview(addSegment)
//        addSegment.frame.origin = CGPoint(
//            x: UIScreen.main.bounds.minX + 100,
//            y: UIScreen.main.bounds.minY + 150
//        )
//        addSegment.setTitle("Add Segment", for: .normal)
//        addSegment.sizeToFit()
//        addSegment.setTitleColor(.black, for: .normal)
//        addSegment.contentHorizontalAlignment = .center
//        addSegment.backgroundColor = .clear
//        
//        confirmDelete.addTarget(self, action: #selector(deletePie(_:)), for: .touchUpInside)
//        confirmDelete.frame.size = CGSize(width: 100, height: 50)
//        view.addSubview(confirmDelete)
//        confirmDelete.frame.origin = CGPoint(
//            x: selectPieToDelete.frame.origin.x + 45,
//            y: selectPieToDelete.frame.origin.y + 45
//        )
//        confirmDelete.setTitle("Delete Pie", for: .normal)
//        confirmDelete.sizeToFit()
//        confirmDelete.setTitleColor(.black, for: .normal)
//        confirmDelete.contentHorizontalAlignment = .center
//        confirmDelete.backgroundColor = .clear
//    }
//    
//    func quitDetailsViewController() {
//        print("helloworld")
//        self.view.viewWithTag(2)?.removeFromSuperview()
//    }
//    
//    func submitColorPicker() {
//        self.view.viewWithTag(3)?.removeFromSuperview()
//        selectedColor = pickedColor
//        detailsView.selectColorButton.setTitleColor(selectedColor, for: .normal)
//        isColorPickerAlreadyOpened = false
//    }
//    
//    func openColorPickerView() {
//        if isColorPickerAlreadyOpened == false {
//            view.addSubview(colorPicker)
//            isColorPickerAlreadyOpened = true
//        } else {
//            self.view.viewWithTag(3)?.removeFromSuperview()
//            isColorPickerAlreadyOpened = false
//        }
//    }
//    
//    func addPieToDiagram() {
//        guard pickedColor != UIColor.clear else {
//            return
//        }
//        let pieLable = detailsView.setTextToSegmentField.text ?? "" 
//        let pieValue = detailsView.pieValueStepper.value
//        pieChartView.segments.append(Segment(color: selectedColor, value: CGFloat(pieValue), title: pieLable))
//        updateListView()
//        quitDetailsViewController()
//    }
//    func updateListView() {
//        arrayListOfColorNamesView.arrayOfNames = pieChartView.arrayOfSegmentsNames
//        arrayListOfColorNamesView.tableViewUpdateData()
//        pieChartView.updateArrayOfNames()
//    }
//    
//    func selectArrayListView() {
//        updateListView()
//        selectPieToDelete.setTitle(selectedValue, for: .normal)
//        self.view.viewWithTag(4)?.removeFromSuperview()
//    }
//    
//    @objc
//    func addSegmentToDiagram(_ sender: UIButton) {
//        view.addSubview(detailsView)
//        updateListView()
//    }
//    @objc
//    func selectPieToDelete(_ sender: UIButton) {
//        updateListView()
//        view.addSubview(arrayListOfColorNamesView)
//    }
//    @objc
//    func deletePie(_ sender: UIButton) {
//        guard (!selectedValue.isEmpty) && (pieChartView.segments.count != 1) else {
//            return
//        }
//        let deleteIndex = pieChartView.segments.firstIndex { $0.title == selectedValue }
//        pieChartView.segments.remove(at: deleteIndex!) // swiftlint:disable:this force_unwrapping
//        updateListView()
//        selectPieToDelete.setTitle("Select Pie To Delete", for: .normal)
//    }
//}
