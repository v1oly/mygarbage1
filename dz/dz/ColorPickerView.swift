import UIKit


class ColorPickerView : UIView {

var onColorDidChange: ((_ color: UIColor) -> ())?

let saturationExponentTop:Float = 2.0
let saturationExponentBottom:Float = 1.3

let grayPaletteHeightFactor: CGFloat = 0.1
var rectgrayPalette = CGRect.zero
var rectmainPalette = CGRect.zero

// adjustable
var elementSize: CGFloat = 1.0 {
    didSet {
        setNeedsDisplay()
    }
}

override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
}

private func setup() {

    self.clipsToBounds = true
    let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
    touchGesture.minimumPressDuration = 0
    touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
    self.addGestureRecognizer(touchGesture)
}



override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()

    rectgrayPalette = CGRect(x: 0, y: 0, width: rect.width, height: rect.height * grayPaletteHeightFactor)
    rectmainPalette = CGRect(x: 0, y: rectgrayPalette.maxY,
                              width: rect.width, height: rect.height - rectgrayPalette.height)

    // gray palette
    for yyy in stride(from: CGFloat(0), to: rectgrayPalette.height, by: elementSize) {

        for xxx in stride(from: (0 as CGFloat), to: rectgrayPalette.width, by: elementSize) {
            let hue = xxx / rectgrayPalette.width

            let color = UIColor(white: hue, alpha: 1.0)

            context!.setFillColor(color.cgColor)
            context!.fill(CGRect(x:xxx, y:yyy, width:elementSize, height:elementSize))
        }
    }

    // main palette
    for yyy in stride(from: CGFloat(0), to: rectmainPalette.height, by: elementSize) {

        var saturation = yyy < rectmainPalette.height / 2.0 ? CGFloat(2 * yyy) / rectmainPalette.height : 2.0 * CGFloat(rectmainPalette.height - yyy) / rectmainPalette.height
        saturation = CGFloat(powf(Float(saturation), yyy < rectmainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = yyy < rectmainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rectmainPalette.height - yyy) / rectmainPalette.height

        for xxx in stride(from: (0 as CGFloat), to: rectmainPalette.width, by: elementSize) {
            let hue = xxx / rectmainPalette.width

            let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)

            context!.setFillColor(color.cgColor)
            context!.fill(CGRect(x:xxx, y: yyy + rectmainPalette.origin.y,
                                 width: elementSize, height: elementSize))
        }
    }
}



func getColorAtPoint(point: CGPoint) -> UIColor
{
    var roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                               y:elementSize * CGFloat(Int(point.y / elementSize)))

    let hue = roundedPoint.x / self.bounds.width


    // main palette
    if rectmainPalette.contains(point)
    {
        // offset point, because rect_mainPalette.origin.y is not 0
        roundedPoint.y -= rectmainPalette.origin.y

        var saturation = roundedPoint.y < rectmainPalette.height / 2.0 ? CGFloat(2 * roundedPoint.y) / rectmainPalette.height
            : 2.0 * CGFloat(rectmainPalette.height - roundedPoint.y) / rectmainPalette.height

        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < rectmainPalette.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < rectmainPalette.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rectmainPalette.height - roundedPoint.y) / rectmainPalette.height

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    // gray palette
    else{

        return UIColor(white: hue, alpha: 1.0)
    }
}


@objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
    let point = gestureRecognizer.location(in: self)
    let color = getColorAtPoint(point: point)

    self.onColorDidChange?(color)
  }
}
