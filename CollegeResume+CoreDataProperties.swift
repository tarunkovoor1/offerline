//
//  CollegeResume + CoreDataProperties.swift
//  RecruitReady
//
//  Created by Tarun Kovoor on 4/6/24.
//

import Foundation
import CoreData


extension CollegeResume {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollegeResume> {
        return NSFetchRequest<CollegeResume>(entityName: "CollegeResume")
    }

    @NSManaged public var college_no: NSNumber?
    @NSManaged public var type: String?
    @NSManaged public var path: String?
    @NSManaged public var bookmarkData: Data?
    @NSManaged public var notes: Data?

}

extension CollegeResume : Identifiable {

}
