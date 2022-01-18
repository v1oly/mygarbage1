import DZUIKit
import UIKit

class PieChartViewModel {
    
    var pieChartModel: PieChartModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    let detailsViewControllerDisplay: () -> ()
    let detailsViewValuesBind: () -> ()
    let colorPickerDisplay: () -> ()
    let arrayListDiplay: () -> ()
    let setDisplatColorButton: (UIColor) -> ()
    let updateListViewNames: () -> ()
    let newSelectPieName: ((String) -> ())?
    let updateSegmentsToView: () -> ()
    
    var pickedColor: UIColor {
        get { return pieChartModel.pickedColor }
        set { pieChartModel.pickedColor = newValue }
    }
    
    var pickedSegment: String {
        get { return pieChartModel.pickedSegment }
        set { pieChartModel.pickedSegment = newValue }
    }
    
    var segmentNames: [String] {
        get { return pieChartModel.arrayOfSegmentNames }
        set { pieChartModel.arrayOfSegmentNames = newValue }
    }
    
    var pieSegmets: [Segment] {
        get { return pieChartModel.pieSegments }
        set { pieChartModel.pieSegments = newValue }
    }
    
    var pieName: String {
        get { return pieChartModel.pieName }
        set { pieChartModel.pieName = newValue }
    }
    
    var pieStepperValue: Double {
        get { return pieChartModel.diagramSize }
        set { pieChartModel.diagramSize = newValue }
    }
    
    init(
        detailsViewControllerDisplay: @escaping () -> (),
        detailsViewValuesBind: @escaping () -> (),
        colorPickerDisplay: @escaping () -> (),
        arrayListDiplay: @escaping () -> (),
        setDisplatColorButton: @escaping (UIColor) -> (),
        updateListViewNames: @escaping () -> (),
        newSelectPieName: @escaping (String) -> (),
        updateSegmentsToView: @escaping () -> ()
    ) {
        
        self.detailsViewControllerDisplay = detailsViewControllerDisplay
        self.detailsViewValuesBind = detailsViewValuesBind
        self.colorPickerDisplay = colorPickerDisplay
        self.arrayListDiplay = arrayListDiplay
        self.setDisplatColorButton = setDisplatColorButton
        self.updateListViewNames = updateListViewNames
        self.newSelectPieName = newSelectPieName
        self.updateSegmentsToView = updateSegmentsToView
        
        self.pieChartModel = PieChartModel { [weak self] in
            self?.updateArrayOfNames()
        }
    }
    
    func submitColorPicker() {
        colorPickerDisplay()
        setDisplatColorButton(pieChartModel.pickedColor)
    }
    
    func addPieToDiagram() {
        guard pickedColor != UIColor.clear else { // наверное типа isEmpty лучше заюзать
            return
        }
        detailsViewValuesBind()
        let pieLable = pieChartModel.pieName
        let pieValue = pieChartModel.diagramSize
        let selectedColor = pieChartModel.pickedColor
        pieChartModel.pieSegments.append(Segment(color: selectedColor, value: CGFloat(pieValue), title: pieLable))
        updateSegmentsToView()
        updateListView()
        detailsViewControllerDisplay()
    }
    
    func updateListView() {
        updateListViewNames()
        updateArrayOfNames()
    }
    
    func updateArrayOfNames() {
        var array = [String]()
        for segment in pieChartModel.pieSegments {
            let title = segment.title
            array.append(title)
        }
        pieChartModel.arrayOfSegmentNames = array
    }

    func selectArrayListView() {
        updateListView()
        newSelectPieName?(pieChartModel.pickedSegment)
        arrayListDiplay()
    }
    
    func deletePie() {
        let selectedValue = pieChartModel.pickedSegment
        guard (!selectedValue.isEmpty) && (pieChartModel.pieSegments.count != 1) else {
            return
        }
        let deleteIndex = pieChartModel.pieSegments.firstIndex { $0.title == selectedValue }
        pieChartModel.pieSegments.remove(at: deleteIndex!) // swiftlint:disable:this force_unwrapping
        updateSegmentsToView()
        updateListView()
        newSelectPieName?("Select Pie To Delete")
    }
}
