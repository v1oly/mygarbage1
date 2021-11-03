import UIKit

class BenchmarkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addBehaviors(behaviors: [LifecycleTimer()])
    }
}
