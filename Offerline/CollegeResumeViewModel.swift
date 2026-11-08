//
//  CollegeResumeViewModel.swift
//  Offerline
//
//  Created by Tarun Kovoor on 4/6/24.
//

import Foundation
//
//  ResumeViewModel.swift
//  Offerline
//
//  Created by Tarun Kovoor on 1/29/24.
//

import CoreData

class CollegeResumeViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var college_resume: [CollegeResume] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadCollegeResume()
        
    }
    
    func convertAndStore(_ resumeData: ResumeData, collegeNumber: NSNumber) {
            print("Adding resume")
            let newResume = CollegeResume(context: context)
            newResume.college_no = collegeNumber
            newResume.bookmarkData = resumeData.bookmarkData
            newResume.path = resumeData.path
            newResume.type = resumeData.type
            print ("Resume added name=", resumeData.path ?? "no path")
            do {
                try context.save()
            } catch {
                print("Failed to save: \(error)")
            }
           
        }
    
    private func formatPhoneNumber(phone: String?) -> String {
        guard let phone = phone, phone.count == 10 else { return phone ?? "Phone Not Provided" }
        let formatted = "(\(phone.prefix(3))) \(phone.dropFirst(3).prefix(3))-\(phone.suffix(4))"
        return formatted
    }
    
    





    func  saveCollegeResume () {
        print("Saving college resume ")
        
        
        // Set other attributes
        
        do {
            try context.save()
        } catch {
            // Handle errors
            print("Failed to read: \(error)")
        }
    }
    
    func loadCollegeResume() {
        let request: NSFetchRequest<CollegeResume> = CollegeResume.fetchRequest()
        // Add predicates or sorting if needed
        do {
            college_resume = try context.fetch(request)
            for resume in college_resume {
                if let bookmarkData = resume.bookmarkData {
                    handleBookmark(bookmarkData, for: resume)
                }
            }
        } catch {
            // Handle errors
            print("Failed to read: \(error)")
        }
    }
    
    private func handleBookmark(_ bookmarkData: Data, for resume: CollegeResume) {
        do {
            var isStale = false
            var url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
            if isStale {
                print("Bookmark data is stale.")
                let newBookmarkData = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                resume.bookmarkData = newBookmarkData
                try context.save()
                url = try URL(resolvingBookmarkData: newBookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
            }
            if !url.startAccessingSecurityScopedResource() {
                print("Failed to start accessing security-scoped resource.")
            }
            resume.path = url.path
        } catch {
            print("Failed to resolve bookmark data: \(error.localizedDescription)")
        }
    }
    
    func deleteCollegeResume(_ resume: CollegeResume) {
        context.delete(resume)
        do {
            try context.save()
            loadCollegeResume() // Reload your resumes to reflect the change
        } catch {
            print("Error deleting resume: \(error)")
        }
    }
    
    func resumeExistsForCollege(collegeNumber: NSNumber) -> Bool {
            return college_resume.contains(where: { $0.college_no == collegeNumber })
        }
}

