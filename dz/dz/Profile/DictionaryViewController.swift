import UIKit

class DictionaryViewController: UIViewController {
    
    let dictionaryView = DictionaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = dictionaryView
    }
}

class DictionaryView: UIView { // swiftlint:disable:this type_body_length
    
    let stringGenerator = StringGenerator()
    var segmentNumber = 10
    
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
    
    var dictionaryArray: [Int: String] = [:]
    
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
        self.backgroundColor = .white
        numberFormatter.numberStyle = .decimal
        
        var topSafePlace: CGFloat = 0
        
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.windows.first {
                topSafePlace = window.safeAreaInsets.top
            }
        }
        
        let segmentsFile = ["10", "100", "1000", "10000", "100000"]
        let segmentControl = UISegmentedControl(items: segmentsFile)
        segmentControl.frame.size = CGSize(width: UIScreen.main.bounds.width / 1.1, height: 40)
        segmentControl.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: topSafePlace + 55)
        segmentControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        self.addSubview(segmentControl)
        
        createArrayButton.frame.size = CGSize(width: 200, height: 25)
        createArrayButton.backgroundColor = .clear
        createArrayButton.setTitle("Create dictionary and Test", for: .normal)
        createArrayButton.setTitleColor(.blue, for: .normal)
        createArrayButton.sizeToFit()
        createArrayButton.center = CGPoint(x: segmentControl.center.x, y: segmentControl.center.y + 50)
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
        arrayCreateTimeLabel1.text = "Creating dict Time:"
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
    func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentNumber = 10
        case 1:
            segmentNumber = 100
        case 2:
            segmentNumber = 1_000
        case 3:
            segmentNumber = 10_000
        case 4:
            segmentNumber = 100_000
        default:
            break
        }
    }
    
    @objc
    func createArrayAndTest(_ sender: UIButton) { // swiftlint:disable:this function_body_length
        var currentTime = Date()
        var setCreateTime = TimeInterval()
        var add1EntryTime = TimeInterval()
        var add5EntryTime = TimeInterval()
        var add10EntryTime = TimeInterval()
        var remove1EntryTime = TimeInterval()
        var remove5EntryTime = TimeInterval()
        var remove10EntryTime = TimeInterval()
        var matchTime = TimeInterval()
        var match10Time = TimeInterval()
        
        dictionaryArray.removeAll()
        for index in 0...segmentNumber {
            dictionaryArray[index] = stringGenerator.generateRandomString(2)
            
            if dictionaryArray.count == 1 {
                add1EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if dictionaryArray.count == 5 {
                add5EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if dictionaryArray.count == 10 {
                add10EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if dictionaryArray.count == segmentNumber - 1 {
                setCreateTime = Date().timeIntervalSince(currentTime)
            }
        }
    
        currentTime = Date()
        var matchCount = 0
        
        while matchCount <= 10 {
            var matchString = stringGenerator.generateRandomString(2)
            for value in dictionaryArray {
                if value.value == matchString {
                    matchTime = Date().timeIntervalSince(currentTime)
                    matchCount += 1
                    matchString = stringGenerator.generateRandomString(2)
                }
                if matchCount == 10 {
                    match10Time = Date().timeIntervalSince(currentTime)
                }
            }
        }
        
        currentTime = Date()
        let setCount1 = dictionaryArray.count - 1
        let setCount2 = dictionaryArray.count - 5
        let setCount3 = dictionaryArray.count - 10
        
        for index in 0...9 {
            dictionaryArray.removeValue(forKey: index)
            
            if dictionaryArray.count == setCount1 {
                remove1EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if dictionaryArray.count == setCount2 {
                remove5EntryTime = Date().timeIntervalSince(currentTime)
            }
            
            if dictionaryArray.count == setCount3 {
                remove10EntryTime = Date().timeIntervalSince(currentTime)
            }
        }
        
        let time1 = String(format: "%.9f", setCreateTime)
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
