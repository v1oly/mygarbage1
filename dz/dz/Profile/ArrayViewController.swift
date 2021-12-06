import UIKit

class ArrayViewController: UIViewController {
    
    let arrayView = ArrayView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = arrayView
    }
}

class ArrayView: UIView { // swiftlint:disable:this type_body_length
    
    let stringGenerator = StringGenerator()
    
    let numberOfItemsLabel = UILabel()
    let resultLable = UILabel()
    let arrayCreateTimeLabel1 = UILabel()
    let arrayCreateTimeLabel2 = UILabel()
    let add1EntryLabel1 = UILabel()
    let add1EntryLabel2 = UILabel()
    let add5EntryLabel1 = UILabel()
    let add5EntryLabel2 = UILabel()
    let add10EntryLabel1 = UILabel()
    let add10EntryLabel2 = UILabel()
    let remove1EntryLabel1 = UILabel()
    let remove1EntryLabel2 = UILabel()
    let remove5EntryLabel1 = UILabel()
    let remove5EntryLabel2 = UILabel()
    let remove10EntryLabel1 = UILabel()
    let remove10EntryLabel2 = UILabel()
    let lookupEntrylabel1 = UILabel()
    let lookupEntrylabel2 = UILabel()
    let lookup10Entrylabel1 = UILabel()
    let lookup10Entrylabel2 = UILabel()
    
    let slider = UISlider()
    let numberFormatter = NumberFormatter()
    let createArrayButton = UIButton()
    
    var arrayOfRandomStrings = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        setupLabels()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        numberOfItemsLabel.sizeToFit()
        numberOfItemsLabel.center = CGPoint(x: slider.center.x, y: slider.center.y - 50)
    }
    
    func setup() {
        
        numberFormatter.numberStyle = .decimal
        
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY)
        self.backgroundColor = .white
        
        slider.frame.size = CGSize(width: UIScreen.main.bounds.width / 1.2, height: 200)
        slider.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.minY + 200)
        slider.maximumValue = 100_000
        slider.minimumValue = 10
        slider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        self.addSubview(slider)
        
        numberOfItemsLabel.frame.size = CGSize(width: 250, height: 50)
        numberOfItemsLabel.text = "Number of Items: \(Int(slider.value))"
        numberOfItemsLabel.sizeToFit()
        numberOfItemsLabel.center = CGPoint(x: slider.center.x, y: slider.center.y - 50)
        self.addSubview(numberOfItemsLabel)
        
        createArrayButton.frame.size = CGSize(width: 200, height: 25)
        createArrayButton.backgroundColor = .clear
        createArrayButton.setTitle("Create array and Test", for: .normal)
        createArrayButton.setTitleColor(.blue, for: .normal)
        createArrayButton.sizeToFit()
        createArrayButton.center = CGPoint(x: slider.center.x, y: slider.center.y + 50)
        createArrayButton.addTarget(self, action: #selector(createArrayAndTest(_:)), for: .touchUpInside)
        self.addSubview(createArrayButton)
    }
    
    func setupLabels() { // swiftlint:disable:this function_body_length
        
        resultLable.frame.size = CGSize(width: 100, height: 25)
        resultLable.text = "Result:"
        resultLable.sizeToFit()
        resultLable.center = CGPoint(x: createArrayButton.center.x, y: createArrayButton.center.y + 50)
        self.addSubview(resultLable)
        
        arrayCreateTimeLabel1.frame.size = CGSize(width: 150, height: 25)
        arrayCreateTimeLabel1.text = "Creating array Time:"
        arrayCreateTimeLabel1.sizeToFit()
        arrayCreateTimeLabel1.frame.origin = CGPoint(x: resultLable.center.x - 150, y: resultLable.center.y + 35)
        self.addSubview(arrayCreateTimeLabel1)
        
        arrayCreateTimeLabel2.frame.size = CGSize(width: 150, height: 25)
        arrayCreateTimeLabel2.text = "0.000000000"
        arrayCreateTimeLabel2.sizeToFit()
        arrayCreateTimeLabel2.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x + arrayCreateTimeLabel1.frame.width + 50,
            y: arrayCreateTimeLabel1.frame.origin.y
        )
        self.addSubview(arrayCreateTimeLabel2)
        
        add1EntryLabel1.frame.size = CGSize(width: 150, height: 25)
        add1EntryLabel1.text = "Add 1 Entry:"
        add1EntryLabel1.sizeToFit()
        add1EntryLabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: arrayCreateTimeLabel1.frame.origin.y + 35
        )
        self.addSubview(add1EntryLabel1)
        
        add1EntryLabel2.frame.size = CGSize(width: 150, height: 25)
        add1EntryLabel2.text = "0.000000000"
        add1EntryLabel2.sizeToFit()
        add1EntryLabel2.frame.origin = CGPoint(
            x: arrayCreateTimeLabel2.frame.origin.x,
            y: add1EntryLabel1.frame.origin.y
        )
        self.addSubview(add1EntryLabel2)
        
        add5EntryLabel1.frame.size = CGSize(width: 150, height: 25)
        add5EntryLabel1.text = "Add 5 Entry:"
        add5EntryLabel1.sizeToFit()
        add5EntryLabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: add1EntryLabel1.frame.origin.y + 35
        )
        self.addSubview(add5EntryLabel1)
        
        add5EntryLabel2.frame.size = CGSize(width: 150, height: 25)
        add5EntryLabel2.text = "0.000000000"
        add5EntryLabel2.sizeToFit()
        add5EntryLabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: add5EntryLabel1.frame.origin.y
        )
        self.addSubview(add5EntryLabel2)
        
        add10EntryLabel1.frame.size = CGSize(width: 150, height: 25)
        add10EntryLabel1.text = "Add 10 Entry:"
        add10EntryLabel1.sizeToFit()
        add10EntryLabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: add5EntryLabel1.frame.origin.y + 35
        )
        self.addSubview(add10EntryLabel1)
        
        add10EntryLabel2.frame.size = CGSize(width: 150, height: 25)
        add10EntryLabel2.text = "0.000000000"
        add10EntryLabel2.sizeToFit()
        add10EntryLabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: add10EntryLabel1.frame.origin.y
        )
        self.addSubview(add10EntryLabel2)
        
        remove1EntryLabel1.frame.size = CGSize(width: 150, height: 25)
        remove1EntryLabel1.text = "Remove 1 Entry:"
        remove1EntryLabel1.sizeToFit()
        remove1EntryLabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: add10EntryLabel1.frame.origin.y + 35
        )
        self.addSubview(remove1EntryLabel1)
        
        remove1EntryLabel2.frame.size = CGSize(width: 150, height: 25)
        remove1EntryLabel2.text = "0.000000000"
        remove1EntryLabel2.sizeToFit()
        remove1EntryLabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: remove1EntryLabel1.frame.origin.y
        )
        self.addSubview(remove1EntryLabel2)
        
        remove5EntryLabel1.frame.size = CGSize(width: 150, height: 25)
        remove5EntryLabel1.text = "Remove 5 Entry:"
        remove5EntryLabel1.sizeToFit()
        remove5EntryLabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: remove1EntryLabel1.frame.origin.y + 35
        )
        self.addSubview(remove5EntryLabel1)
        
        remove5EntryLabel2.frame.size = CGSize(width: 150, height: 25)
        remove5EntryLabel2.text = "0.000000000"
        remove5EntryLabel2.sizeToFit()
        remove5EntryLabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: remove5EntryLabel1.frame.origin.y
        )
        self.addSubview(remove5EntryLabel2)
        
        remove10EntryLabel1.frame.size = CGSize(width: 150, height: 25)
        remove10EntryLabel1.text = "Remove 10 Entry:"
        remove10EntryLabel1.sizeToFit()
        remove10EntryLabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: remove5EntryLabel1.frame.origin.y + 35
        )
        self.addSubview(remove10EntryLabel1)
        
        remove10EntryLabel2.frame.size = CGSize(width: 150, height: 25)
        remove10EntryLabel2.text = "0.000000000"
        remove10EntryLabel2.sizeToFit()
        remove10EntryLabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: remove10EntryLabel1.frame.origin.y
        )
        self.addSubview(remove10EntryLabel2)
        
        lookupEntrylabel1.frame.size = CGSize(width: 150, height: 25)
        lookupEntrylabel1.text = "Lookup Entry:"
        lookupEntrylabel1.sizeToFit()
        lookupEntrylabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: remove10EntryLabel1.frame.origin.y + 35
        )
        self.addSubview(lookupEntrylabel1)
        
        lookupEntrylabel2.frame.size = CGSize(width: 150, height: 25)
        lookupEntrylabel2.text = "0.000000000"
        lookupEntrylabel2.sizeToFit()
        lookupEntrylabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: lookupEntrylabel1.frame.origin.y
        )
        self.addSubview(lookupEntrylabel2)
        
        lookup10Entrylabel1.frame.size = CGSize(width: 150, height: 25)
        lookup10Entrylabel1.text = "Lookup 10 Entry:"
        lookup10Entrylabel1.sizeToFit()
        lookup10Entrylabel1.frame.origin = CGPoint(
            x: arrayCreateTimeLabel1.frame.origin.x,
            y: lookupEntrylabel1.frame.origin.y + 35
        )
        self.addSubview(lookup10Entrylabel1)
        
        lookup10Entrylabel2.frame.size = CGSize(width: 150, height: 25)
        lookup10Entrylabel2.text = "0.000000000"
        lookup10Entrylabel2.sizeToFit()
        lookup10Entrylabel2.frame.origin = CGPoint(
            x: add1EntryLabel2.frame.origin.x,
            y: lookup10Entrylabel1.frame.origin.y
        )
        self.addSubview(lookup10Entrylabel2)
    }
    
    @objc
    func sliderValueDidChange(_ sender: UISlider) {
        let step: Float = 1
        let currentValue = Int(round(sender.value / step) * step)
        let formattedNumber = numberFormatter.string(from: NSNumber(value: currentValue))
        
        numberOfItemsLabel.text = "Number of Items: \(formattedNumber ?? "")"
        setNeedsLayout()
    }
    @objc
    func createArrayAndTest(_ sender: UIButton) { // swiftlint:disable:this function_body_length
        var currentTime = Date()
        var arrayCreateTime = TimeInterval()
        var add1EntryTime = TimeInterval()
        var add5EntryTime = TimeInterval()
        var add10EntryTime = TimeInterval()
        var remove1EntryTime = TimeInterval()
        var remove5EntryTime = TimeInterval()
        var remove10EntryTime = TimeInterval()
        var matchTime = TimeInterval()
        var match10Time = TimeInterval()
        
        arrayOfRandomStrings.removeAll()
        for _ in 0...Int(slider.value) - 1 {
            
            arrayOfRandomStrings += [stringGenerator.generateRandomString(2)]
            
            if arrayOfRandomStrings.count == 1 {
                add1EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if arrayOfRandomStrings.count == 5 {
                add5EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if arrayOfRandomStrings.count == 10 {
                add10EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if arrayOfRandomStrings.count == Int(slider.value) {
                arrayCreateTime = Date().timeIntervalSince(currentTime)
            }
        }
        
        currentTime = Date()
        var matchCount = 0
        var matchString: String
        
        while matchCount <= 10 {
            matchString = stringGenerator.generateRandomString(2)
            for index in 0...Int(slider.value) - 1 {
                if arrayOfRandomStrings[index] == matchString {
                    matchTime = Date().timeIntervalSince(currentTime)
                    matchCount += 1
                }
                if matchCount == 10 {
                    match10Time = Date().timeIntervalSince(currentTime)
                }
            }
        }
        
        currentTime = Date()
        
        for index in stride(from: Int(slider.value) - 1, to: Int(slider.value) - 13, by: -1) {
            arrayOfRandomStrings.remove(at: index)
            
            if arrayOfRandomStrings.count == (Int(slider.value) - 2) {
                remove1EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if arrayOfRandomStrings.count == (Int(slider.value) - 7) {
                remove5EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if arrayOfRandomStrings.count == (Int(slider.value) - 12) {
                remove10EntryTime = Date().timeIntervalSince(currentTime)
            }
        }
        
        let time1 = String(format: "%.9f", arrayCreateTime)
        let time2 = String(format: "%.9f", add1EntryTime)
        let time3 = String(format: "%.9f", add5EntryTime)
        let time4 = String(format: "%.9f", add10EntryTime)
        let time5 = String(format: "%.9f", remove1EntryTime)
        let time6 = String(format: "%.9f", remove5EntryTime)
        let time7 = String(format: "%.9f", remove10EntryTime)
        let time8 = String(format: "%.9f", matchTime)
        let time9 = String(format: "%.9f", match10Time)
        
        arrayCreateTimeLabel2.text = "\(time1)"
        add1EntryLabel2.text = "\(time2)"
        add5EntryLabel2.text = "\(time3)"
        add10EntryLabel2.text = "\(time4)"
        remove1EntryLabel2.text = "\(time5)"
        remove5EntryLabel2.text = "\(time6)"
        remove10EntryLabel2.text = "\(time7)"
        lookupEntrylabel2.text = "\(time8)"
        lookup10Entrylabel2.text = "\(time9)"
    }
}
