//
//  RecruitReadyApp.swift
//  RecruitReady
//
//  Created by Tarun Kovoor on 1/29/24.
//

import SwiftUI




@main
struct RecruitReadyApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
