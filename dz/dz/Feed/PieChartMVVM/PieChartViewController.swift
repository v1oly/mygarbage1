import DZUIKit
import UIKit

class PieChartViewController: UIViewController {
    
    private var pieChartView: PieChartView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var viewModel: PieChartViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    private var detailsView: DetailsView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var colorPickerView: ColorPickerView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var arrayListView: ArrayListView! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsView = DetailsView(
            onDismiss: { [weak self] in
                self?.detailsView.removeFromSuperview()
                self?.colorPickerView.removeFromSuperview()
            },
            onOpenColorPicker: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.view.addSubview(strongSelf.colorPickerView)
            },
            onAddPie: { [weak self] name, size in
                self?.viewModel.setNewSegment(name: name, size: size)
                self?.detailsView.removeFromSuperview()
                self?.colorPickerView.removeFromSuperview()
            }
        )
        
        colorPickerView = ColorPickerView { [weak self] pickedColor in
            self?.viewModel.setNewSegment(color: SegmentColor.from(uiColor: pickedColor))
            self?.colorPickerView.removeFromSuperview()
        }
        
        arrayListView = ArrayListView(
            onTableCellSelect: { [weak self] pickedSegment in
                self?.viewModel.setNameOfSegmentToDelete(pickedSegment)
                self?.arrayListView.removeFromSuperview()
            }
        )
        
        viewModel = PieChartViewModel(
            onDataUpdate: { [weak self] newData in
                self?.pieChartView.updatePieSegments(segments: newData.pieSegments.toViewSegments())
                self?.arrayListView.updateDataOfTableView(arrayListOfFieldsNames: newData.pieSegments.map(\.title))
                self?.pieChartView.setPieSelectionTitle(newData.nameOfSegmentToDelete ?? "Select to delete")
                self?.detailsView.setSelected(color: newData.segmentToAdd?.color.toUIColor() ?? .black)
                self?.pieChartView.updateDiagram(size: newData.diagramSize)
            }
        )
    }
    
    override func loadView() {
        pieChartView = PieChartView(
            onAddSegment: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.view.addSubview(strongSelf.detailsView)
            },
            onDeletePie: { [weak self] in
                self?.viewModel.deleteSelectedSegment()
            },
            onSelectPie: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.view.addSubview(strongSelf.arrayListView)
            },
            onRadiusChange: { [weak self] size in
                self?.viewModel.setDiagram(size: size)
            }
        )
        
        view = pieChartView
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.triggerDataUpdate()
    }
}

private extension SegmentColor {
    static func from(uiColor: UIColor) -> SegmentColor? {
        switch uiColor {
        case #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1):
            return .red
        case #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1):
            return .pink
        case #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1):
            return .lightGreen
        case #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1):
            return .darkGreen
        case #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1):
            return .yellow
        case #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1):
            return .orange
        case #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1):
            return .white
        case #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1):
            return .gray1
        case #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1):
            return .gray2
        case #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1):
            return .gray3
        case #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1):
            return .gray4
        case #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1):
            return .black
        case #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1):
            return .lightBlue
        case #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1):
            return .darkBlue
        default:
            return nil
        }
    }
    
    func toUIColor() -> UIColor {
        switch self {
        case .red:
            return #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        case .pink:
            return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        case .lightGreen:
            return #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case .darkGreen:
            return #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        case .yellow:
            return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .orange:
            return #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        case .white:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .gray1:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .gray2:
            return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        case .gray3:
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .gray4:
            return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .black:
            return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case .lightBlue:
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case .darkBlue:
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        }
    }
}

struct ViewSegment {
    let color: UIColor
    var value: CGFloat
    var title: String
    
    init(_ segment: Segment) {
        self.color = segment.color.toUIColor()
        self.value = segment.value
        self.title = segment.title
    }
}

private extension Array where Element == Segment {
    func toViewSegments() -> [ViewSegment] {
        map { ViewSegment($0) }
    }
}
