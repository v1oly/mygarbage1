import UIKit

class PieChartView: UIView {
    
    private var diagramRadius: CGFloat = 150.0
    private var currentSegments: [ViewSegment] = []
    
    private let addSegmentButton = UIButton()
    private let selectPieToDeleteButton = UIButton()
    private let confirmDeleteButton = UIButton()
    private let drawByRadiusButton = UIButton()
    private let diagramRadiusStepper = UIStepper()
    private let diagramRadiusLabel = UILabel()
    
    private var onAddSegment: () -> ()
    private var onDeletePie: () -> ()
    private var onSelectPie: () -> ()
    private var onRadiusChange: (CGFloat) -> ()
    
    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.black
    ]
    
    init(
        onAddSegment: @escaping () -> (),
        onDeletePie: @escaping () -> (),
        onSelectPie: @escaping () -> (),
        onRadiusChange: @escaping (CGFloat) -> ()
    ) {
        self.onAddSegment = onAddSegment
        self.onDeletePie = onDeletePie
        self.onSelectPie = onSelectPie
        self.onRadiusChange = onRadiusChange
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Required coder not founded!")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let textPositionOffset: CGFloat = 0.67
        let viewCenter = bounds.center
        
        let totalSegmentsValue = currentSegments.reduce(0) { $0 + $1.value }
        var startAngle = -CGFloat.pi * 0.5
        
        for segment in currentSegments {
            context.setFillColor(segment.color.cgColor)
            
            let endAngle = startAngle + 2 * .pi * (segment.value / totalSegmentsValue)
            context.move(to: viewCenter)
            context.addArc(
                center: viewCenter,
                radius: diagramRadius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            context.fillPath()
            
            context.move(to: viewCenter)
            context.addLine(to: CGPoint(center: viewCenter, radius: diagramRadius, degrees: endAngle))
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(2)
            context.strokePath()
            
            let halfAngle = startAngle + (endAngle - startAngle) * 0.5
            let segmentCenter = viewCenter.projected(by: diagramRadius * textPositionOffset, angle: halfAngle)
            let textToRender = segment.title
            let renderRect = CGRect(centeredOn: segmentCenter, size: textToRender.size(withAttributes: textAttributes))
            textToRender.draw(in: renderRect, withAttributes: textAttributes)
            
            startAngle = endAngle
        }
    }
    
    override func layoutSubviews() { 
        super.layoutSubviews()
        
        drawByRadiusButton.frame.size = CGSize(width: 100, height: 50)
        drawByRadiusButton.frame.origin = CGPoint(
            x: bounds.minX + 100,
            y: bounds.minY + 100
        )
        
        diagramRadiusStepper.frame.size = CGSize(width: 100, height: 30)
        diagramRadiusStepper.frame.origin = CGPoint(
            x: drawByRadiusButton.frame.origin.x - 100,
            y: drawByRadiusButton.frame.origin.y + 20
        )

        diagramRadiusLabel.frame.size = CGSize(width: 100, height: 30)
        diagramRadiusLabel.frame.origin = CGPoint(
            x: diagramRadiusStepper.frame.origin.x,
            y: diagramRadiusStepper.frame.origin.y - 30
        )
        
        selectPieToDeleteButton.frame.size = CGSize(width: 175, height: 35)
        selectPieToDeleteButton.frame.origin = CGPoint(
            x: 210,
            y: 110
        )
        
        addSegmentButton.frame.size = CGSize(width: 100, height: 50)
        addSegmentButton.frame.origin = CGPoint(
            x: UIScreen.main.bounds.minX + 100,
            y: UIScreen.main.bounds.minY + 150
        )
        addSegmentButton.sizeToFit()
        
        confirmDeleteButton.frame.size = CGSize(width: 100, height: 50)
        confirmDeleteButton.frame.origin = CGPoint(
            x: selectPieToDeleteButton.frame.origin.x + 45,
            y: selectPieToDeleteButton.frame.origin.y + 40
        )
        confirmDeleteButton.sizeToFit()
    }
    
    func setPieSelectionTitle(_ selectedValue: String) {
        selectPieToDeleteButton.setTitle(selectedValue, for: .normal)
    }
    
    func updatePieSegments(segments: [ViewSegment]) {
        currentSegments = segments
        setNeedsDisplay()
    }
    
    func updateDiagram(size: CGFloat) {
        diagramRadius = min(frame.width, frame.height) * size
        setNeedsDisplay()
    }
    
    private func setup() {
        drawByRadiusButton.addTarget(self, action: #selector(drawRadiusDiagram(_:)), for: .touchUpInside)
        drawByRadiusButton.setTitle("Set Radius", for: .normal)
        drawByRadiusButton.setTitleColor(.black, for: .normal)
        drawByRadiusButton.contentHorizontalAlignment = .center
        drawByRadiusButton.backgroundColor = .clear
        self.addSubview(drawByRadiusButton)
        
        diagramRadiusLabel.text = "Radius: 0"
        self.addSubview(diagramRadiusLabel)
        
        diagramRadiusStepper.wraps = true
        diagramRadiusStepper.autorepeat = true
        diagramRadiusStepper.maximumValue = 1
        diagramRadiusStepper.minimumValue = 0
        diagramRadiusStepper.stepValue = 0.05
        diagramRadiusStepper.addTarget(self, action: #selector(updateDiagramRadiusText(_:)), for: .valueChanged)
        diagramRadiusStepper.backgroundColor = .lightGray
        self.addSubview(diagramRadiusStepper)
        
        selectPieToDeleteButton.addTarget(self, action: #selector(selectPieToDelete(_:)), for: .touchUpInside)
        selectPieToDeleteButton.setTitle("Select Pie To Delete", for: .normal)
        selectPieToDeleteButton.setTitleColor(.black, for: .normal)
        selectPieToDeleteButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        selectPieToDeleteButton.contentHorizontalAlignment = .center
        self.addSubview(selectPieToDeleteButton)
        
        addSegmentButton.addTarget(self, action: #selector(addSegmentToDiagram(_:)), for: .touchUpInside)
        addSegmentButton.setTitle("Add Segment", for: .normal)
        addSegmentButton.setTitleColor(.black, for: .normal)
        addSegmentButton.backgroundColor = .clear
        addSegmentButton.contentHorizontalAlignment = .center
        self.addSubview(addSegmentButton)
        
        confirmDeleteButton.addTarget(self, action: #selector(deletePie(_:)), for: .touchUpInside)
        confirmDeleteButton.setTitle("Delete Pie", for: .normal)
        confirmDeleteButton.setTitleColor(.black, for: .normal)
        confirmDeleteButton.backgroundColor = .clear
        confirmDeleteButton.contentHorizontalAlignment = .center
        self.addSubview(confirmDeleteButton)
    }
    
    @objc
    private func drawRadiusDiagram(_ sender: UIButton) {
        onRadiusChange(diagramRadius)
    }
    
    @objc
    private func updateDiagramRadiusText(_ stepper: UIStepper) {
        diagramRadius = round(Double(stepper.value) * 100) / 100
        diagramRadiusLabel.text = "Radius: \(diagramRadius)"
        diagramRadiusLabel.sizeToFit()
    }
    
    @objc
    private func addSegmentToDiagram(_ sender: UIButton) {
        onAddSegment()
    }
    
    @objc
    private func selectPieToDelete(_ sender: UIButton) {
        onSelectPie()
    }
    
    @objc
    private func deletePie(_ sender: UIButton) {
        onDeletePie()
    }
}
