//
//  CollegeNote.swift
//  RecruitReady
//
//  Created by Ninan Thomas on 5/24/24.
//

import Foundation
import CoreData

@objc(CollegeNote)
public class CollegeNote: NSManagedObject {

}

extension CollegeNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollegeNote> {
        return NSFetchRequest<CollegeNote>(entityName: "CollegeNote")
    }

    @NSManaged public var noteData: Data?
    @NSManaged public var college_no: NSNumber?

}

extension CollegeNote : Identifiable {

}

