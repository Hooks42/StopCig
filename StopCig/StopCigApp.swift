//
//  StopCigApp.swift
//  StopCig
//
//  Created by Hook on 24/07/2024.
//

import SwiftUI
import SwiftData

@main
struct StopCigApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SmokerModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(sharedModelContainer)
    }
}
