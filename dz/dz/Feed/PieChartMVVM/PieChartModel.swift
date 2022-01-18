import Foundation
import UIKit.UIColor

class PieChartModel {
    var arrayOfSegmentNames: [String] = ["Red", "Blue", "Green", "Yellow"]
    var pickedColor: UIColor = UIColor.clear
    var pickedSegment: String = ""
    var pieName: String = ""
    var diagramSize: Double = 0.0
    
    var onPieSegmentsDidSet: () -> ()
    
    var pieSegments = [
        Segment(color: .red, value: 57, title: "Red"),
        Segment(color: .blue, value: 30, title: "Blue"),
        Segment(color: .green, value: 25, title: "Green"),
        Segment(color: .yellow, value: 40, title: "Yellow")
    ] {
        didSet {
            onPieSegmentsDidSet()
        }
    }
    
    init(onPieSegmentsDidSet: @escaping () -> ()) {
        self.onPieSegmentsDidSet = onPieSegmentsDidSet
    }
}

struct Segment {
    let color: UIColor
    var value: CGFloat
    var title: String
}
