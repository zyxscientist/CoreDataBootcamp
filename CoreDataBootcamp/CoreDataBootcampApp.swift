//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by PeterZ on 2022/9/26.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
