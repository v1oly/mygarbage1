import UIKit

class PieChartView: UIView {
    
    private var radius: CGFloat = 150.0
    
    private let addSegment = UIButton()
    private let selectPieToDelete = UIButton()
    private let confirmDelete = UIButton()
    private let drawByRadiusButton = UIButton()
    
    private let stepperRadious = UIStepper()
    private let stepperRadiusValueLabel = UILabel()
    private let deleteSegmentTextField = UITextField()
    var pieSegments: [Segment] = [] // кажется можно было бы и не делать эту переменную открытой, а кидать данные через кложер, но я нашел сложным так обновлять данные для вьюхи
    
    var onAddSegment: () -> ()
    var onDeletePie: () -> ()
    var onSelectPie: () -> ()
    
    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.black
    ]
    
    init(
        onAddSegment: @escaping () -> (),
        onDeletePie: @escaping () -> (),
        onSelectPie: @escaping () -> ()
    ) {
        self.onAddSegment = onAddSegment
        self.onDeletePie = onDeletePie
        self.onSelectPie = onSelectPie
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
        
        let totalSegmentsValue = pieSegments.reduce(0) { $0 + $1.value }
        var startAngle = -CGFloat.pi * 0.5
        
        for segment in pieSegments {
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
    
    override func layoutSubviews() { // я подумал, мб не стоит иметь так много привязок к кордам других элементов, чтобы в случае чего все не рухнуло как карточный домик, пример вот был че со степер велью
        super.layoutSubviews()
        
        drawByRadiusButton.frame.size = CGSize(width: 100, height: 50)
        drawByRadiusButton.frame.origin = CGPoint(
            x: bounds.minX + 100,
            y: bounds.minY + 100
        )
        
        stepperRadious.frame.size = CGSize(width: 100, height: 30)
        stepperRadious.frame.origin = CGPoint(
            x: drawByRadiusButton.frame.origin.x - 100,
            y: drawByRadiusButton.frame.origin.y + 20
        )

        stepperRadiusValueLabel.frame.size = CGSize(width: 100, height: 30)
        stepperRadiusValueLabel.frame.origin = CGPoint(
            x: stepperRadious.frame.origin.x,
            y: stepperRadious.frame.origin.y - 30
        )
        
        selectPieToDelete.frame.size = CGSize(width: 175, height: 35)
        selectPieToDelete.frame.origin = CGPoint(
            x: 210,
            y: 110
        )
        
        addSegment.frame.size = CGSize(width: 100, height: 50)
        addSegment.frame.origin = CGPoint(
            x: UIScreen.main.bounds.minX + 100,
            y: UIScreen.main.bounds.minY + 150
        )
        addSegment.sizeToFit()
        
        confirmDelete.frame.size = CGSize(width: 100, height: 50)
        confirmDelete.frame.origin = CGPoint(
            x: selectPieToDelete.frame.origin.x + 45,
            y: selectPieToDelete.frame.origin.y + 40
        )
        confirmDelete.sizeToFit()
    }
    
    func setSelectPieButtonTitle(_ selectedValue: String) {
        selectPieToDelete.setTitle(selectedValue, for: .normal)
    }
    
    private func setup() {
        
        isOpaque = true
        
        drawByRadiusButton.addTarget(self, action: #selector(drawRadiusDiagram(_:)), for: .touchUpInside)
        drawByRadiusButton.setTitle("Set Radius", for: .normal)
        drawByRadiusButton.setTitleColor(.black, for: .normal)
        drawByRadiusButton.contentHorizontalAlignment = .center
        drawByRadiusButton.backgroundColor = .clear
        self.addSubview(drawByRadiusButton)
        
        stepperRadiusValueLabel.text = "Radius: 0"
        self.addSubview(stepperRadiusValueLabel)
        
        stepperRadious.wraps = true
        stepperRadious.autorepeat = true
        stepperRadious.maximumValue = 1
        stepperRadious.minimumValue = 0
        stepperRadious.stepValue = 0.05
        stepperRadious.addTarget(self, action: #selector(stepperRadiusValueChanged(_:)), for: .valueChanged)
        stepperRadious.backgroundColor = .lightGray
        self.addSubview(stepperRadious)
        
        selectPieToDelete.addTarget(self, action: #selector(selectPieToDelete(_:)), for: .touchUpInside)
        selectPieToDelete.setTitle("Select Pie To Delete", for: .normal)
        selectPieToDelete.setTitleColor(.black, for: .normal)
        selectPieToDelete.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        selectPieToDelete.contentHorizontalAlignment = .center
        self.addSubview(selectPieToDelete)
        
        addSegment.addTarget(self, action: #selector(addSegmentToDiagram(_:)), for: .touchUpInside)
        addSegment.setTitle("Add Segment", for: .normal)
        addSegment.setTitleColor(.black, for: .normal)
        addSegment.backgroundColor = .clear
        addSegment.contentHorizontalAlignment = .center
        self.addSubview(addSegment)
        
        confirmDelete.addTarget(self, action: #selector(deletePie(_:)), for: .touchUpInside)
        confirmDelete.setTitle("Delete Pie", for: .normal)
        confirmDelete.setTitleColor(.black, for: .normal)
        confirmDelete.backgroundColor = .clear
        confirmDelete.contentHorizontalAlignment = .center
        self.addSubview(confirmDelete)
    }
    
    @objc
    private func drawRadiusDiagram(_ sender: UIButton) {
        let radiusC = stepperRadious.value
        radius = min(frame.width, frame.height) * CGFloat(radiusC)
        setNeedsDisplay()
    }
    
    @objc
    private func stepperRadiusValueChanged(_ stepper: UIStepper) {
        let stepValue = Double(stepper.value)
        stepperRadiusValueLabel.text = "Radius: \(round(stepValue * 100) / 100)"
        stepperRadiusValueLabel.sizeToFit()
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
