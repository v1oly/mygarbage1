import UIKit

class ShareExtensionViewController: UIViewController {
    let textView = UITextView()
    var topSafePlace: CGFloat = 0
    let measurementFormatter = MeasurementFormatter()
    var currentDateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .white
    }
    
    func setup() {
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            topSafePlace = window!.safeAreaInsets.top
        }
        
        let segmentedItems = ["Chinese", "French", "Engish(USA)"]
        let segmentedControl = UISegmentedControl(items: segmentedItems)
        segmentedControl.frame.size = CGSize(width: UIScreen.main.bounds.width/1.1, height: 40)
        segmentedControl.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: topSafePlace + 10)
        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
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
    func compare2DateMasks(date1: String, date2: String, dateFormat: String) -> Bool {
        let dateFormatter = DateFormatter()
        var compareArray: [String] = []
        
        dateFormatter.locale = Locale(identifier: detectLanguage(for: date2) ?? "")
        dateFormatter.dateFormat = dateFormat
        if let firstDate = dateFormatter.date(from: date1) {
            if let secondDate = dateFormatter.date(from: date2) {
                let string1 = dateFormatter.string(from: firstDate)
                let string2 = dateFormatter.string(from: secondDate)
                print(string1, "--1")
                print(string2, "--2")
                compareArray.append(string1)
                compareArray.append(string2)
            }
        }
        print("compare array - \(compareArray)")
        print("compare array count - \(compareArray.count)")
        if compareArray.count > 1 {
            return true
        } else {
            return false
        }
    }
    
    func findDateInSharedText(text: String, newLocale: Locale) {
        
        var dateArray: [String] = []
        var localizedDateArray: [String] = []
        var dateFormats = ["EEEE, MMM d, yyyy", "MM/dd/yyyy", "MM-dd-yyyy HH:mm", "MMM d, h:mm a", "MMMM yyyy",
                            "d MMMM yyyy", "MMM d, yyyy", "dd.MM.yy", "dd-MMM-yy"]
        
        var dateFormatter = DateFormatter()
        let types: NSTextCheckingResult.CheckingType = [.date]
        
        guard let detector = try? NSDataDetector(types: types.rawValue) else {
            fatalError("detector not found")
        }
        let range = NSMakeRange(0, text.count)
        let matches = detector.matches (
            in: text,
            options: NSRegularExpression.MatchingOptions(rawValue: 0),
            range: range
        )
        for match in matches {
            if let aSubstring = text.substring(nsrange: match.range) {
                dateArray += [String(aSubstring)]
            }
        }
        print(dateArray)
        for item in dateArray {
            
            for format in dateFormats {
                dateFormatter.locale = Locale(identifier: detectLanguage(for: text) ?? "")
                dateFormatter.dateFormat = format
                
                if let date = dateFormatter.date(from: item) {
                    dateFormatter.locale = newLocale
                    let date1 = dateFormatter.string(from: date)
                    
                    if compare2DateMasks(date1: date1, date2: item, dateFormat: format) == true {
                        localizedDateArray += [date1]
                    }
                }
            }
        }
        print("aaa - ", localizedDateArray)
    }
    
    @objc
    func segmentAction(_ sender: UISegmentedControl!) {
        var dateFormats = ["EEEE, MMM d, yyyy", "MM/dd/yyyy", "MM-dd-yyyy HH:mm", "MMM d, h:mm a", "MMMM yyyy",
                            "d MMMM yyyy", "MMM d, yyyy", "dd.MM.yy", "dd-MMM-yy"]
       

        switch (sender.selectedSegmentIndex) {
        case 0:
            let zh = Locale(identifier: "zh_CN")
            findDateInSharedText(text: textView.text, newLocale: zh)
            
            print("0")
  

        case 1:
            let fr = Locale(identifier: "fr")
            findDateInSharedText(text: textView.text, newLocale: fr)

         
            print("1")

        case 2:
            let enUS = Locale(identifier: "en_US")
            findDateInSharedText(text: textView.text, newLocale: enUS)

            print("2")
        
        default:
            break
        }
    }
}

extension String {
    func substring(nsrange: NSRange) -> Substring? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return self[range]
    }
}
