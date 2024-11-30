//
//  MustacheARAppApp.swift
//  MustacheARApp
//
//  Created by Yogansh Makkar on 29/11/2024.
//

import SwiftUI

@main
struct MustacheARAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
