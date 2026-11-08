//
//  DraftViewModel.swift
//  RecruitReady
//
//  Created by Tarun Kovoor on 4/5/24.
//

import CoreData

class DraftViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var drafts: [DraftData] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadDrafts ()
             
    }
    
    func  saveDrafts () {
        //print("Saving drafts ")
        
        
        // Set other attributes
        
        do {
            try context.save()
        } catch {
            // Handle errors
            print("Failed to read: \(error)")
        }
    }
    
    func loadDrafts () {
        let request: NSFetchRequest<DraftData> = DraftData.fetchRequest()
        // Add predicates or sorting if needed
        print("Loading draft")
        do {
            drafts = try context.fetch(request)
            print ("Drafts loaded", drafts.count)
        } catch {
            // Handle errors
            print("Failed to read: \(error)")
        }
    }
    
    func deleteDraft(_ draftData: DraftData) {
        context.delete(draftData)
        do {
            try context.save()
            loadDrafts() // Reload colleges to reflect the deletion
        } catch {
            print("Error deleting draft: \(error)")
        }
    }
}
