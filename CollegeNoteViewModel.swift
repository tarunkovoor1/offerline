import CoreData
import Combine

class CollegeNoteViewModel: ObservableObject {
    let context: NSManagedObjectContext
    @Published var collegeNotes: [CollegeNote] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        loadCollegeNotes()
    }

    func loadCollegeNotes() {
        let request: NSFetchRequest<CollegeNote> = CollegeNote.fetchRequest()
        do {
            collegeNotes = try context.fetch(request)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }

    
    func addNoteToCollege(collegeNumber: NSNumber) -> CollegeNote {
        let note = CollegeNote(context: context)
        note.college_no = collegeNumber
        note.noteData = Data()

        do {
            try context.save()
            loadCollegeNotes()
        } catch {
            print("Failed to save note: \(error)")
        }

        return note
    }

    func getNoteForCollege(collegeNumber: NSNumber) -> CollegeNote? {
        return collegeNotes.first(where: { $0.college_no == collegeNumber })
    }

    func deleteNoteForCollege(collegeNumber: NSNumber) {
        if let note = getNoteForCollege(collegeNumber: collegeNumber) {
            context.delete(note)
            do {
                try context.save()
                loadCollegeNotes()
            } catch {
                print("Failed to delete note: \(error)")
            }
        }
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

