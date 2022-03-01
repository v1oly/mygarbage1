import CoreData
import Foundation
// swiftlint:disable all
extension TestModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestModel> {
        return NSFetchRequest<TestModel>(entityName: "TestModel")
    }

    @NSManaged public var index: Int16
    @NSManaged public var text: String?
}
