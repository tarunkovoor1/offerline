//
//  DashboardView.swift
//  RecruitReady
//
//  Created by Ninan Thomas on 4/21/24.
//

import Foundation
import SwiftUI
import CoreData
import AppKit

struct DashboardView: View {
    @ObservedObject var collegeViewModel: CollegeViewModel
    @ObservedObject var resumeViewModel: ResumeViewModel
    @ObservedObject var draftViewModel: DraftViewModel
    @ObservedObject var noteViewModel: CollegeNoteViewModel
    @State private var activePopoverCollegeId: NSNumber?
    @State private var showingResumeSelection = false
    @State private var showingDraftSelection = false
    @State private var selectedCollege: CollegeData?
    @StateObject private var collegeResumeViewModel = CollegeResumeViewModel(context: PersistenceController.shared.container.viewContext)

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    if collegeViewModel.colleges.isEmpty {
                        VStack {
                            Spacer()
                            Text("Add College contacts, Resumes and email drafts to create dashboard")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .padding()
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        let tileWidth = (geometry.size.width / 2) - 30
                        let tileHeight = tileWidth

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: tileWidth))], spacing: 20) {
                            ForEach(collegeViewModel.colleges, id: \.college_number) { college in
                                CollegeTileView(college: college, tileWidth: tileWidth, tileHeight: tileHeight, activePopoverCollegeId: $activePopoverCollegeId, showingResumeSelection: $showingResumeSelection, collegeResumeViewModel: collegeResumeViewModel, resumeViewModel: resumeViewModel, draftViewModel: draftViewModel, showingDraftSelection: $showingDraftSelection, selectedCollege: $selectedCollege,
                                    noteViewModel: noteViewModel)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Dashboard")
            .sheet(isPresented: $showingResumeSelection) {
                ResumeSelectionView(resumeViewModel: resumeViewModel, collegeResumeViewModel: collegeResumeViewModel, activePopoverCollegeId: $activePopoverCollegeId)
            }
            .sheet(isPresented: $showingDraftSelection) {
                DraftSelectionView(draftViewModel: draftViewModel, collegeResumeViewModel: collegeResumeViewModel, selectedCollege: $selectedCollege)
            }
        }
    }
}



struct CollegeTileView: View {
    let college: CollegeData
    let tileWidth: CGFloat
    let tileHeight: CGFloat
    @Binding var activePopoverCollegeId: NSNumber?
    @Binding var showingResumeSelection: Bool
    @ObservedObject var collegeResumeViewModel: CollegeResumeViewModel
    @ObservedObject var resumeViewModel: ResumeViewModel
    @ObservedObject var draftViewModel: DraftViewModel
    @Binding var showingDraftSelection: Bool
    @Binding var selectedCollege: CollegeData?
    @StateObject private var windowHolder = WindowControllerHolder()
    @StateObject private var windowHolderResume = WindowControllerResumePopover()
    @State private var showingNotesEditor = false
    @ObservedObject var noteViewModel: CollegeNoteViewModel

    var body: some View {
        VStack {
            Text(college.college_name ?? "Unknown College")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            VStack {
                Button(action: {
                    togglePopover(collegeId: college.college_number ?? 0)
                }) {
                    Label("Resume", systemImage: "doc.text")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(10)
                .onHover { hovering in
			if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
		    }

                if activePopoverCollegeId == college.college_number {
                    let resume = collegeResumeViewModel.college_resume.first(where: { $0.college_no == college.college_number })
                    ResumePopoverView(collegeResumeViewModel: collegeResumeViewModel, showResumeSelection: $showingResumeSelection, resumeViewModel: resumeViewModel, resume: resume, collegeNumber: college.college_number ?? 0, windowHolder: windowHolderResume)
                        .frame(width: tileWidth, height: 100)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }

            Button(action: {
                print("Setting selectedCollege to \(college.college_name ?? "Unknown College")")
                selectedCollege = college
                print("selectedCollege is now \(selectedCollege?.college_name ?? "nil")")
                showingDraftSelection = true
            }) {
                Label("Send Email", systemImage: "envelope")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(10)
            .onHover { hovering in
		    if hovering {
                NSCursor.pointingHand.push()
                } else {
                NSCursor.pop()
                }
            }
            
           
            
            Button(action: {
                if let note = noteViewModel.getNoteForCollege(collegeNumber: college.college_number ?? 0) {
                        showNotesEditorWindow(note: note)
                    } else {
                        let note = noteViewModel.addNoteToCollege(collegeNumber: college.college_number ?? 0)
                        showNotesEditorWindow(note: note)
                    }
            }) {
                Label("Notes", systemImage: "pencil")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding(10)
            .onHover { hovering in
		    if hovering {
                NSCursor.pointingHand.push()
                } else {
                NSCursor.pop()
                }
            }
        
        }
        .padding()
        .frame(width: tileWidth, height: tileHeight + (activePopoverCollegeId == college.college_number ? 100 : 0))
        .background(Color.blue)
        .cornerRadius(10)
    }

    private func togglePopover(collegeId: NSNumber) {
        print("Toggling popover", collegeId.stringValue, "activePopoverCollegeId=", activePopoverCollegeId?.stringValue ?? "0")
        if activePopoverCollegeId == collegeId {
            activePopoverCollegeId = nil
        } else {
            activePopoverCollegeId = collegeId
        }
        print("Toggling popover", collegeId.stringValue, "activePopoverCollegeId=", activePopoverCollegeId?.stringValue ?? "0")
    }
    
    private func showNotesEditorWindow(note: CollegeNote) {
            let notesEditorView = NotesEditorView(collegeNote: note)
            guard let mainWindow = NSApp.keyWindow else { return }
            let editWindow = NotesEditorWindowController(contentView: notesEditorView, parentWindow: mainWindow)
            windowHolder.windowController = editWindow
            editWindow.showWindow(nil)

            // Declare the observer variable as an optional
            var observer: NSObjectProtocol?

            // Add an observer to clean up after the window closes
            observer = NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: editWindow.window, queue: nil) { [weak windowHolder] _ in
                print("Cleaning up notes editor window")
                windowHolder?.windowController = nil // Nil out the reference to allow disposal

                // Check and remove the observer
                if let obs = observer {
                    NotificationCenter.default.removeObserver(obs)
                }
            }
        }
}


struct DraftSelectionView: View {
    @ObservedObject var draftViewModel: DraftViewModel
    @ObservedObject var collegeResumeViewModel: CollegeResumeViewModel
    @Binding var selectedCollege: CollegeData?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            Text("Select Draft to Send Email")
                .font(.headline)
                .padding()
            
            if draftViewModel.drafts.isEmpty {
                Text("No drafts available")
                    .padding()
            } else {
                List(draftViewModel.drafts, id: \.self) { draft in
                    Button("Draft \(draft.draft_number ?? 1)") {
                        sendEmail(draft: draft, selectedCollege: selectedCollege)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding(.vertical, 10)
                }
            }
            
            Spacer()
        }
        .onAppear {
            print("DraftSelectionView onAppear: selectedCollege is \(selectedCollege?.college_name ?? "nil")")
        }
        .frame(idealWidth: (NSApp.keyWindow?.contentView?.bounds.width ?? 0) / 4, idealHeight: (NSApp.keyWindow?.contentView?.bounds.height ?? 0) / 1.5)
    }
    
    private func sendEmail(draft: DraftData, selectedCollege: CollegeData?) {
        guard let selectedCollege = selectedCollege else {
            print("No college selected.")
            displayErrorAlert(messageText: "No College Selected", informativeText: "Please select a college before sending the email.")
            return
        }

        let subject = draft.subject ?? ""
        let body = draft.body ?? ""
        let to = draft.to ?? ""
        let cc = draft.cc ?? ""
        let bcc = draft.bcc ?? ""
        
        guard let resume = collegeResumeViewModel.college_resume.first(where: { $0.college_no == selectedCollege.college_number }) else {
            print("No resume found for the selected college.")
            
            let alert = NSAlert()
            alert.messageText = "No Resume Found"
            alert.informativeText = "No resume will be attached. Add resume by clicking the resume button above. Do you want to continue without attaching a resume?"
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Continue")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                if let emailUrl = createEmailUrl(to: to, subject: subject, body: body, cc: cc, bcc: bcc) {
                    NSWorkspace.shared.open(emailUrl)
                }
            }
            return
        }

        if let bookmarkData = resume.bookmarkData {
            var isStale = false
            if let resumeUrl = try? URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale) {
                if !isStale, resumeUrl.startAccessingSecurityScopedResource() {
                    // Create email URL with attachment
                    DispatchQueue.global(qos: .background).async {
                        self.composeEmail(to: to, subject: subject, body: body, cc: cc, bcc: bcc, attachment: resumeUrl)
                        resumeUrl.stopAccessingSecurityScopedResource()
                    }
                } else {
                    print("Failed to access security scoped resource or bookmark is stale.")
                    displayErrorAlert(messageText: "Attachment Error", informativeText: "There was an issue accessing the resume. Please try again.")
                }
            } else {
                print("Failed to resolve bookmark data.")
                displayErrorAlert(messageText: "Attachment Error", informativeText: "There was an issue accessing the resume. Please try again.")
            }
        } else {
            print("Failed to resolve bookmark data.")
            displayErrorAlert(messageText: "Attachment Error", informativeText: "There was an issue accessing the resume. Please try again.")
        }
    }

    private func composeEmail(to: String, subject: String, body: String, cc: String, bcc: String, attachment: URL) {
        DispatchQueue.main.async {
            let sharingService = NSSharingService(named: NSSharingService.Name.composeEmail)
            sharingService?.recipients = [to]
            sharingService?.subject = subject
            let items: [Any] = [body, attachment] // body text and attachment

            if let sharingService = sharingService {
                sharingService.perform(withItems: items) 
            } else {
                print("Failed to create email sharing service.")
                displayErrorAlert(messageText: "Email Error", informativeText: "There was an issue creating the email. Please try again.")
            }
        }
    }

    private func createEmailUrl(to: String, subject: String, body: String, cc: String, bcc: String) -> URL? {
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = to
        
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject),
            URLQueryItem(name: "body", value: body),
            URLQueryItem(name: "cc", value: cc),
            URLQueryItem(name: "bcc", value: bcc)
        ]
        
        return components.url
    }

    private func displayErrorAlert(messageText: String, informativeText: String) {
        let alert = NSAlert()
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.alertStyle = .critical
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }


        private func isApplicationRunning(appName: String) -> Bool {
            let runningApps = NSWorkspace.shared.runningApplications
            return runningApps.contains { $0.localizedName == appName }
        }
    
}

struct ResumeSelectionView: View {
    @ObservedObject var resumeViewModel: ResumeViewModel
    @ObservedObject var collegeResumeViewModel: CollegeResumeViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var activePopoverCollegeId: NSNumber?
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill") // Using SF Symbols for the 'X' icon
                        .imageScale(.large)
                        .padding()
                }
                .buttonStyle(PlainButtonStyle())
            }

            Text("Select Resume to be added")
                .font(.headline)
                .padding()

            if resumeViewModel.resumes.isEmpty {
                Text("No resumes available")
                    .padding()
            } else {
                List(resumeViewModel.resumes, id: \.self) { resume in
                    Button("Resume \(resume.resume_number ?? 1)") {
                        collegeResumeViewModel.convertAndStore(resume, collegeNumber: activePopoverCollegeId ?? 0)
                        collegeResumeViewModel.loadCollegeResume()
                        showAlert = true
                        alertMessage = "Resume \(resume.resume_number ?? 1) has been added."
                        resumeViewModel.loadResume() // Ensure the list is updated
                    }
                    .padding(.vertical, 10)
                }
            }

            Spacer()
        }
        //.frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(idealWidth: (NSApp.keyWindow?.contentView?.bounds.width ?? 0)/4, idealHeight: (NSApp.keyWindow?.contentView?.bounds.height ?? 0)/1.5)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Resume Added"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

class WindowControllerResumePopover: ObservableObject {
    var windowController: EditResumeWindowController?
}


struct ResumePopoverView: View {
    @ObservedObject var collegeResumeViewModel: CollegeResumeViewModel
    @Binding var showResumeSelection: Bool
    @ObservedObject var resumeViewModel: ResumeViewModel
    @State private var showingEditView = false  // State to control the sheet presentation
    @State  var resume: CollegeResume?
    var collegeNumber: NSNumber
    @State private var showErrorPopup = false
    @State private var showDeleteConfirmation = false
    @State private var alertMessage: (title: String, message: String)?
    var windowController: EditResumeWindowController?
    @ObservedObject var windowHolder: WindowControllerResumePopover
    
    var body: some View {
        VStack {
            Button("Add") {
            
                if collegeResumeViewModel.resumeExistsForCollege(collegeNumber: collegeNumber) {
                    alertMessage = ("Error", "Resume already exists for this college")
                } else {
                    // Proceed with showing the resume selection view
                    showResumeSelection = true
                }
               
            }
            Button("View") {
                guard resume != nil else { return }
                showingEditView = true  // Set this to true to show the EditResumeView
                showEditWindow(resumeData: self.resume!)
            }
            Button("Remove") {
                // Handle Remove
                if resume != nil {
                    // Show delete confirmation popup
                    showDeleteConfirmation = true
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(8)
        .alert(isPresented: Binding<Bool>(get: { showDeleteConfirmation || alertMessage != nil }, set: { _ in })) {
            if let message = alertMessage {
                return Alert(title: Text(message.title), message: Text(message.message), dismissButton: .default(Text("OK")) {
                    // Reset alert message after dismissing the alert
                    alertMessage = nil
                })
            } else if let resume = resume {
                return Alert(
                    title: Text("Delete Resume"),
                    message: Text("Are you sure you want to delete this resume? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        // Delete the resume from the CollegeResume table
                        collegeResumeViewModel.deleteCollegeResume(resume)
                        showDeleteConfirmation = false
                    },
                    secondaryButton: .cancel() {
                        showDeleteConfirmation = false
                    }
                    
                )
            } else {
                return Alert(title: Text("Error"), message: Text("No resume found for deletion"), dismissButton: .default(Text("OK")))
            }
        }
        .onChange(of: collegeResumeViewModel.college_resume) { newValue in
            //guard let self = self else { return }
            if let resume = collegeResumeViewModel.college_resume.first(where: { $0.college_no == self.collegeNumber }) {
                DispatchQueue.main.async {
                    self.resume = resume
                       }
                        
                    }
        }
    }
    
    private func showEditWindow(resumeData: CollegeResume) {
        let editResumeView = EditResumeView(resumeData: resumeData)
        guard let mainWindow = NSApp.keyWindow else { return }
        let editWindow = EditResumeWindowController(contentView: editResumeView, parentWindow: mainWindow)
        windowHolder.windowController = editWindow
        editWindow.showWindow(nil)

        // Declare the observer variable as an optional
        var observer: NSObjectProtocol?

        // Add an observer to clean up after the window closes
        observer = NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: editWindow.window, queue: nil) { [weak windowHolder] _ in
            print("Cleaning up RTF editor window")
            windowHolder?.windowController = nil // Nil out the reference to allow disposal

            // Check and remove the observer
            if let obs = observer {
                NotificationCenter.default.removeObserver(obs)
            }
        }
    }
}



class EditResumeWindowController: NSWindowController, NSWindowDelegate {
    private weak var parentWindow: NSWindow?

    override init(window: NSWindow?) {
        super.init(window: window)
        self.window?.delegate = self
    }

    convenience init(contentView: EditResumeView, parentWindow: NSWindow?) {
        let hostingController = NSHostingController(rootView: contentView)
        let window = NSWindow(contentViewController: hostingController)
        window.title = "View Resume"
        window.setFrame(NSRect(x: 0, y: 0, width: 600, height: 400), display: true)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.level = .normal
        window.isReleasedWhenClosed = true // Ensure the window releases all resources on close
        
        self.init(window: window)
        self.parentWindow = parentWindow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func printViewHierarchy(_ view: NSView?) {
        guard let view = view else { return }
        print("PRINTING THE VIEW")
        print(view)
        view.subviews.forEach { printViewHierarchy($0) }
    }

    // Use this method to check the hierarchy before and after opening the RTF editor
    func windowWillClose(_ notification: Notification) {
        print("window will close")
        parentWindow?.makeKeyAndOrderFront(nil)
        parentWindow?.contentView?.needsDisplay = true // Force redraw of the parent window
        NSApp.activate(ignoringOtherApps: true)
    }

}

struct EditResumeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var resumeData: CollegeResume
    
    @State private var rtfText: NSAttributedString = NSAttributedString()
    
    var body: some View {
          if resumeData.type == "pdf" {
                if let bookmarkData = resumeData.bookmarkData, let url = resolveBookmarkData(bookmarkData) {
                    PDFViewer(url: url)
                } else {
                    Text("Failed to resolve bookmark or file does not exist.")
                }
            } else if resumeData.type == "rtf" {
                if let bookmarkData = resumeData.bookmarkData, let url = resolveBookmarkData(bookmarkData) {
                    RTFViewer(url: url)
                } else {
                    Text("Failed to resolve bookmark or file does not exist.")
                }
            } else if resumeData.type == "docx" {
                if let bookmarkData = resumeData.bookmarkData, let url = resolveBookmarkData(bookmarkData) {
                    DOCXViewer(url: url)
                } else {
                    Text("Failed to resolve bookmark or file does not exist.")
                }
            } else {
                Text("Unsupported file type")
            }
    }
    
    
}


struct MenuView: View {
    var college: CollegeData
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button("Edit") {
                print("Edit \(college.college_name ?? "")")
                showMenu = false
            }
            Button("Add") {
                print("Add \(college.college_name ?? "")")
                showMenu = false
            }
            Button("Remove") {
                print("Remove \(college.college_name ?? "")")
                showMenu = false
            }
        }
        .padding()
        .frame(width: 200)
    }
}

struct ErrorPopupView: View {
    let message: String

    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(.red)
                .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}



