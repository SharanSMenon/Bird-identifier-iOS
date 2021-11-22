//
//  BirdIdentifierApp.swift
//  BirdIdentifier
//
//  Created by Sharan Sajiv Menon on 11/18/21.
//

import SwiftUI

@main
struct BirdIdentifierApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
