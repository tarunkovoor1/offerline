//
//  DraftView.swift
//  RecruitReady
//
//  Created by Ninan Thomas on 4/21/24.
//

import Foundation
import SwiftUI
import CoreData
import AppKit

/*struct DraftTabView: View {
    let drafts: DraftData?
    let draftViewModel: DraftViewModel
    
    @State private var showingDeleteAlert = false
    
    init(drafts : DraftData,viewModel : DraftViewModel) {
        self.draftViewModel = viewModel
        self.drafts = drafts
    }
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("Email Draft").font(.headline)
                    TextField("To: (Optional)", text: Binding<String>(
                        get: { self.drafts?.to ?? "" },
                        set: { newValue in
                            // Ensures resume is not nil before setting its name
                            self.drafts?.to = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                    TextField("Subject: (Optional)", text: Binding<String>(
                        get: { self.drafts?.subject ?? "" },
                        set: { newValue in
                            // Ensures resume is not nil before setting its name
                            self.drafts?.subject = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                    TextField("cc: (Optional)", text: Binding<String>(
                        get: { self.drafts?.cc ?? "" },
                        set: { newValue in
                            // Ensures resume is not nil before setting its name
                            self.drafts?.cc = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                    TextField("bcc: (Optional)", text: Binding<String>(
                        get: { self.drafts?.bcc ?? "" },
                        set: { newValue in
                            // Ensures resume is not nil before setting its name
                            self.drafts?.bcc = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                }
                
                Group {
                    Text("Body").font(.headline)
                    TextEditor(text: Binding<String>(
                        get: { self.drafts?.body  ?? "" },
                        set: { newValue in
                            // Ensures resume is not nil before setting its name
                            self.drafts?.body  = newValue
                            draftViewModel.saveDrafts()
                        }
                    ))
                    .frame(minHeight: 200) // Adjust the height here as needed
                    .border(Color.gray, width: 1)
                }
                Button("Delete Draft") {
                    self.showingDeleteAlert = true
                }
                .foregroundColor(.red)
                
                .padding()
            }
            .frame(minWidth: 300)
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Draft"),
                    message: Text("Are you sure you want to delete this draft?"),
                    primaryButton: .destructive(Text("Delete")) {
                        // Call your delete method here
                        // Ensure you have a method in your ViewModel to handle deletion
                        if let draft = drafts {
                            draftViewModel.deleteDraft(draft)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
            }
        }
    }
*/

struct DraftTabView: View {
    let drafts: DraftData?
    let draftViewModel: DraftViewModel
    
    @State private var showingDeleteAlert = false
    
    init(drafts: DraftData, viewModel: DraftViewModel) {
        self.draftViewModel = viewModel
        self.drafts = drafts
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Group {
                    Text("Email Draft").font(.headline)
                    TextField("To: (Optional)", text: Binding<String>(
                        get: { self.drafts?.to ?? "" },
                        set: { newValue in
                            self.drafts?.to = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                    TextField("Subject: (Optional)", text: Binding<String>(
                        get: { self.drafts?.subject ?? "" },
                        set: { newValue in
                            self.drafts?.subject = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                    TextField("cc: (Optional)", text: Binding<String>(
                        get: { self.drafts?.cc ?? "" },
                        set: { newValue in
                            self.drafts?.cc = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                    
                    TextField("bcc: (Optional)", text: Binding<String>(
                        get: { self.drafts?.bcc ?? "" },
                        set: { newValue in
                            self.drafts?.bcc = newValue
                            self.draftViewModel.saveDrafts()
                        }
                    ))
                }
                
                Group {
                    Text("Body").font(.headline)
                    TextEditor(text: Binding<String>(
                        get: { self.drafts?.body ?? "" },
                        set: { newValue in
                            self.drafts?.body = newValue
                            draftViewModel.saveDrafts()
                        }
                    ))
                    .frame(minHeight: 200) // Adjust the height here as needed
                    .padding(6) // Add padding to ensure the text is not obscured
                    .border(Color.gray, width: 1)
                }
                
                Button("Delete Draft") {
                    self.showingDeleteAlert = true
                }
                .foregroundColor(.red)
                .padding()
            }
            .frame(minWidth: 300)
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Draft"),
                    message: Text("Are you sure you want to delete this draft?"),
                    primaryButton: .destructive(Text("Delete")) {
                        // Call your delete method here
                        if let draft = drafts {
                            draftViewModel.deleteDraft(draft)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

                
    struct DraftView: View {
        @ObservedObject  var draftViewModel:  DraftViewModel
        
        // Precomputed Sorted Colleges
        private var sortedDrafts: [DraftData] {
            draftViewModel.drafts.sorted {
                ($0.draft_number?.intValue ?? 0) < ($1.draft_number?.intValue ?? 0)
            }
        }
        
        var body: some View {
            TabView {
                ForEach(sortedDrafts, id: \.self) { draft in
                    DraftTabView(drafts: draft, viewModel: draftViewModel)
                        .tabItem {
                            Label("Draft \(draft.draft_number?.intValue ?? 0)", systemImage: "person.fill")
                        }
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        // Find the maximum resume_number in the current array
                        let maxDraftNumber = draftViewModel.drafts.max(by: {
                            ($0.draft_number?.intValue ?? 0) < ($1.draft_number?.intValue ?? 0)
                        })?.draft_number?.intValue ?? 0
                        
                        // Create a new ResumeData instance
                        let newDraft = DraftData(context: draftViewModel.context) // Adjust initialization as needed
                        
                        // Set the resume_number to one more than the current maximum
                        newDraft.draft_number = NSNumber(value: maxDraftNumber + 1)
                        
                        // Append the new ResumeData instance to the resumes array
                        draftViewModel.drafts.append(newDraft)
                        
                        // Save changes to the context
                        do {
                            try draftViewModel.context.save()
                        } catch {
                            // Handle save error
                            print("Error saving context: \(error)")
                        }
                        
                        // If your application logic requires reloading or refreshing data, do so here
                        // For example, you might need to reload views or fetch data again
                    }) {
                        Image(systemName: "plus")
                    }
                    
                }
            }
            
            .navigationTitle("Drafts")
        }
    }
    
    
