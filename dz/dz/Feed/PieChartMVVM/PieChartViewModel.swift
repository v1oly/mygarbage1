import DZUIKit
import UIKit

class PieChartViewModel {
    
    var model = PieChartModel() {
        didSet { onDataUpdate?(model) }
    }
    
    var onDataUpdate: ((PieChartModel) -> ())?
    
    init(onDataUpdate: @escaping (PieChartModel) -> ()) {
        self.onDataUpdate = onDataUpdate
    }
    
    func triggerDataUpdate() {
        onDataUpdate?(model)
    }
    
    func setNameOfSegmentToDelete(_ name: String) {
        model.nameOfSegmentToDelete = name
    }
    
    func deleteSelectedSegment() {
        guard
            let name = model.nameOfSegmentToDelete,
            let segmentIndex = model.pieSegments.firstIndex(where: { $0.title == name })
        else { return }
        
        model.nameOfSegmentToDelete = nil
        model.pieSegments.remove(at: segmentIndex)
    }
    
    func setNewSegment(color: SegmentColor?) {
        guard let color = color else { return }
        
        if model.segmentToAdd != nil {
            model.segmentToAdd?.color = color
        } else {
            model.segmentToAdd = Segment(
                color: color,
                value: 0,
                title: ""
            )
        }
    }
    
    func setDiagram(size: Double) {
        model.diagramSize = size
    }
    
    func setNewSegment(name: String, size: CGFloat) {
        guard var segmentToAdd = model.segmentToAdd else { return }
        
        segmentToAdd.title = name
        segmentToAdd.value = size
        model.pieSegments.append(segmentToAdd)
        model.segmentToAdd = nil
    }
}
