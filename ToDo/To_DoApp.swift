//
//  To_DoApp.swift
//  To Do
//
//  Created by Bitmorpher 4 on 4/29/21.
//

import SwiftUI

@main
struct To_DoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
