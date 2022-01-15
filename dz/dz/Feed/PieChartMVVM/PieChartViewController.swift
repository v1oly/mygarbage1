import DZUIKit
import UIKit

class PieChartViewController: UIViewController {
    
    var pieChartView: PieChartView! // swiftlint:disable:this implicitly_unwrapped_optional
    var pieChartViewModel: PieChartViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
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
            }
        )
        
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
        pieChartView = PieChartView(
            onAddSegment: { [weak self] in
                self?.detailsViewControllerDisplay()
                self?.pieChartViewModel.updateListView()
            },
            onDeletePie: { [weak self] in
                self?.deletePie()
            },
            onSelectPie: { [weak self] in
                self?.arrayListDisplay()
            }
        )
        
        view = pieChartView
        view.backgroundColor = .white
    }
    
    func deletePie() {
        pieChartViewModel.deletePie()
    }
    
    func updateSegmentsToView() {
        pieChartView.pieSegments = pieChartViewModel.pieSegmets
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
}
