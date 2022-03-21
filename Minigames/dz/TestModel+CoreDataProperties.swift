//
//  TestModel+CoreDataProperties.swift
//  dz
//
//  Created by Markus on 23.02.2022.
//  Copyright © 2022 Mark Nekrashevich. All rights reserved.
//
//

import Foundation
import CoreData


extension TestModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestModel> {
        return NSFetchRequest<TestModel>(entityName: "TestModel")
    }

    @NSManaged public var index: Int16
    @NSManaged public var text: String?

}
