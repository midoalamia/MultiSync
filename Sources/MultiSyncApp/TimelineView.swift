import SwiftUI
import MultiSyncCore

final class AppViewModel: ObservableObject {
    @Published var project: SyncProject
    @Published var selectedMedia: [MediaFile] = []
    @Published var syncGroups: [SyncGroup] = []
    @Published var statusMessage = "Ready to sync"

    init() {
        self.project = SyncProject(name: "Wedding Project", mediaFiles: [])
    }

    func newProject() {
        project = SyncProject(name: "Untitled Project", mediaFiles: [])
        statusMessage = "New project created"
    }

    func importMedia() {
        let sampleFiles: [MediaFile] = [
            MediaFile(id: UUID(), path: "/Users/demo/cam-a.mov", name: "cam-a.mov", type: .video, duration: 480.0),
            MediaFile(id: UUID(), path: "/Users/demo/cam-b.mov", name: "cam-b.mov", type: .video, duration: 480.0),
            MediaFile(id: UUID(), path: "/Users/demo/rec-1.wav", name: "rec-1.wav", type: .audio, duration: 480.0)
        ]

        selectedMedia = sampleFiles
        project.mediaFiles = sampleFiles
        statusMessage = "Imported 3 media files"
    }

    func analyzeProject() {
        let engine = SyncEngine()
        let groups = engine.sync(files: project.mediaFiles)
        syncGroups = groups
        statusMessage = groups.isEmpty ? "No sync points found" : "Analysis complete"
    }
}

struct ContentView: View {
    @EnvironmentObject private var appModel: AppViewModel

    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            ProjectOverviewView()
        }
    }
}

struct SidebarView: View {
    @EnvironmentObject private var appModel: AppViewModel

    var body: some View {
        List {
            Section("Projects") {
                Text(appModel.project.name)
                    .font(.headline)
            }

            Section("Media") {
                ForEach(appModel.project.mediaFiles) { file in
                    Label(file.name, systemImage: file.type == .video ? "video.fill" : "waveform")
                }
            }

            Section("Sync") {
                Button("Import Media") { appModel.importMedia() }
                Button("Analyze Sync") { appModel.analyzeProject() }
            }
        }
        .frame(minWidth: 240)
    }
}

struct ProjectOverviewView: View {
    @EnvironmentObject private var appModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("MultiSync")
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button("Export") {
                    // Placeholder export step.
                }
                .buttonStyle(.borderedProminent)
            }

            Text(appModel.statusMessage)
                .foregroundStyle(.secondary)

            Divider()

            TimelineView(groups: appModel.syncGroups)

            if !appModel.syncGroups.isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(appModel.syncGroups) { group in
                            VStack(alignment: .leading) {
                                Text("Group: \(group.name)")
                                    .font(.headline)
                                Text("Reference: \(group.referenceMedia.name)")
                                    .font(.subheadline)
                                Text("Offset: \(group.offset, specifier: "%.2f")s")
                                    .font(.subheadline)
                            }
                            .padding(8)
                            .background(Color.secondary.opacity(0.08))
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
