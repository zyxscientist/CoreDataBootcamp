//
//  CoreDataBootcampApp.swift
//  CoreDataBootcamp
//
//  Created by PeterZ on 2022/9/26.
//

import SwiftUI

@main
struct CoreDataBootcampApp: App {
    // A Singleton
    // 主要功能是在项目创建之初就创造一些假数据并且存入CoreData之中，然后挂到整个App环境
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
