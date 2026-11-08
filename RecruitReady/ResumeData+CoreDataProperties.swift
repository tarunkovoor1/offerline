//
//  ResumeData+CoreDataProperties.swift
//  RecruitReady
//
//  Created by Tarun Kovoor on 1/29/24.
//
//

import Foundation
import CoreData


extension ResumeData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ResumeData> {
        return NSFetchRequest<ResumeData>(entityName: "ResumeData")
    }

    @NSManaged public var type: String?
    @NSManaged public var path: String?
    @NSManaged public var resume_number: NSNumber?
    @NSManaged public var bookmarkData: Data?
}

extension ResumeData : Identifiable {

}
