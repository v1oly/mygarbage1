import Foundation

class Debouncer {
    
    func debounce(delay: TimeInterval, action: @escaping (String) -> Void) -> (String) -> Void {
        let callback = DebounceCallBack(action)
        var timer: Timer?
        return { arg in
            if let timer = timer { timer.invalidate() }
            timer = Timer(timeInterval: delay,
                          target: callback,
                          selector: #selector(DebounceCallBack.exec),
                          userInfo: ["arg": arg],
                          repeats: false)
            if let rTimer = timer { RunLoop.current.add(rTimer, forMode: .default) }
        }
    }
}

class DebounceCallBack {
    
    let handler: (String) -> Void
    
    init(_ handler: @escaping (String) -> Void) {
        self.handler = handler
    }
    @objc
    func exec(timer: Timer) {
        if let info = timer.userInfo as? [String: String], let arg = info["arg"] {
            handler(arg)
        }
    }
}
