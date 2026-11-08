//
//  CollegeData+CoreDataProperties.swift
//  RecruitReady
//
//  Created by Tarun Kovoor on 4/2/24.
//

import Foundation
import CoreData


extension CollegeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CollegeData> {
        return NSFetchRequest<CollegeData>(entityName: "CollegeData")
    }

    @NSManaged public var coach_email_1: String?
    @NSManaged public var coach_email_2: String?
    @NSManaged public var coach_email_3: String?
    @NSManaged public var coach_email_4: String?
    @NSManaged public var coach_email_5: String?
    @NSManaged public var coach_phone_1: String?
    @NSManaged public var coach_phone_2: String?
    @NSManaged public var coach_phone_3: String?
    @NSManaged public var coach_phone_4: String?
    @NSManaged public var coach_phone_5: String?
    @NSManaged public var coach_title_1: String?
    @NSManaged public var coach_title_2: String?
    @NSManaged public var coach_title_3: String?
    @NSManaged public var coach_title_4: String?
    @NSManaged public var coach_title_5: String?
    @NSManaged public var college_name: String?
    @NSManaged public var college_division: String?
    @NSManaged public var college_number: NSNumber?

}

extension CollegeData : Identifiable {

}
