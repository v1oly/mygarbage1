import Foundation
import UIKit

class PieChartModel {
    var arrayOfSegmentNames: [String] = [""] // мб можно было бы венести эти данные как отдельную структуру и потом ее вынести в случае необходимости,хотя мб этот метод говно ведь постоянно создавать копии структуры при изменении 1 переменной такое себе.
    var pickedColor: UIColor = UIColor.clear
    var pickedValue: String = ""
    var pieLable: String = ""
    var pieStepperValue: Double = 0.0
    
    var pieSegments = [
        Segment(color: .red, value: 57, title: "Red"),
        Segment(color: .blue, value: 30, title: "Blue"),
        Segment(color: .green, value: 25, title: "Green"),
        Segment(color: .yellow, value: 40, title: "Yellow")
    ] {
        didSet {
            arrayOfSegmentNames = updateArrayOfNames()
        }
    }
    
    init() {
        arrayOfSegmentNames = updateArrayOfNames()
    }
    
    @discardableResult
    func updateArrayOfNames() -> [String] {
        var array = [String]()
        for segment in pieSegments {
            let title = segment.title
            array.append(title)
        }
        return array
    }
}

struct Segment {
    let color: UIColor
    var value: CGFloat
    var title: String
}
