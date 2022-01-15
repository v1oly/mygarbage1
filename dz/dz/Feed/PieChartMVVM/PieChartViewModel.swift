import DZUIKit
import UIKit

class PieChartViewModel {
    
    var pieChartModel = PieChartModel()
    
    let detailsViewControllerDisplay: () -> () // я хз как весь этот блок кложеров переименовывать, типа я их всех и так по несколько раз передаю в разные функции так что onSmth название не прокатит, а текущие название не оч судя по всему, они либо дублируют названия функций вьюконтроллера либо описывают само действие
    let detailsViewValuesBind: () -> ()
    let colorPickerDisplay: () -> ()
    let arrayListDiplay: () -> ()
    let setDisplatColorButton: (UIColor) -> ()
    let updateListViewNames: () -> ()
    let newSelectPieName: ((String) -> ())?
    let updateSegmentsToView: () -> ()
    
    var pickedColor: UIColor { // я думаю мб можно было бы как то проще связать данные без 5 прокси переменных, просто выглядит это как уродство
        get {
            return pieChartModel.pickedColor
        }
        set {
            pieChartModel.pickedColor = newValue
        }
    }
    
    var pickedValue: String {
        get {
            return pieChartModel.pickedValue
        }
        set {
            pieChartModel.pickedValue = newValue
        }
    }
    
    var arrayOfSegmentNames: [String] {
        get {
            return pieChartModel.arrayOfSegmentNames
        }
        set {
            pieChartModel.arrayOfSegmentNames = newValue
        }
    }
    
    var pieSegmets: [Segment] {
        get {
            return pieChartModel.pieSegments
        }
        set {
            pieChartModel.pieSegments = newValue
        }
    }
    
    var pieLable: String {
        get {
            return pieChartModel.pieLable
        }
        set {
            pieChartModel.pieLable = newValue
        }
    }
    
    var pieStepperValue: Double {
        get {
            return pieChartModel.pieStepperValue
        }
        set {
            pieChartModel.pieStepperValue = newValue
        }
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
        let pieLable = pieChartModel.pieLable
        let pieValue = pieChartModel.pieStepperValue
        let selectedColor = pieChartModel.pickedColor
        pieChartModel.pieSegments.append(Segment(color: selectedColor, value: CGFloat(pieValue), title: pieLable))
        updateSegmentsToView()
        updateListView()
        detailsViewControllerDisplay()
    }
    
    func updateListView() {
        updateListViewNames()
        pieChartModel.updateArrayOfNames()
    }
    
    func selectArrayListView() {
        updateListView()
        newSelectPieName?(pieChartModel.pickedValue)
        arrayListDiplay()
    }
    
    func deletePie() {
        let selectedValue = pieChartModel.pickedValue
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
