import UIKit

class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    
    override func loadView() {
        view = detailsView
    }
}
