import Foundation
import UIKit

class ParsingViewController: UIViewController {
    
    private var parseView: ParsingView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var viewModel: ParsingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ParsingViewModel(parseDataClosure: { [weak self] in
            if let parsedData = self?.viewModel.decodeData(convertedType: CustomStringConvertible.self) {
                self?.parseView.setText(parsedData.description)
            }
        })
    }
    
    override func loadView() {
        
        parseView = ParsingView(parseFromUrl: { [weak self] urlString in
            self?.viewModel.updateDataFromUrl(url: urlString)
        })
        view = parseView
    }
}
