//
//  CollegeContactsView.swift
//  RecruitReady
//
//  Created by Ninan Thomas on 4/21/24.
//

import Foundation
import SwiftUI
import CoreData
import AppKit


struct CollegeContactsTabView: View {
                    let contacts: CollegeData?
                    let collegeViewModel: CollegeViewModel
                    
                    @State private var showingDeleteAlert = false
                    
                    init(contacts : CollegeData,viewModel : CollegeViewModel) {
                        self.collegeViewModel = viewModel
                        self.contacts = contacts
                    }
                    var body: some View {
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                Group {
                                    Text("College").font(.headline)
                                    TextField("Name", text: Binding<String>(
                                        get: { self.contacts?.college_name ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.college_name = newValue
                                            self.collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Division", text: Binding<String>(
                                        get: { self.contacts?.college_division ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.college_division = newValue
                                            self.collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                }
                                
                                Group {
                                    Text("Head Coach").font(.headline)
                                    TextField("Name", text: Binding<String>(
                                        get: { self.contacts?.coach_title_1 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_title_1 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Email", text: Binding<String>(
                                        get: { self.contacts?.coach_email_1 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_email_1 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Phone", text: Binding<String>(
                                        get: { self.contacts?.coach_phone_1 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_phone_1 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                }
                                
                                Group {
                                    Text("Assistant Coach (Based on your running/field events)").font(.headline)
                                    TextField("Name", text: Binding<String>(
                                        get: { self.contacts?.coach_title_2 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_title_2 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Email", text: Binding<String>(
                                        get: { self.contacts?.coach_email_2 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_email_2 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Phone", text: Binding<String>(
                                        get: { self.contacts?.coach_phone_2 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_phone_2 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                }
                                
                                Group {
                                    Text("Graduate Assistant Coach").font(.headline)
                                    TextField("Name", text: Binding<String>(
                                        get: { self.contacts?.coach_title_3 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_title_3 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Email", text: Binding<String>(
                                        get: { self.contacts?.coach_email_3 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_email_3 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Phone", text: Binding<String>(
                                        get: { self.contacts?.coach_phone_3 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_phone_3 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                }
                                
                                Group {
                                    Text("Graduate Assistant Coach").font(.headline)
                                    TextField("Name", text: Binding<String>(
                                        get: { self.contacts?.coach_title_4 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_title_4 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Email", text: Binding<String>(
                                        get: { self.contacts?.coach_email_4 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_email_4 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Phone", text: Binding<String>(
                                        get: { self.contacts?.coach_phone_4 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_phone_4 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                }
                                
                                Group {
                                    Text("Graduate Assistant Coach").font(.headline)
                                    TextField("Name", text: Binding<String>(
                                        get: { self.contacts?.coach_title_5 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_title_5 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Email", text: Binding<String>(
                                        get: { self.contacts?.coach_email_5 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_email_5 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                    
                                    TextField("Phone", text: Binding<String>(
                                        get: { self.contacts?.coach_phone_5 ?? "" },
                                        set: { newValue in
                                            // Ensures resume is not nil before setting its name
                                            self.contacts?.coach_phone_5 = newValue
                                            collegeViewModel.saveColleges()
                                        }
                                    ))
                                }
                                Button("Delete College") {
                                    self.showingDeleteAlert = true
                                }
                                .foregroundColor(.red)
                                .padding()
                            }
                            .frame(minWidth: 300)
                            .alert(isPresented: $showingDeleteAlert) {
                                Alert(
                                    title: Text("Delete College?"),
                                    message: Text("Are you sure you want to delete this college?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        // Perform the deletion
                                        if let contacts = contacts {
                                            collegeViewModel.deleteCollege(contacts)
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                            
                            .onAppear {
                                // Assuming your ResumeViewModel has a method or computed property to fetch or access the resume data
                                
                            }
                        }
                        
                        
                    }
                    
                }
                
                struct CollegeContactsView: View {
                    @ObservedObject var collegeViewModel: CollegeViewModel
                    
                    // Precomputed Sorted Colleges
                    private var sortedColleges: [CollegeData] {
                        collegeViewModel.colleges.sorted {
                            ($0.college_number?.intValue ?? 0) < ($1.college_number?.intValue ?? 0)
                        }
                    }
                    
                    var body: some View {
                        TabView {
                            ForEach(sortedColleges, id: \.self) { contact in
                                CollegeContactsTabView(contacts: contact, viewModel: collegeViewModel)
                                    .tabItem {
                                        Label("College \(contact.college_number?.intValue ?? 0)", systemImage: "person.fill")
                                    }
                            }
                        }
                        
                        .toolbar {
                            ToolbarItem(placement: .primaryAction) {
                                Button(action: {
                                    // Find the maximum resume_number in the current array
                                    let maxCollegeNumber = collegeViewModel.colleges.max(by: {
                                        ($0.college_number?.intValue ?? 0) < ($1.college_number?.intValue ?? 0)
                                    })?.college_number?.intValue ?? 0
                                    
                                    // Create a new ResumeData instance
                                    let newCollege = CollegeData(context: collegeViewModel.context) // Adjust initialization as needed
                                    
                                    // Set the resume_number to one more than the current maximum
                                    newCollege.college_number = NSNumber(value: maxCollegeNumber + 1)
                                    
                                    // Append the new ResumeData instance to the resumes array
                                    collegeViewModel.colleges.append(newCollege)
                                    
                                    // Save changes to the context
                                    do {
                                        try collegeViewModel.context.save()
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
                        
                        .navigationTitle("Colleges")
                    }
                    
                    
                }
