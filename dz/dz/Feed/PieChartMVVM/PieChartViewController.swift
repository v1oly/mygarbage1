import DZUIKit
import UIKit

class PieChartViewController: UIViewController {
    
    var pieChartView: PieChartView!
    var pieChartViewModel: PieChartViewModel!
    var detailsView: DetailsView! // swiftlint:disable:this implicitly_unwrapped_optional
    var colorPicker: ColorPickerView! // swiftlint:disable:this implicitly_unwrapped_optional
    var arrayListOfColorNamesView: ArrayListView! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartViewModel = PieChartViewModel(
            detailsViewControllerDisplay: { [weak self] in
                self?.detailsViewControllerDisplay()
            },
            detailsViewValuesBind: { [weak self] in
                self?.pieChartViewModel.pieStepperValue = self?.detailsView.pieValueStepper.value ?? 1
                self?.pieChartViewModel.pieLable = self?.detailsView.setTextToSegmentField.text ?? ""
            },
            colorPickerDisplay: { [weak self] in
                self?.colorPickerDisplay()
            },
            arrayListDiplay: { [weak self] in
                self?.arrayListDisplay()
            },
            setDisplatColorButton: { [weak self] color in
                self?.setDetailsViewColorButton(color)
            },
            updateListViewNames: { [weak self]  in
                self?.updateListViewNames()
            },
            newSelectPieName: { [weak self] selectedName in
                self?.pieChartView.setSelectPieButtonTitle(selectedName)
            },
            updateSegmentsToView: { [weak self] in
                self?.updateSegmentsToView()
            })
        
        detailsView = DetailsView(quitDetailsViewController: { [weak self] in
            self?.detailsViewControllerDisplay()
        }, openColorPickerView: { [weak self] in
            self?.colorPickerDisplay()
        }, addPieToDiagram: { [weak self] in
            self?.pieChartViewModel.addPieToDiagram()
        })
        
        colorPicker = ColorPickerView { [weak self] pickedColor in
            self?.pieChartViewModel.pickedColor = pickedColor
            self?.pieChartViewModel.submitColorPicker()
        }
        
        arrayListOfColorNamesView = ArrayListView { [weak self] pickedValue in
            self?.pieChartViewModel.pickedValue = pickedValue
            self?.pieChartViewModel.selectArrayListView()
        }
        updateSegmentsToView()
    }
    
    override func loadView() {
        super.loadView()
        
        pieChartView = PieChartView(
            displayDetailsView: { [weak self] in
                self?.detailsViewControllerDisplay()
                self?.pieChartViewModel.updateListView()
            },
            deletePieFromModel: { [weak self] in
                self?.deletePie()
            },
            arrayListDisplay: { [weak self] in
                self?.arrayListDisplay()
            })
        
        view = pieChartView
        view.backgroundColor = .white
    }
    
    func deletePie() {
        pieChartViewModel.deletePie()
    }
    
    func updateSegmentsToView() {
        pieChartView.segments = pieChartViewModel.pieSegmets
        pieChartView.setNeedsDisplay()
    }
    
    func detailsViewControllerDisplay() {
        if view.subviews.contains(detailsView) {
            detailsView.removeFromSuperview()
        } else {
            view.addSubview(detailsView)
        }
    }
    
    func colorPickerDisplay() {
        if view.subviews.contains(colorPicker) {
            colorPicker.removeFromSuperview()
        } else {
            view.addSubview(colorPicker)
        }
    }
    
    func arrayListDisplay() {
        if view.subviews.contains(arrayListOfColorNamesView) {
            arrayListOfColorNamesView.removeFromSuperview()
        } else {
            updateListViewNames()
            view.addSubview(arrayListOfColorNamesView)
        }
    }
    
    func setDetailsViewColorButton(_ color: UIColor) {
        detailsView.selectColorButton.setTitleColor(color, for: .normal)
    }
    
    func updateListViewNames() {
        arrayListOfColorNamesView.arrayOfNames = pieChartViewModel.arrayOfSegmentNames
        arrayListOfColorNamesView.tableViewUpdateData()
    }
    
//    func updateArrayOfNames() {
//        var array = [String]()
//        for index in 0...segments.count - 1 {
//            let title = segments[index].title
//            array.append(title)
//            arrayOfSegmentsNames = array
//        }
//    }

//    func submitColorPicker() {
//        colorPickerDisplay()
//        selectedColor = pieChartModel.pickedColor
//        detailsView.selectColorButton.setTitleColor(selectedColor, for: .normal)
//    }
//
//    func addPieToDiagram() {
//        guard pickedColor != UIColor.clear else {
//            return
//        }
//        let pieLable = pieChartModel.pieLable
//        let pieValue = pieChartModel.pieStepperValue
//        pieChartModel.pieSegments.append(Segment(color: selectedColor, value: CGFloat(pieValue), title: pieLable))
//        updateListView()
//        detailsViewControllerDisplay()
//    }
//
//    func updateListView() {
//        arrayListOfColorNamesView.arrayOfNames = arrayOfSegmentsNames
//        arrayListOfColorNamesView.tableViewUpdateData()
//        updateArrayOfNames()
//    }
//
//    func selectArrayListView() {
//        updateListView()
//        newSelectPieName?(selectedValue)
//        arrayListDiplay()
//    }
//
//    func deletePie() {
//        guard (!selectedValue.isEmpty) && (pieChartModel.pieSegments.count != 1) else {
//            return
//        }
//        let deleteIndex = segments.firstIndex { $0.title == selectedValue }
//        pieChartModel.pieSegments.remove(at: deleteIndex!) // swiftlint:disable:this force_unwrapping
//        updateListView()
//        newSelectPieName?("Select Pie To Delete")
//    }
    
//    func quitDetailsViewController() {
////        self.view.viewWithTag(2)?.removeFromSuperview()
//    }
//
//    func submitColorPicker() {
////        self.view.viewWithTag(3)?.removeFromSuperview()
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
////        self.view.viewWithTag(4)?.removeFromSuperview()
//    }
}

