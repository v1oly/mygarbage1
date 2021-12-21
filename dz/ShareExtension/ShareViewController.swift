import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        
        for item: Any in extensionContext!.inputItems {
            
            if let inputItem = item as? NSExtensionItem {
                for provider: Any in inputItem.attachments! {
                    
                    let itemProvider = provider as? NSItemProvider
                    
                    if itemProvider!.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                        itemProvider!.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil, completionHandler: { text, error in
                            
                            if  let userDefaults = UserDefaults(suiteName: "group.MN.dz"),
                                let text = text {
                                userDefaults.set(text, forKey: "text2")
                            }
                        })
                    }
                }
            }
        }
        if let url = URL(string: "AppWithExtensionShare://text") {
            _ = self.openURL(url)
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }
    
    @objc
    func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
