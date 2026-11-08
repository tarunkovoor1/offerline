//
//  ContentView.swift
//  RecruitReady
//
//  Created by Tarun Kovoor on 1/29/24.
//

import SwiftUI
import CoreData
import AppKit

struct ContentView: View {
    @StateObject private var collegeViewModel = CollegeViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject var resumeViewModel = ResumeViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject private var draftViewModel = DraftViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject private var noteViewModel = CollegeNoteViewModel(context: PersistenceController.shared.container.viewContext)
    
    @State private var selection: String? = "Dashboard" // Add this state property

    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: DashboardView(collegeViewModel: collegeViewModel,
                                               resumeViewModel: resumeViewModel,
                                               draftViewModel: draftViewModel,
                                               noteViewModel: noteViewModel),
                    tag: "Dashboard",
                    selection: $selection // Bind selection state
                ) {
                    Text("Dashboard")
                }
                NavigationLink(
                    destination: ResumeView(resumeViewModel: resumeViewModel),
                    tag: "Resume",
                    selection: $selection // Bind selection state
                ) {
                    Text("Resume")
                }
                NavigationLink(
                    destination: CollegeContactsView(collegeViewModel: collegeViewModel),
                    tag: "College Contacts",
                    selection: $selection // Bind selection state
                ) {
                    Text("College Contacts")
                }
                NavigationLink(
                    destination: DraftView(draftViewModel: draftViewModel),
                    tag: "Email Drafts",
                    selection: $selection // Bind selection state
                ) {
                    Text("Email Drafts")
                }
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Menu")
            
            DashboardView(collegeViewModel: collegeViewModel, // Initial view
                          resumeViewModel: resumeViewModel,
                          draftViewModel: draftViewModel,
                          noteViewModel: noteViewModel)
        }
    }
}
