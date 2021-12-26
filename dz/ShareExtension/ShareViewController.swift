import MobileCoreServices
import Social
import UIKit

class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        
        if let extContextInputItems = extensionContext?.inputItems {
            for item: Any in extContextInputItems {
                
                if let inputItem = item as? NSExtensionItem {
                    if let inputItemAtt = inputItem.attachments {
                        for provider: Any in inputItemAtt {
                            
                            let itemProvider = provider as? NSItemProvider
                            if let itemProviderItem = itemProvider?.hasItemConformingToTypeIdentifier(
                                kUTTypeText as String
                            ) {
                                
                                if itemProviderItem {
                                    itemProvider?.loadItem(
                                        forTypeIdentifier: kUTTypeText as String,
                                        options: nil,
                                        completionHandler: { text, _ in
                                            if  let userDefaults = UserDefaults(suiteName: "group.MN.dz"),
                                                let text = text {
                                                userDefaults.set(text, forKey: "text2")
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }
        }
        if let url = URL(string: "dz://text") {
            _ = self.openURL(url)
        }
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
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
