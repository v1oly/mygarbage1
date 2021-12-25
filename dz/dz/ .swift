import UIKit

class ShareExtensionViewController: UIViewController {
    let textView = UITextView()
    var topSafePlace: CGFloat = 0
    let measurementFormatter = MeasurementFormatter()
    var currentDateFormatter = DateFormatter()
    var bufCount = false
    var originalText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .white
    }
    
    func setup() {
        
        if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.windows.first {
                topSafePlace = window.safeAreaInsets.top
            }
        }
        
        let segmentedItems = ["Chinese", "French", "Engish(USA)"]
        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.frame.size = CGSize(width: UIScreen.main.bounds.width / 1.1, height: 40)
        segmentedControl.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: topSafePlace + 10)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        view.addSubview(segmentedControl)
        
        textView.frame.size = CGSize(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height / 2)
        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        textView.backgroundColor = .lightGray
        view.addSubview(textView)
    }
    
    func detectLanguage(for string: String) -> String? {
        if let language = NSLinguisticTagger.dominantLanguage(for: string) {
            return language
        } else {
            return nil
        }
    }
    
    func findDateInSharedText(newLocale: Locale) {
        
        var dateArray: [String] = []
        var localizedDateArray: [String] = []
        let dateFormats = [
            "EEEE, MMM d, yyyy", "MM/dd/yyyy", "MM-dd-yyyy HH:mm", "MMM d, h:mm a", "MMMM yyyy",
            "MMM d, yyyy", "d MMMM yyyy", "dd-MM-yy", "dd.MM.yy"
        ]
        var check = false
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
        
        for item in dateArray {
            check = false
            for format in dateFormats {
                dateFormatter.locale = Locale(identifier: detectLanguage(for: textView.text) ?? "")
                dateFormatter.dateFormat = format
                
                if let date = dateFormatter.date(from: item) {
                    dateFormatter.locale = newLocale
                    if check == false {
                    let date1 = dateFormatter.string(from: date)
                        localizedDateArray += [date1]
                        check = true
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
    
    func findMesuarments(newLocale: Locale) {
        
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
        var str: String = ""
        
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
                        str = String(textView.text[range])
                    }
                    return str
                }
            } catch let error {
                print(error)
            }
            for item in result {
                print(item)
                let splitArr = splitString(string: item)
                formatter.locale = newLocale
                formatter.unitOptions = .providedUnit
                let measuare = Measurement(value: Double(splitArr[0]) ?? 0, unit: value)
                print(measuare)
                let localizedString = formatter.string(from: measuare)
                print(localizedString)
                locaizedResult += [localizedString]
            }
            
            for index in result.indices {
                textView.text = textView.text.replacingOccurrences(of: result[index], with: locaizedResult[index])
            }
            result.removeAll()
            locaizedResult.removeAll()
        }
    }
    
    func splitString(string: String) -> [String] {
        var result: [String] = []
        var lastNumberIndex = 0
        var check = false
        var spaceDetect = false
        var arr = Array(string)
        for (index, char) in arr.enumerated() {
            if char == " " && check == false {
                lastNumberIndex = index
                check = true
                spaceDetect = true
            } else if char.isNumber == false && check == false {
                lastNumberIndex = index
                check = true
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
    
    func getOriginalText() -> String {
        return textView.text
    }
    
    @objc
    func segmentAction(_ sender: UISegmentedControl) {
        if bufCount == false {
            originalText = getOriginalText()
            bufCount = true
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            let zhLocale = Locale(identifier: "zh_CN")
            findMesuarments(newLocale: zhLocale)
            findDateInSharedText(newLocale: zhLocale)
            print("0")
            
        case 1:
            let frLocale = Locale(identifier: "fr")
            findMesuarments(newLocale: frLocale)
            findDateInSharedText(newLocale: frLocale)
            print("1")

        case 2:
            let enUS = Locale(identifier: "en_US")
            findMesuarments(newLocale: enUS)
            findDateInSharedText(newLocale: enUS)
            print("2")
        
        default:
            break
        }
    }
}

extension String {
    func substring(nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else {
            return nil
        }
        return self[range]
    }
}
