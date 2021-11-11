import UIKit

struct Segment {
    let color: UIColor
    let value: CGFloat
    let title: String
}

@IBDesignable
class PieChartView: UIView {
    
    var radius: CGFloat = 0.0
    let submitChangesButton = UIButton()
    let radiusField = UITextField()
    
    var segments: [Segment] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.black
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        buttonSetup()
        fieldsSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        buttonSetup()
        fieldsSetup()
    }
    
    override func prepareForInterfaceBuilder() {
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
    
        let textPositionOffset: CGFloat = 0.67
        let viewCenter = bounds.center
        
        let totalSegmentsValue = segments.reduce(0, { $0 + $1.value })
        var startAngle = -CGFloat.pi * 0.5
        
        for segment in segments {
            context.setFillColor(segment.color.cgColor)
            
            let endAngle = startAngle + 2 * .pi * (segment.value / totalSegmentsValue)
            context.move(to: viewCenter)
            context.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            context.fillPath()
            
            context.move(to: viewCenter)
            context.addLine(to: CGPoint(center: viewCenter, radius: radius, degrees: endAngle))
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.strokePath()
            
            let halfAngle = startAngle + (endAngle - startAngle) * 0.5
            let segmentCenter = viewCenter.projected(by: radius * textPositionOffset, angle: halfAngle)
            let textToRender = segment.title as NSString
            let renderRect = CGRect(centeredOn: segmentCenter, size: textToRender.size(withAttributes: textAttributes))
            textToRender.draw(in: renderRect, withAttributes: textAttributes)
            
            startAngle = endAngle
        }
    }
    private func setup() {
        isOpaque = false
        
        segments = [
            Segment(color: .red, value: 57, title: "Red"),
            Segment(color: .blue, value: 30, title: "Blue"),
            Segment(color: .green, value: 25, title: "Green"),
            Segment(color: .yellow, value: 40, title: "Yellow")
        ]
    }
    func buttonSetup() {
        submitChangesButton.addTarget(self, action: #selector(showSelectionViewController(_:)), for: .touchUpInside)
        submitChangesButton.frame.size = CGSize(width: 100, height: 50)
        self.addSubview(submitChangesButton)
        submitChangesButton.frame.origin = CGPoint(x: UIScreen.main.bounds.width - 100,
                                                   y: UIScreen.main.bounds.minY + 100)
        submitChangesButton.setTitle("Submit", for: .normal)
        submitChangesButton.setTitleColor(.black, for: .normal)
        submitChangesButton.contentHorizontalAlignment = .center
        submitChangesButton.backgroundColor = .white
    }
    
    func fieldsSetup() {
        radiusField.frame.size = CGSize(width: 100, height: 30)
        self.addSubview(radiusField)
        radiusField.frame.origin = CGPoint(x: submitChangesButton.frame.origin.x - 100,
                                           y: submitChangesButton.frame.origin.y + 20)
        radiusField.backgroundColor = .lightGray
    }
    
    @objc
    func showSelectionViewController(_ sender: UIButton) {
        guard let num = NumberFormatter().number(from: radiusField.text!) else { return }
        let radiusC = CGFloat(num)
        radius = min(frame.width, frame.height) * radiusC
        setNeedsDisplay()
    }
}

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
                x: center.x - size.width * 0.5, y: center.y - size.height * 0.5
            ),
            size: size
        )
    }
}