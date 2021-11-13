import UIKit

class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    
    override func viewDidLoad() {
   
    }
    
    override func loadView() {
        view = detailsView
    }
}

