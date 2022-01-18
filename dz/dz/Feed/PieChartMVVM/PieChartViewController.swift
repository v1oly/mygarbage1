import DZUIKit
import UIKit

class PieChartViewController: UIViewController {
    
    private var pieChartView: PieChartView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var pieChartViewModel: PieChartViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    private var detailsView: DetailsView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var colorPickerView: ColorPickerView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var arrayListView: ArrayListView! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChartViewModel = PieChartViewModel(
            detailsViewControllerDisplay: { [weak self] in
                self?.detailsViewControllerDisplay()
            },
            detailsViewValuesBind: { [weak self] in
                self?.pieChartViewModel.pieStepperValue = self?.detailsView.pieValueStepper.value ?? 1
                self?.pieChartViewModel.pieName = self?.detailsView.setTextToSegmentField.text ?? ""
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
                self?.pieChartView.onUpdatePieSegments()
            }
        )
        
        detailsView = DetailsView(
            onQuitFromView: { [weak self] in
                self?.detailsViewControllerDisplay()
            }, onSelectColor: { [weak self] in
                self?.colorPickerDisplay()
            }, onSubmitPieAdd: { [weak self] in
                self?.pieChartViewModel.addPieToDiagram()
            }
        )
        
        colorPickerView = ColorPickerView { [weak self] pickedColor in
            self?.pieChartViewModel.pickedColor = pickedColor
            self?.pieChartViewModel.submitColorPicker()
        }
        
        arrayListView = ArrayListView { [weak self] pickedSegment in
            self?.pieChartViewModel.pickedSegment = pickedSegment
            self?.pieChartViewModel.selectArrayListView()
        }
        pieChartView.onUpdatePieSegments()
    }
    
    override func loadView() {
        pieChartView = PieChartView(
            onUpdatePieSegments: { [weak self] in
            self?.pieChartView.updatePieSegments(segments: self?.pieChartViewModel.pieSegmets ?? [])
            },
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
    
    func detailsViewControllerDisplay() {
        if view.subviews.contains(detailsView) {
            detailsView.removeFromSuperview()
        } else {
            view.addSubview(detailsView)
        }
    }
    
    func colorPickerDisplay() {
        if view.subviews.contains(colorPickerView) {
            colorPickerView.removeFromSuperview()
        } else {
            view.addSubview(colorPickerView)
        }
    }
    
    func arrayListDisplay() {
        if view.subviews.contains(arrayListView) {
            arrayListView.removeFromSuperview()
        } else {
            updateListViewNames()
            view.addSubview(arrayListView)
        }
    }
    
    func setDetailsViewColorButton(_ color: UIColor) {
        detailsView.selectColorButton.setTitleColor(color, for: .normal)
    }
    
    func updateListViewNames() {
        arrayListView.updateDataOfTableView(arrayListOfFieldsNames: pieChartViewModel.segmentNames)
    }
}
