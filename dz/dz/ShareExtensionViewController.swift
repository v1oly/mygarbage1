import UIKit

class ShareExtensionViewController: UIViewController {
    let shareView = ShareExtensionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = shareView
    }
}

class ShareExtensionView: UIView {
    let textView = UITextView()
    var topSafePlace: CGFloat = 0
    private let measurementFormatter = MeasurementFormatter()
    private var currentDateFormatter = DateFormatter()
    private var bufCount = false
    private var originalText: String = ""
    private let segmentedControl = UISegmentedControl(items: ["Chinese", "French", "Engish(USA)"])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.windows.first {
                topSafePlace = window.safeAreaInsets.top
            }
        }
        segmentedControl.frame.size = CGSize(width: bounds.width / 1.1, height: 40)
        segmentedControl.center = CGPoint(x: bounds.width / 2, y: topSafePlace + 15)
        
        textView.frame.size = CGSize(width: bounds.width / 1.5, height: bounds.height / 2)
        textView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    }
    private func setup() {
        
        self.backgroundColor = .white
        
        segmentedControl.addTarget(self, action: #selector(switchSegment(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        self.addSubview(segmentedControl)
        
        textView.backgroundColor = .lightGray
        self.addSubview(textView)
    }
    
    private func detectLanguage(for string: String) -> String? {
        return NSLinguisticTagger.dominantLanguage(for: string)
    }
    
    private func findDateInSharedText(newLocale: Locale) {
        
        var dateArray: [String] = []
        var localizedDateArray: [String] = []
        let dateFormats = [
            "EEEE, MMM d, yyyy", "MM/dd/yyyy", "MM-dd-yyyy HH:mm", "MMM d, h:mm a", "MMMM yyyy",
            "MMM d, yyyy", "d MMMM yyyy", "dd-MM-yy", "dd.MM.yy", "dd MMM", "dd MM", "dd MMMM"
        ]
        var isFormatAlreadyUsed = false
        let dateFormatter = DateFormatter()
        let types: NSTextCheckingResult.CheckingType = [.date]
        
        guard let detector = try? NSDataDetector(types: types.rawValue) else {// swiftlint:disable:this legacy_objc_type
            fatalError("detector not found")
        }
        
        let range = NSMakeRange(0, textView.text.count) // swiftlint:disable:this legacy_constructor
        let matches = detector.matches(
            in: textView.text,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: range
        )
        
        for match in matches {
            if let aSubstring = textView.text.substring(nsrange: match.range) {
                dateArray += [String(aSubstring)]
            }
        }
        
        for date in dateArray {
            isFormatAlreadyUsed = false
            for format in dateFormats {
                dateFormatter.locale = Locale(identifier: detectLanguage(for: textView.text) ?? "")
                
                dateFormatter.dateFormat = format
                
                if let date = dateFormatter.date(from: date) {
                    dateFormatter.locale = newLocale
                    if isFormatAlreadyUsed == false {
                        let date1 = dateFormatter.string(from: date)
                        localizedDateArray += [date1]
                        isFormatAlreadyUsed = true
                    }
                }
            }
        }
        
        for index in dateArray.indices {
            textView.text = textView.text.replacingOccurrences(of: dateArray[index], with: localizedDateArray[index])
        }
        dateArray.removeAll()
        localizedDateArray.removeAll()
    }
    
    private func findMeasurements(newLocale: Locale) {
        
        textView.text = originalText
        
        let formatter = MeasurementFormatter()
        formatter.locale = Locale(identifier: detectLanguage(for: textView.text) ?? "")
        let formats = [
            "km": UnitLength.kilometers,
            "cm": UnitLength.centimeters,
            "m": UnitLength.meters,
            "kg": UnitMass.kilograms
        ]
        
        var result: [String] = []
        var locaizedResult: [String] = []
        var resultString: String = ""
        
        for (key, value) in formats {
            let measurementsMasks =
            "(?:\\b|-)([1-9]{1,9}[0]?|1000000000)\(key)\\b|(?:\\b|-)([1-9]{1,9}[0]?|1000000000) \(key)\\b"
            
            do {
                let regularExpression = try NSRegularExpression(pattern: measurementsMasks)
                let matches = regularExpression.matches(
                    in: textView.text,
                    range: NSRange(textView.text.startIndex..., in: textView.text)
                )
                result = matches.map {
                    if let range = Range($0.range, in: textView.text) {
                        resultString = String(textView.text[range])
                    }
                    return resultString
                }
            } catch let error {
                print(error)
            }
            
            for item in result {
                let splitArr = splitDateStrToNumberAndMeasure(string: item)
                formatter.locale = newLocale
                formatter.unitOptions = .providedUnit
                let measuare = Measurement(value: Double(splitArr[0]) ?? 0, unit: value)
                let localizedString = formatter.string(from: measuare)
                locaizedResult += [localizedString]
            }
            
            for index in result.indices {
                textView.text = textView.text.replacingOccurrences(of: result[index], with: locaizedResult[index])
            }
            
            result.removeAll()
            locaizedResult.removeAll()
        }
    }
    
    private func splitDateStrToNumberAndMeasure(string: String) -> [String] {
        var result: [String] = []
        var lastNumberIndex = 0
        var isSeparateFieldFound = false
        var spaceDetect = false
        var arr = Array(string)
        
        for (index, char) in arr.enumerated() {
            if char == " " && isSeparateFieldFound == false {
                lastNumberIndex = index
                isSeparateFieldFound = true
                spaceDetect = true
            } else if char.isNumber == false && isSeparateFieldFound == false {
                lastNumberIndex = index
                isSeparateFieldFound = true
            }
        }
        
        if spaceDetect {
            arr.remove(at: lastNumberIndex)
        }
        
        arr.insert("^", at: lastNumberIndex)
        let separatedString = String(arr).split(separator: "^")
        
        let str1 = String(separatedString[0])
        let str2 = String(separatedString[1])
        result += [str1, str2]
        return result
    }
    
    private func getOriginalText() -> String {
        return textView.text
    }
    
    @objc
    private func switchSegment(_ sender: UISegmentedControl) {
        if bufCount == false {
            originalText = getOriginalText()
            bufCount = true
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            let zhLocale = Locale(identifier: "zh_CN")
            findMeasurements(newLocale: zhLocale)
            findDateInSharedText(newLocale: zhLocale)
            
        case 1:
            let frLocale = Locale(identifier: "fr")
            findMeasurements(newLocale: frLocale)
            findDateInSharedText(newLocale: frLocale)
            
        case 2:
            let enUS = Locale(identifier: "en_US")
            findMeasurements(newLocale: enUS)
            findDateInSharedText(newLocale: enUS)
            
        default:
            break
        }
    }
}
private extension String {
    func substring(nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else {
            return nil
        }
        return self[range]
    }
}
