import UIKit

class SetViewController: UIViewController {
    
    let slider = UISlider()
    let numberOfItemsLabel = UILabel()
    let step: Float = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY)
        view.backgroundColor = .white
        
        slider.frame.size = CGSize(width: UIScreen.main.bounds.width / 1.2, height: 200)
        slider.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.minY + 200)
        slider.maximumValue = 1_000_000
        slider.minimumValue = 1
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        view.addSubview(slider)
        
        numberOfItemsLabel.frame.size = CGSize(width: 250, height: 50)
        numberOfItemsLabel.text = "Number of Items: \(Int(slider.value))"
        numberOfItemsLabel.sizeToFit()
        numberOfItemsLabel.center = CGPoint(x: slider.center.x, y: slider.center.y - 50)
        view.addSubview(numberOfItemsLabel)
    }
    
    @objc
    func sliderValueDidChange(_ sender: UISlider) {
        let step: Float = 1
        let currentValue = round(sender.value / step) * step
        numberOfItemsLabel.text = "Number of Items: \(Int(currentValue))"
        numberOfItemsLabel.sizeToFit()
        numberOfItemsLabel.center = CGPoint(x: slider.center.x, y: slider.center.y - 50)
    }
}
