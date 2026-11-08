import CoreData

class ResumeViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var resumes: [ResumeData] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadResume()
    }
    
    func saveResume() {
        print("Saving resume")
        do {
            try context.save()
        } catch {
            print("Failed to read: \(error)")
        }
    }
    
    func loadResume() {
        let request: NSFetchRequest<ResumeData> = ResumeData.fetchRequest()
        print("Loading resume")
        do {
            resumes = try context.fetch(request)
            print("Resumes loaded", resumes.count)
            for resume in resumes {
                if let bookmarkData = resume.bookmarkData {
                    handleBookmark(bookmarkData, for: resume)
                }
            }
        } catch {
            print("Failed to read: \(error)")
        }
    }
    
    func deleteResume(_ resume: ResumeData) {
        context.delete(resume)
        do {
            try context.save()
            loadResume()
        } catch {
            print("Error deleting resume: \(error)")
        }
    }
    
    func addResume(bookmarkData: Data, type: String, url: URL) {
        do {
            let newResume = ResumeData(context: context)
            newResume.path = url.path
            newResume.type = type
            newResume.bookmarkData = bookmarkData

            let maxNumberRequest: NSFetchRequest<ResumeData> = ResumeData.fetchRequest()
            maxNumberRequest.sortDescriptors = [NSSortDescriptor(key: "resume_number", ascending: false)]
            maxNumberRequest.fetchLimit = 1
            
            let maxResults = try context.fetch(maxNumberRequest)
            let maxNumber = maxResults.first?.resume_number?.intValue ?? 0
            
            newResume.resume_number = NSNumber(value: maxNumber + 1)
            
            try context.save()
            resumes.append(newResume)
            loadResume()
            
        } catch {
            print("Error checking or adding resume: \(error)")
            handleAlert(message: "Failed to add resume due to an error.")
        }
    }

    
    func handleAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func handleBookmark(_ bookmarkData: Data, for resume: ResumeData) {
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
    
   
}

