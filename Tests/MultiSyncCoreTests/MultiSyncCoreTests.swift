import Foundation

public final class ExportManager {
    public init() {}

    public func export(project: SyncProject, to destination: URL, with format: NLEType) throws {
        let metadata = [
            "project": project.name,
            "format": format.rawValue,
            "count": String(project.mediaFiles.count)
        ]

        let data = metadata.map { "\($0.key)=\($0.value)" }.joined(separator: "\n")
        try data.write(to: destination, atomically: true, encoding: .utf8)
    }
}

public struct FinalCutProExporter {
    public init() {}

    public func export(project: SyncProject, to destination: URL) throws {
        try ExportManager().export(project: project, to: destination, with: .finalCutPro)
    }
}

public struct PremiereProExporter {
    public init() {}

    public func export(project: SyncProject, to destination: URL) throws {
        try ExportManager().export(project: project, to: destination, with: .premierePro)
    }
}

public struct DaVinciExporter {
    public init() {}

    public func export(project: SyncProject, to destination: URL) throws {
        try ExportManager().export(project: project, to: destination, with: .davinciResolve)
    }
}
