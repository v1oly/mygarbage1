import Foundation

struct PieChartModel {
    var diagramSize: Double = 0.4
    var segmentToAdd: Segment?
    var nameOfSegmentToDelete: String?
        
    var pieSegments = [
        Segment(color: .red, value: 57, title: "Red"),
        Segment(color: .lightBlue, value: 30, title: "Blue"),
        Segment(color: .lightGreen, value: 25, title: "Green"),
        Segment(color: .yellow, value: 40, title: "Yellow")
    ]
}

struct Segment {
    var color: SegmentColor
    var value: Double
    var title: String
}

enum SegmentColor: Comparable {
    case red
    case yellow
    case white
    case gray1
    case gray2
    case gray3
    case gray4
    case black
    case lightBlue
    case darkBlue
    case pink
    case darkGreen
    case lightGreen
    case orange
}
