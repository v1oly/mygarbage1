import Foundation

class Dynamic<T> {
    typealias Listener = (T) -> ()
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ val: T) {
        value = val
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
}
