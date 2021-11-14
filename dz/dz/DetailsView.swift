import UIKit

class DetailsView: UIView {
    
    let quitButton = UIButton()
    let selectColorButton = UIButton()
    let colorPicker = ColorPickerView()
    weak var delegate: PieChartDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        self.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.maxX, height: 200)
        
        quitButton.addTarget(self, action: #selector(quitFromView(_:)), for: .touchUpInside)
        quitButton.frame.size = CGSize(width: 100, height: 50)
        addSubview(quitButton)
        quitButton.frame.origin = CGPoint(x: self.bounds.minX,
                                          y: self.bounds.minY)
        quitButton.setTitle("Esc", for: .normal)
        quitButton.sizeToFit()
        quitButton.setTitleColor(.black, for: .normal)
        quitButton.contentHorizontalAlignment = .center
        quitButton.backgroundColor = .clear
        
        selectColorButton.addTarget(self, action: #selector(selectColor(_:)), for: .touchUpInside)
        selectColorButton.frame.size = CGSize(width: 50, height: 50)
        addSubview(selectColorButton)
        selectColorButton.center = CGPoint(x: self.bounds.midX,
                                                 y: self.bounds.midY)
        selectColorButton.setTitle("▣", for: .normal)
        selectColorButton.sizeToFit()
        selectColorButton.setTitleColor(.black, for: .normal)
        selectColorButton.contentHorizontalAlignment = .center
        selectColorButton.backgroundColor = .clear
        
        setGradientBackground()
    }
    
    func setGradientBackground() {
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
    func quitFromView(_ sender: UIButton) {
        delegate?.quitDetailsViewController()
    }
    
    @objc
    func selectColor(_ sender: UIButton) {
        delegate?.openColorPickerView()
    }
}
