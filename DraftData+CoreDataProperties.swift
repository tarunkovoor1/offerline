//
//  DraftData+CoreDataProperties.swift
//  Offerline
//
//  Created by Tarun Kovoor on 4/5/24.
//

import Foundation
import CoreData


extension DraftData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DraftData> {
        return NSFetchRequest<DraftData>(entityName: "DraftData")
    }

    @NSManaged public var to: String?
    @NSManaged public var subject: String?
    @NSManaged public var body: String?
    @NSManaged public var bcc: String?
    @NSManaged public var cc: String?
    @NSManaged public var draft_number: NSNumber?
}

extension DraftData : Identifiable {

}
