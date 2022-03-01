import Foundation
import UIKit

class ParsingViewControllerRealm: UIViewController {
    
    let fileStorage: CodableFileStorage = ServiceLocator.shared.getService()
    
    private var parseView: ParsingViewRealm! // swiftlint:disable:this implicitly_unwrapped_optional
    private var viewModel: ParsingViewModelRealm! // swiftlint:disable:this implicitly_unwrapped_optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ParsingViewModelRealm(parseDataClosure: { [weak self] in
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
        
        parseView = ParsingViewRealm(
            parseFromUrl: { [weak self] urlString in
                self?.viewModel.updateDataFromUrl(url: urlString)
            },
            getDataFromDataBase: { [weak self] in
                print("clicked")
                self?.viewModel.addToRealmDB(name: "test", text: "adgf", someInt: 3)
                let str = self?.viewModel.getDataFromRealm()
                self?.parseView.setText(str ?? "")
            }
        )
        view = parseView
    }
}
