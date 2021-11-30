import Foundation

struct SuffixIterator: IteratorProtocol {
    let string: String
    var last: String.Index
    var offset: String.Index
    
    init (string: String) {
        self.string = string
        self.last = string.endIndex
        self.offset = string.startIndex
    }
    
    mutating func next() -> Substring? {
        guard offset < last else {
            return nil
        }
        
        let sub: Substring = string[offset..<last]
        string.formIndex(after: &offset)
        return sub
    }
}

struct SuffixSequence: Sequence {
    let string: String
    
    func makeIterator() -> SuffixIterator {
        return SuffixIterator(string: string)
    }
}

class SequenceViewController: ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        suffixPrint()
    }
    
    func suffixPrint() {
        for suffix in SuffixSequence(string: "Hello World!") {
            print(suffix)
        }
    }
}
