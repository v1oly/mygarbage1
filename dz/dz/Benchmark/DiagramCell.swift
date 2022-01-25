import UIKit

class DiagramCell: UICollectionViewCell {
    var myTimer1 = Timer()
    var myTimer2 = Timer()
    let pauseUnpauseButton = UIButton()
    let invalidateButton = UIButton()
   
    private var segments: [CellSegment] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.black
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setNeedsDisplay()
    }
    
    func setup() {
        isOpaque = false
        
        pauseUnpauseButton.addTarget(self, action: #selector(setOrPauseTimer(_:)), for: .touchUpInside)
        pauseUnpauseButton.frame.size = CGSize(width: 100, height: 50)
        self.addSubview(pauseUnpauseButton)
        pauseUnpauseButton.frame.origin = CGPoint(x: 30, y: 0)
        pauseUnpauseButton.setTitle(">", for: .normal)
        pauseUnpauseButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        pauseUnpauseButton.sizeToFit()
        pauseUnpauseButton.setTitleColor(.black, for: .normal)
        pauseUnpauseButton.contentHorizontalAlignment = .center
        pauseUnpauseButton.backgroundColor = .clear
        
        invalidateButton.addTarget(self, action: #selector(invalidateAll(_:)), for: .touchUpInside)
        invalidateButton.frame.size = CGSize(width: 100, height: 50)
        self.addSubview(invalidateButton)
        invalidateButton.frame.origin = CGPoint(x: 0, y: pauseUnpauseButton.frame.origin.y + 50)
        invalidateButton.setTitle("Reset all", for: .normal)
        invalidateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        invalidateButton.sizeToFit()
        invalidateButton.setTitleColor(.black, for: .normal)
        invalidateButton.contentHorizontalAlignment = .center
        invalidateButton.backgroundColor = .clear
        
        segments = [
            CellSegment(color: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), value: 1, title: "Run - 00:00:00"),
            CellSegment(color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), value: 0, title: "Pause - 00:00:00")
        ]
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        let radius = min(frame.width, frame.height) * 0.5
        let textPositionOffset: CGFloat = 0.67
        let viewCenter = bounds.center
        
        let totalSegmentsValue = segments.reduce(0) { $0 + $1.value }
        var startAngle = -CGFloat.pi * 0.5
        
        for segment in segments {
            context.setFillColor(segment.color.cgColor)
            
            let endAngle = startAngle + 2 * .pi * (segment.value / totalSegmentsValue)
            context.move(to: viewCenter)
            context.addArc(
                center: viewCenter,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            context.fillPath()
            
            context.move(to: viewCenter)
            context.addLine(to: CGPoint(center: viewCenter, radius: radius, degrees: endAngle))
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.strokePath()
            
            let halfAngle = startAngle + (endAngle - startAngle) * 0.5
            let segmentCenter = viewCenter.projected(by: radius * textPositionOffset, angle: halfAngle)
            let textToRender = segment.title
            let renderRect = CGRect(centeredOn: segmentCenter, size: textToRender.size(withAttributes: textAttributes))
            textToRender.draw(in: renderRect, withAttributes: textAttributes)
            
            startAngle = endAngle
        }
    }
    
    func setTimer(invalidate: Bool) {
        if !invalidate {
            myTimer1 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                segments[0].value += 1
                segments[0].title = "Run - \(countdown(count: Int(segments[0].value - 1)))"
                if myTimer2.isValid { myTimer2.invalidate() }
            }
        } else {
            myTimer1.invalidate()
            myTimer2 = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
                segments[1].value += 1
                segments[1].title = "Pause - \(countdown(count: Int(segments[1].value)))"
            }
        }
    }
    
    @objc
    func setOrPauseTimer(_ sender: UIButton) {
        if pauseUnpauseButton.currentTitle == ">" {
            pauseUnpauseButton.setTitle("||", for: .normal)
            setTimer(invalidate: false)
        } else {
            pauseUnpauseButton.setTitle(">", for: .normal)
            setTimer(invalidate: true)
        }
        setNeedsDisplay()
    }
    
    @discardableResult
    @objc
    func countdown(count: Int) -> String {
        var hours: Int
        var minutes: Int
        var seconds: Int
 
        hours = count / 3_600
        minutes = (count % 3_600) / 60
        seconds = (count % 3_600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    
    @objc
    func invalidateAll(_ sender: UIButton) {
        myTimer1.invalidate()
        myTimer2.invalidate()
        segments[0].value = 1
        segments[1].value = 0
        segments[0].title = "Run - 00:00:00"
        segments[1].title = "Pause - 00:00:00"
        pauseUnpauseButton.setTitle(">", for: .normal)
        setNeedsDisplay()
    }
}

private struct CellSegment {
    let color: UIColor
    var value: CGFloat
    var title: String
}
