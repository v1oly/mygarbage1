import Foundation
import UIKit

class ParsingViewController: UIViewController {
    
    let fileStorage: CodableFileStorage = ServiceLocator.shared.getService()
    
    private var parseView: ParsingView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var viewModel: ParsingViewModel! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ParsingViewModel(parseDataClosure: { [weak self] in
            let parsedData = self?.viewModel.modelData
            self?.parseView.setText(parsedData?.description ?? "nil")
            })
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cfg = fileStorage.retrieve("ParseConfiguration", from: .documents, as: ParseConfiguration.self)
        parseView.setText(cfg?.parsedData ?? "")
        parseView.setUrlFieldText(cfg?.url ?? "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            fileStorage.store(
                ParseConfiguration(
                    url: parseView.getUrlFieldText() ?? "",
                    parsedData: parseView.getTextViewText() ?? ""
                ),
                to: .documents,
                as: "ParseConfiguration"
            )
        }
        print("file saved")
    }
    
    override func loadView() {
        
        parseView = ParsingView(
            parseFromUrl: { [weak self] urlString in
                self?.viewModel.updateDataFromUrl(url: urlString)
            },
            getDataFromDataBase: { [weak self] in
                print("clicked")
//                self?.viewModel.saveDataToDataBase(text: "Test", index: 6)
                self?.viewModel.deleteDataFromDataBase(_where: "NewTest")
                if let fetchedData = self?.viewModel.fetchDataFromDataBase() {
                    let string = fetchedData.joined(separator: "\n")
                    self?.parseView.setText(string)
                }
            }
        )
        view = parseView
    }
}
