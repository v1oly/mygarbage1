import UIKit

class NumberTypeField: UITextField, UITextFieldDelegate {
    
    var count = false
    var textBuffer = ""
    var numberCountBuffer = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        let startPosition: UITextPosition = self.beginningOfDocument
        let placeholderText = "+X(XXX) XXX XX-XX"
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        self.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.frame.size = CGSize(
            width: UIScreen.main.bounds.width / 1.5,
            height: UIScreen.main.bounds.height / 20
        )
        self.center = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: UIScreen.main.bounds.height / 2
        )
        self.backgroundColor = .lightGray
        self.borderStyle = .roundedRect
        self.textAlignment = .center
        self.attributedPlaceholder = attributedPlaceholder
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    func typePhoneNumber(mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = mask
        var index = numbers.startIndex
        var replaceIndex = -1
        
        for char in mask where index < numbers.endIndex {
            replaceIndex += 1
            if char == "X" {
                
                result = replace(myString: result, replaceIndex, numbers[index])
                
                index = numbers.index(after: index)
            }
        }
        return result
    }
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        guard let phoneString = self.text else {
            return
        }
        self.text = typePhoneNumber(mask: "+X(XXX) XXX XX-XX", phone: phoneString)
        
//        var numberCount = 0
//        let arrayPhoneString = Array(phoneString)
//        for char in arrayPhoneString {
//            switch char {
//            case "1":
//                numberCount += 1
//            case "2":
//                numberCount += 1
//            case "3":
//                numberCount += 1
//            case "4":
//                numberCount += 1
//            case "5":
//                numberCount += 1
//            case "6":
//                numberCount += 1
//            case "7":
//                numberCount += 1
//            case "8":
//                numberCount += 1
//            case "9":
//                numberCount += 1
//            case "0":
//                numberCount += 1
//            default:()
//            }
//        }
//
//        if !count {
//            let newPosition = textField.beginningOfDocument
//            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
//            count = true
//        }
//        if count && (numberCountBuffer > numberCount) {
//            if let selectedRange = self.selectedTextRange {
//
//                // and only if the new position is valid
//                if let newPosition = self.position(from: selectedRange.start, offset: -1) {
//
//                    // set the new position
//                    self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
//                }
//            }
//        }
//        if count && (numberCountBuffer < numberCount) {
//            if let selectedRange = self.selectedTextRange {
//
//                // and only if the new position is valid
//                if let newPosition = self.position(from: selectedRange.start, offset: +1) {
//
//                    // set the new position
//                    self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
//                }
//            }
//        }
//        numberCountBuffer = numberCount
//        print("number count \(numberCount)")
//        print("number count buffer \(numberCountBuffer)")
    }
}

class NumberTypeViewController: ViewController {
   
    let numberTypeField = NumberTypeField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(numberTypeField)
    }
}
