//
//  CollegeViewModel.swift
//  Offerline
//
//  Created by Tarun Kovoor on 4/2/24.
//

import CoreData

class CollegeViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var colleges: [CollegeData] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadColleges ()
             
    }
    
    func  saveColleges () {
        
        // Set other attributes
        
        do {
            try context.save()
        } catch {
            // Handle errors
            print("Failed to read: \(error)")
        }
    }
    
    func loadColleges () {
        let request: NSFetchRequest<CollegeData> = CollegeData.fetchRequest()
        // Add predicates or sorting if needed
        print("Loading college")
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Directory not found")

        do {
            colleges = try context.fetch(request)
            print ("Colleges loaded", colleges.count)
        } catch {
            // Handle errors
            print("Failed to read: \(error)")
        }
    }
    
    func deleteCollege(_ collegeData: CollegeData) {
        context.delete(collegeData)
        do {
            try context.save()
            loadColleges() // Reload colleges to reflect the deletion
        } catch {
            print("Error deleting college: \(error)")
        }
    }
}


