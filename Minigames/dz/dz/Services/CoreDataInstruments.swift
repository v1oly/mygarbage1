import CoreData
import Foundation
import UIKit

class CoreDataInstruments {
    
    lazy var persistenceContainer: NSPersistentContainer? = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return delegate.persistentContainer
    }()
    
    lazy var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TestModel")
    
    func saveToDataBase(text: String, index: Int) {
        guard let context = persistenceContainer?.viewContext else
        { print("No context"); return }
        
        let newRecord = TestModel(context: context)
        newRecord.text = text
        newRecord.index = Int16(index)
        do {
            try context.save()
            print("newRecord Saved")
        } catch let error {
            print(error)
        }
    }
    
    func fetchFromDataBase(completion: @escaping ([TestModel]) -> ()) {
        guard let context = persistenceContainer?.viewContext else
        { print("No context"); return }
        do {
            if let object = try context.fetch(fetchRequest) as? [TestModel] {
                completion(object)
            }
        } catch let error {
            print(error)
        }
    }
    
    func deleteFromDataBase(_where text: String) {
        guard let context = persistenceContainer?.viewContext else
        { print("No context"); return }
        var currentEntity: [TestModel] = []
        var deleteEntity: NSManagedObject
        
        fetchFromDataBase { testModel in
            currentEntity = testModel
        }
        
        for (index, object) in currentEntity.enumerated() {
            if object.text == text {
                deleteEntity = object as NSManagedObject
                context.delete(deleteEntity)
            }
        }

        do {
            try context.save()
            print("SQL BASE UPDATED")
        } catch let error {
            print(error)
        }
    }
}
