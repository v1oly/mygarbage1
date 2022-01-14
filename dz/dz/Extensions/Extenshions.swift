import Foundation
import UIKit

extension CGFloat {
    var radiansToDegrees: CGFloat {
        return self * 180 / .pi
    }
}

extension CGPoint {
    init(center: CGPoint, radius: CGFloat, degrees: CGFloat) {
        self.init(
            x: cos(degrees) * radius + center.x,
            y: sin(degrees) * radius + center.y
        )
    }
    
    func projected(by value: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(
            x: x + value * cos(angle), y: y + value * sin(angle)
        )
    }
}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(
            x: width / 2 + origin.x,
            y: height / 2 + origin.y
        )
    }
    
    init(centeredOn center: CGPoint, size: CGSize) {
        self.init(
            origin: CGPoint(
                x: center.x - size.width * 0.5,
                y: center.y - size.height * 0.5
            ),
            size: size
        )
    }
}

