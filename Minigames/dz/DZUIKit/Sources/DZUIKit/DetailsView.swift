import UIKit

public class DetailsView: UIView {
    private let quitButton = UIButton()
    private let openColorPickerButton = UIButton()
    private let addPieButton = UIButton()
    private let colorPickerHeader = UILabel()
    private let pieNameHeader = UILabel()
    private let pieSizeHeader = UILabel()
    private let pieNameTextField = UITextField()
    private let pieSizeStepper = UIStepper()
    
    private let onDismiss: () -> ()
    private let onOpenColorPicker: () -> ()
    private let onAddPie: (_ name: String, _ size: CGFloat) -> ()
    
    public init(
        onDismiss: @escaping () -> (),
        onOpenColorPicker: @escaping () -> (),
        onAddPie:  @escaping (_ name: String, _ size: CGFloat) -> ()
    ) {
        self.onDismiss = onDismiss
        self.onOpenColorPicker = onOpenColorPicker
        self.onAddPie = onAddPie
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Error")
    }
    
    public func setSelected(color: UIColor) {
        openColorPickerButton.setTitleColor(color, for: .normal)
    }
    
    override public func layoutSubviews() {
        quitButton.frame.size = CGSize(width: 100, height: 50)
        quitButton.frame.origin = CGPoint(
            x: bounds.minX,
            y: bounds.minY
        )
        quitButton.sizeToFit()
        
        openColorPickerButton.frame.size = CGSize(width: 100, height: 100)
        openColorPickerButton.center = CGPoint(
            x: 125,
            y: bounds.midY - 35
        )
        
        openColorPickerButton.sizeToFit()
        
        addPieButton.frame.size = CGSize(width: 100, height: 100)
        addPieButton.center = CGPoint(
            x: self.bounds.midX + 55,
            y: self.bounds.midY + 25
        )
        addPieButton.sizeToFit()
        
        pieNameTextField.frame.size = CGSize(width: 200, height: 25)
        pieNameTextField.frame.origin = CGPoint(
            x: openColorPickerButton.frame.origin.x + 100,
            y: openColorPickerButton.frame.origin.y + 18
        )
        
        pieSizeStepper.frame.size = CGSize(width: 100, height: 30)
        pieSizeStepper.frame.origin = CGPoint(
            x: openColorPickerButton.frame.origin.x - 20,
            y: openColorPickerButton.frame.origin.y + 70
        )
        
        colorPickerHeader.frame.size = CGSize(width: 100, height: 25)
        colorPickerHeader.frame.origin = CGPoint(
            x: openColorPickerButton.frame.origin.x - 16,
            y: openColorPickerButton.frame.origin.y - 10
        )
        colorPickerHeader.sizeToFit()
        
        pieNameHeader.frame.size = CGSize(width: 100, height: 25)
        pieNameHeader.frame.origin = CGPoint(
            x: colorPickerHeader.frame.origin.x + 160,
            y: openColorPickerButton.frame.origin.y - 10
        )
        pieNameHeader.sizeToFit()
        
        pieSizeHeader.frame.size = CGSize(width: 100, height: 30)
        pieSizeHeader.frame.origin = CGPoint(
            x: pieSizeStepper.frame.origin.x,
            y: pieSizeStepper.frame.origin.y - 20
        )
        pieSizeHeader.sizeToFit()
    }
    
    private func setup() {
        self.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.maxX, height: 200)
        
        quitButton.addTarget(self, action: #selector(dismissView(_:)), for: .touchUpInside)
        quitButton.setTitle("Esc", for: .normal)
        quitButton.setTitleColor(.black, for: .normal)
        quitButton.contentHorizontalAlignment = .center
        quitButton.backgroundColor = .clear
        self.addSubview(quitButton)
        
        openColorPickerButton.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
        openColorPickerButton.setTitle("▣", for: .normal)
        openColorPickerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        openColorPickerButton.setTitleColor(.black, for: .normal)
        openColorPickerButton.contentHorizontalAlignment = .center
        openColorPickerButton.backgroundColor = .clear
        self.addSubview(openColorPickerButton)
        
        addPieButton.addTarget(self, action: #selector(addPie(_:)), for: .touchUpInside)
        addPieButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        addPieButton.setTitle("Add Pie", for: .normal)
        addPieButton.setTitleColor(.black, for: .normal)
        addPieButton.contentHorizontalAlignment = .center
        addPieButton.backgroundColor = .clear
        self.addSubview(addPieButton)
        
        pieNameTextField.backgroundColor = #colorLiteral(red: 0.9054492116, green: 0.9000669122, blue: 0.909586668, alpha: 1).withAlphaComponent(0.6)
        self.addSubview(pieNameTextField)
        
        pieSizeStepper.wraps = true
        pieSizeStepper.autorepeat = true
        pieSizeStepper.maximumValue = 100
        pieSizeStepper.minimumValue = 1
        pieSizeStepper.stepValue = 1
        pieSizeStepper.addTarget(self, action: #selector(pieSizeStepperChange(_:)), for: .valueChanged)
        pieSizeStepper.backgroundColor = .lightGray
        self.addSubview(pieSizeStepper)
        
        colorPickerHeader.text = "Set Color"
        colorPickerHeader.backgroundColor = .clear
        self.addSubview(colorPickerHeader)
        
        pieNameHeader.text = "Set text to pie"
        pieNameHeader.backgroundColor = .clear
        self.addSubview(pieNameHeader)
        
        pieSizeHeader.text = "Pie Value:1"
        self.addSubview(pieSizeHeader)
        
        openColorPickerButton.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
        addSubview(openColorPickerButton)
        
        setGradientBackground()
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
    private func dismissView(_ sender: UIButton) {
        onDismiss()
    }
    
    @objc
    private func selectColor(_ sender: UIButton) {
        onOpenColorPicker()
    }
    
    @objc
    private func addPie(_ sender: UIButton) {
        guard pieNameTextField.text?.isEmpty != true else {
            return
        }
        
        onAddPie(
            pieNameTextField.text ?? "",
            pieSizeStepper.value
        )
    }
    
    @objc
    private func pieSizeStepperChange(_ sender: UIButton) {
        let stepValue = Int(pieSizeStepper.value)
        pieSizeHeader.text = "Pie Value:\(stepValue)"
        pieSizeHeader.sizeToFit()
    }
}
