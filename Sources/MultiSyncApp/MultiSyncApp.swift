import Foundation
import SwiftUI
import MultiSyncCore

@main
struct MultiSyncApp: App {
    @StateObject private var appModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appModel)
        }
        .commands {
            CommandMenu("Project") {
                Button("New Project") {
                    appModel.newProject()
                }
                Button("Import Media") {
                    appModel.importMedia()
                }
                Button("Analyze Sync") {
                    appModel.analyzeProject()
                }
            }
        }
    }
}
