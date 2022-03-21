import UIKit

class NumberTypeField: UITextField {
    var typedNumbers = ""
    var positions: [Int] = []
    var deletePositions: [Int] = []
    var etcPositions: [Int] = []
    var currentIndex = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func deleteBackward() {
        var etcdeletedState = false
        var numInc = 1
        for (index, item) in etcPositions.enumerated() {
            if let newPos = self.position(from: self.beginningOfDocument, offset: +item) {
                if self.selectedTextRange == self.textRange(from: newPos, to: newPos) {
                    
                    if index != 0 {
                        if item - 1 == etcPositions[index - 1] {
                            numInc += 1
                        }
                    }
                    
                    if let newPos = self.position(from: self.beginningOfDocument, offset: +(item - numInc)) {
                        self.selectedTextRange = self.textRange(from: newPos, to: newPos )
                        super.deleteBackward()
                        
                        etcdeletedState = true
                    }
                }
            }
        }
        if etcdeletedState == false {
            super.deleteBackward()
        }
    }
    
    func setup() {
        let placeholderText = "+X(XXX) XXX XX-XX"
        
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
        self.font = UIFont.systemFont(ofSize: 20.0)
        self.placeholder = placeholderText
        
        etcPositions = getDeletePositionsForETCSymbol(mask: "+X(XXX) XXX XX-XX" )
        positions = getNumCoords(mask: "+X(XXX) XXX XX-XX")
        deletePositions = positions.map { $0 + 1 }
        print(etcPositions)
        print(positions)
        print(deletePositions )
    }
    
    func replaceCharacter(string: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(string)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    func getDeletePositionsForETCSymbol(mask: String) -> [Int] {
        var returnArr: [Int] = []
        let stringArr = Array(mask)
        for index in stringArr.indices {
            if stringArr[index] != "X" {
                returnArr += [index + 1]
            }
        }
        return returnArr
    }
    
    func getNumCoords(mask: String) -> [Int] {
        var arr: [Int] = []
        for (index, char) in mask.enumerated() {
            if char == "X" {
                arr += [index]
            }
        }
        return arr
    }
    
    func floatingCursorSetPosition(isInc: Bool) {
        if isInc == true {
            currentIndex = tpToClosestNumber(string: self.text ?? "")
            print(currentIndex)
            if currentIndex < positions.count && typedNumbers.count < 11 {
                if let newPos = self.position(from: self.beginningOfDocument, offset: +positions[currentIndex]) {
                    self.selectedTextRange = self.textRange(from: newPos, to: newPos)
                }
            }
        }
        
        if isInc == false {
            currentIndex = tpToClosestDeletedNumber(string: self.text ?? "")
            print(" delete index - \(currentIndex)")
            if currentIndex >= 0 && !typedNumbers.isEmpty {
                if let newPos = self.position(from: self.beginningOfDocument, offset: +deletePositions[currentIndex]) {
                    self.selectedTextRange = self.textRange(from: newPos, to: newPos)
                }
            }
        }
        if typedNumbers.isEmpty {
            if let newPos = self.position(from: self.beginningOfDocument, offset: +1) {
                self.selectedTextRange = self.textRange(from: newPos, to: newPos)
            }
        }
        if typedNumbers.count == positions.count {
            UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func tpToClosestNumber(string: String) -> Int {
        var nextIndex = 0
        var oneTime = true
        let arr = Array(string)
        for index in arr.indices {
            if arr[index] == "X" && oneTime {
                nextIndex = index
                oneTime = !oneTime
            }
        }
        for index in positions.indices {
            if positions[index] == nextIndex {
                nextIndex = index
            }
        }
        return nextIndex
    }
    
    func tpToClosestDeletedNumber(string: String) -> Int {
        var nextIndex = 0
        let arr = Array(string)
        for index in arr.indices {
            if arr[index] == typedNumbers.last {
                nextIndex = index + 1
            }
        }
        for index in deletePositions.indices {
            if deletePositions[index] == nextIndex {
                nextIndex = index
            }
        }
        return nextIndex
    }
    
    func placeholderTextShow(string: String) -> NSAttributedString? {
        var lastNumberIndex = 0
        var arr = Array(string)
        for index in arr.indices {
            if arr[index].isNumber {
                lastNumberIndex = index
            }
        }
        
        if lastNumberIndex == 0 {
            let str1 = String(arr)
            let attributes1 = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            let attributedText1 = NSMutableAttributedString(string: str1, attributes: attributes1)
            return attributedText1
        } else if lastNumberIndex == positions.last {
            let str1 = String(arr)
            let attributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let attributedText1 = NSMutableAttributedString(string: str1, attributes: attributes1)
            return attributedText1
        } else {
            arr.insert("^", at: lastNumberIndex + 1)
            let separatedString = String(arr).split(separator: "^")
            
            let str1 = String(separatedString[0])
            let str2 = String(separatedString[1])
            
            let attributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
            let attributes2 = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            
            let attributedText1 = NSMutableAttributedString(string: str1, attributes: attributes1)
            let attributedText2 = NSMutableAttributedString(string: str2, attributes: attributes2)
            
            attributedText1.append(attributedText2)
            return attributedText1
        }
    }
    
    func typePhoneNumber(mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = mask
        var index = numbers.startIndex
        var replaceIndex = -1
        
        for char in mask where index < numbers.endIndex {
            replaceIndex += 1
            if char == "X" {
                
                result = replaceCharacter(string: result, replaceIndex, numbers[index])
                
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
        var increaseState = true
        
        let string = typePhoneNumber(mask: "+X(XXX) XXX XX-XX", phone: phoneString)
        
        self.attributedText = placeholderTextShow(string: string)
        
        let countTypedNumbersBuffer = typedNumbers.count
        typedNumbers = ""
        for char in phoneString where typedNumbers.count < 11 {
            if char.wholeNumberValue != nil {
                typedNumbers += String(char)
            }
        }
        
        if typedNumbers.count < countTypedNumbersBuffer {
            increaseState = false
        }
        
        floatingCursorSetPosition(isInc: increaseState)
    }
}

class NumberTypeViewController: ViewController {
    
    let numberTypeField = NumberTypeField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(numberTypeField)
    }
}
