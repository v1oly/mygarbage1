import UIKit

public class DetailsView: UIView {
    
    private let quitButton = UIButton()
    public let selectColorButton = UIButton()
    private let submitPieAdd = UIButton()
    private let colorPickerLabel = UILabel()
    private let setTextToSegmentFieldLabel = UILabel()
    private let pieValueStepperLabel = UILabel()
    public let setTextToSegmentField = UITextField()
    public let pieValueStepper = UIStepper()

    private let onQuitFromView: () -> ()
    private let onSelectColor: () -> ()
    private let onSubmitPieAdd: () -> ()
    
    public init(
        onQuitFromView: @escaping () -> (),
        onSelectColor: @escaping () -> (),
        onSubmitPieAdd:  @escaping () -> ()
    ) {
        self.onQuitFromView = onQuitFromView
        self.onSelectColor = onSelectColor
        self.onSubmitPieAdd = onSubmitPieAdd
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    override public func layoutSubviews() {
        self.frame = CGRect(x: 0, y: 100, width: bounds.maxX, height: 200)
        quitButton.frame.size = CGSize(width: 100, height: 50)
        quitButton.frame.origin = CGPoint(
            x: self.bounds.minX,
            y: self.bounds.minY
        )
        
        selectColorButton.frame.size = CGSize(width: 100, height: 100)
        selectColorButton.center = CGPoint(
            x: 125,
            y: self.bounds.midY - 35
        )
        
        submitPieAdd.frame.size = CGSize(width: 100, height: 100)
        submitPieAdd.center = CGPoint(
            x: self.bounds.midX + 55,
            y: self.bounds.midY + 25
        )
        
        setTextToSegmentField.frame.size = CGSize(width: 200, height: 25)
        setTextToSegmentField.frame.origin = CGPoint(
            x: selectColorButton.frame.origin.x + 100,
            y: selectColorButton.frame.origin.y + 18
        )
        
        pieValueStepper.frame.size = CGSize(width: 100, height: 30)
        pieValueStepper.frame.origin = CGPoint(
            x: selectColorButton.frame.origin.x - 20,
            y: selectColorButton.frame.origin.y + 70
        )
    }
    
    private func setup() { 
        
        quitButton.addTarget(self, action: #selector(quitFromView(_:)), for: .touchUpInside)
        addSubview(quitButton)
        quitButton.setTitle("Esc", for: .normal)
        quitButton.sizeToFit()
        quitButton.setTitleColor(.black, for: .normal)
        quitButton.contentHorizontalAlignment = .center
        quitButton.backgroundColor = .clear
        
        selectColorButton.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
        addSubview(selectColorButton)
        selectColorButton.setTitle("▣", for: .normal)
        selectColorButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        selectColorButton.sizeToFit()
        selectColorButton.setTitleColor(.black, for: .normal)
        selectColorButton.contentHorizontalAlignment = .center
        selectColorButton.backgroundColor = .clear
        
        submitPieAdd.addTarget(self, action: #selector(submitPieAdd(_:)), for: .touchUpInside)
        addSubview(submitPieAdd)
        submitPieAdd.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        submitPieAdd.setTitle("Add Pie", for: .normal)
        submitPieAdd.sizeToFit()
        submitPieAdd.setTitleColor(.black, for: .normal)
        submitPieAdd.contentHorizontalAlignment = .center
        submitPieAdd.backgroundColor = .clear
        
        addSubview(setTextToSegmentField)
        setTextToSegmentField.backgroundColor = #colorLiteral(red: 0.9054492116, green: 0.9000669122, blue: 0.909586668, alpha: 1).withAlphaComponent(0.6)
        
        addSubview(pieValueStepper)
        pieValueStepper.wraps = true
        pieValueStepper.autorepeat = true
        pieValueStepper.maximumValue = 100
        pieValueStepper.minimumValue = 1
        pieValueStepper.stepValue = 1
        pieValueStepper.addTarget(self, action: #selector(pieValueStepperChange(_:)), for: .valueChanged)
        pieValueStepper.backgroundColor = .lightGray
        
        setupLabel()
        setGradientBackground()
    }
    
    private func setupLabel() {
        colorPickerLabel.frame.size = CGSize(width: 100, height: 25)
        addSubview(colorPickerLabel)
        colorPickerLabel.frame.origin = CGPoint(
            x: selectColorButton.frame.origin.x - 16,
            y: selectColorButton.frame.origin.y - 10
        )
        colorPickerLabel.text = "Set Color"
        colorPickerLabel.sizeToFit()
        colorPickerLabel.backgroundColor = .clear
        
        setTextToSegmentFieldLabel.frame.size = CGSize(width: 100, height: 25)
        addSubview(setTextToSegmentFieldLabel)
        setTextToSegmentFieldLabel.frame.origin = CGPoint(
            x: colorPickerLabel.frame.origin.x + 160,
            y: selectColorButton.frame.origin.y - 10
        )
        setTextToSegmentFieldLabel.text = "Set text to pie"
        setTextToSegmentFieldLabel.sizeToFit()
        setTextToSegmentFieldLabel.backgroundColor = .clear
        
        pieValueStepperLabel.frame.size = CGSize(width: 100, height: 30)
        addSubview(pieValueStepperLabel)
        pieValueStepperLabel.frame.origin = CGPoint(
            x: pieValueStepper.frame.origin.x,
            y: pieValueStepper.frame.origin.y - 20
        )
        pieValueStepperLabel.text = "Pie Value:1"
        pieValueStepperLabel.sizeToFit()
    }
    
    private func setGradientBackground() {
        let colorTop =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.96).cgColor
        let colorBottom =  #colorLiteral(red: 0.9054492116, green: 0.9000669122, blue: 0.909586668, alpha: 1).withAlphaComponent(0.96).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.cornerRadius = 10
    }
    
    @objc
    private func quitFromView(_ sender: UIButton) {
        onQuitFromView()
    }
    
    @objc
    private func selectColor(_ sender: UIButton) {
        onSelectColor()
    }
    @objc
    private func submitPieAdd(_ sender: UIButton) {
        guard !setTextToSegmentField.text!.isEmpty  else { // swiftlint:disable:this force_unwrapping
            return
        }
        onSubmitPieAdd()
    }
    @objc
    private func pieValueStepperChange(_ sender: UIButton) {
        let stepValue = Int(pieValueStepper.value)
        pieValueStepperLabel.text = "Pie Value:\(stepValue)"
        pieValueStepperLabel.sizeToFit()
    }
}
