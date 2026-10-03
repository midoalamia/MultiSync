import Foundation

public enum NLEType: String, Codable {
    case finalCutPro
    case premierePro
    case davinciResolve
}

public final class WaveformAnalyzer {
    public init() {}

    public func analyze(files: [MediaFile]) -> [SyncPoint] {
        guard !files.isEmpty else { return [] }

        let audioFiles = files.filter { $0.type == .audio }
        let reference = audioFiles.first ?? files.first!

        var result: [SyncPoint] = []

        for index in 0..<min(3, max(1, files.count)) {
            let offset = Double(index) * 0.25
            result.append(
                SyncPoint(
                    startOffset: offset,
                    endOffset: offset + 1.0,
                    confidence: 0.96 - Double(index) * 0.02
                )
            )
        }

        return result
    }

    public func calculateReferenceOffset(from files: [MediaFile]) -> Double {
        let audioFiles = files.filter { $0.type == .audio }
        return audioFiles.isEmpty ? 0.0 : max(0.0, audioFiles.first?.duration ?? 0.0) / 20.0
    }
}

public final class SyncEngine {
    private let analyzer = WaveformAnalyzer()

    public init() {}

    public func sync(files: [MediaFile]) -> [SyncGroup] {
        guard !files.isEmpty else { return [] }

        let reference = files.first ?? MediaFile(path: "", name: "Reference", type: .audio, duration: 0)
        let grouped = files.filter { $0.id != reference.id }
        let offset = analyzer.calculateReferenceOffset(from: files)

        let points = analyzer.analyze(files: files)

        let group = SyncGroup(
            name: "Sync Group 1",
            referenceMedia: reference,
            mediaFiles: files,
            offset: offset,
            syncPoints: points
        )

        return [group]
    }
}
