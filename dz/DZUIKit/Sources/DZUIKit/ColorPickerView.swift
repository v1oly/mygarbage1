import UIKit

public class ColorPickerView: UIView {
   
    private let colorsArray = [#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)]
    private var arrayOfButtons = [UIButton]()
    private var pickedColor = UIColor.clear
    private let closure: (UIColor) -> ()
    
    public init(closure: @escaping (UIColor) -> ()) {
        self.closure = closure
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
  
    private func setup() {
        self.frame = CGRect(x: 0, y: UIScreen.main.bounds.maxY - 250, width: UIScreen.main.bounds.maxX, height: 100)
        self.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.layer.cornerRadius = 10
        
        drawColorsBlocks()
    }
    
    private func drawColorsBlocks() {
        for index in colorsArray.indices {
        let boxButton = UIButton()
            boxButton.frame.size = CGSize(width: 20, height: 20)
            boxButton.center = CGPoint(x: 27 * (index + 1), y: Int(self.bounds.midY))
            boxButton.addTarget(self, action: #selector(colorPeek(_:)), for: .touchUpInside)
            boxButton.backgroundColor = colorsArray[index]
            addSubview(boxButton)
            arrayOfButtons += [boxButton]
        }
    }
    
    @objc
    private func colorPeek(_ sender: UIButton) {
        pickedColor = sender.backgroundColor! // swiftlint:disable:this force_unwrapping
        closure(pickedColor)
    }
}
