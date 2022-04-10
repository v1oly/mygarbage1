import CoreData
import RealmSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let shareExtensionViewController = ShareExtensionViewController()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LocalDataBase")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    override init() {
        ServiceLocatorInitialization.registerServicesToServiceLocator()
    }
    
    func application(
        _ application: UIApplication,
        // swiftlint:disable:next discouraged_optional_collection
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Core Data location - \(urls[urls.count - 1] as URL)")
        
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        if let realm = try? Realm() {
            print("realm file location - \(realm.configuration.fileURL?.absoluteURL as Any)")
        }
        return true
    }

    func application(
        _ application: UIApplication,
        // swiftlint:disable:next discouraged_optional_collection
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print(#function)
        return true
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
        if let userDefaults = UserDefaults(suiteName: "group.MN.dz") {
            if let userDefaultObj = userDefaults.object(forKey: "text2") {
                shareExtensionViewController.shareView.textView.text = userDefaultObj as? String
                self.window?.rootViewController = shareExtensionViewController
                self.window?.makeKeyAndVisible()
                userDefaults.removeObject(forKey: "text2")
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
        self.saveContext()
    }
}
