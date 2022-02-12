import Foundation
import UIKit

class ParsingViewController: UIViewController {
    
    var parseView: ParsingView! // swiftlint:disable:this implicitly_unwrapped_optional
    var viewModel: ParsingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ParsingViewModel(autoCallsTask: { [weak self] in
            guard let url = self?.viewModel.url else { return }
            self?.viewModel.getResources(url: url, completion: { data in
                let newText = self?.viewModel.decodeJSON(data: data)
                self?.parseView.setTextViewText(newText?.description ?? "nil")
            })
        })
    }
    
    override func loadView() {
        
        parseView = ParsingView(parseFromUrl: { [weak self] in
            guard let url = self?.viewModel.url else { return }
            self?.viewModel.getResources(url: url, completion: { data in
                let newText = self?.viewModel.decodeJSON(data: data)
                self?.parseView.setTextViewText(newText?.description ?? "nil")
            })
        })
        view = parseView
    }
}
