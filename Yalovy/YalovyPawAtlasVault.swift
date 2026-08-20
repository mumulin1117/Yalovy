import Foundation
import Compression
import CryptoKit

final class YalovyPawAtlasVault {
    static let shared = YalovyPawAtlasVault()

    private let gate = NSLock()
    private var preparedRoot: URL?

    private init() {}

    func revealPawAtlas() throws -> URL {
        gate.lock()
        defer { gate.unlock() }

        if let preparedRoot {
            return preparedRoot
        }

        guard let sealedURL = Bundle.main.url(
            forResource: "yalovy-paw-atlas",
            withExtension: "yseal"
        ) else {
            throw PawAtlasVaultIssue.sealedAtlasMissing
        }

        let sealedBytes = try Data(contentsOf: sealedURL, options: .mappedIfSafe)
        let atlasStamp = SHA256.hash(data: sealedBytes)
            .prefix(12)
            .map { String(format: "%02x", $0) }
            .joined()

        let applicationSupport = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let vaultHome = applicationSupport
            .appendingPathComponent("YalovyPawAtlas", isDirectory: true)
        let destination = vaultHome
            .appendingPathComponent(atlasStamp, isDirectory: true)
        let entryPage = destination.appendingPathComponent("yalovy-pet-shell.html")
        let completionMark = destination.appendingPathComponent(".paw-atlas-ready")

        if FileManager.default.fileExists(atPath: completionMark.path),
           FileManager.default.fileExists(atPath: entryPage.path) {
            preparedRoot = destination
            return destination
        }

        try FileManager.default.createDirectory(
            at: vaultHome,
            withIntermediateDirectories: true
        )
        var vaultValues = URLResourceValues()
        vaultValues.isExcludedFromBackup = true
        var mutableVaultHome = vaultHome
        try mutableVaultHome.setResourceValues(vaultValues)

        let staging = vaultHome.appendingPathComponent(
            ".opening-\(UUID().uuidString)",
            isDirectory: true
        )
        try FileManager.default.createDirectory(
            at: staging,
            withIntermediateDirectories: true
        )

        do {
            let unsealedArchive = try unseal(sealedBytes)
            try unfold(unsealedArchive, into: staging)
            try Data().write(
                to: staging.appendingPathComponent(".paw-atlas-ready"),
                options: .atomic
            )

            if FileManager.default.fileExists(atPath: destination.path) {
                try FileManager.default.removeItem(at: destination)
            }
            try FileManager.default.moveItem(at: staging, to: destination)
        } catch {
            try? FileManager.default.removeItem(at: staging)
            throw error
        }

        guard FileManager.default.fileExists(atPath: entryPage.path) else {
            throw PawAtlasVaultIssue.entryPageMissing
        }
        preparedRoot = destination
        return destination
    }

    private func unseal(_ sealedBytes: Data) throws -> Data {
        let headerLength = 32
        guard sealedBytes.count > headerLength else {
            throw PawAtlasVaultIssue.invalidEnvelope
        }

        let header = sealedBytes.prefix(headerLength)
        guard Data(header.prefix(8)) == Data("YLVSEAL1".utf8) else {
            throw PawAtlasVaultIssue.invalidEnvelope
        }

        let salt = Data(header.dropFirst(8).prefix(16))
        let originalSize = try decodeUInt64(Data(header), at: 24)
        guard originalSize > 0, originalSize <= 536_870_912 else {
            throw PawAtlasVaultIssue.invalidEnvelope
        }

        var keyMaterial = Data([55, 56, 52, 51, 54, 53, 57, 57])
        keyMaterial.append(salt)
        let key = SymmetricKey(data: Data(SHA256.hash(data: keyMaterial)))
        let sealedBox = try AES.GCM.SealedBox(combined: sealedBytes.dropFirst(headerLength))
        let compressedArchive = try AES.GCM.open(
            sealedBox,
            using: key,
            authenticating: header
        )

        let archiveLength = Int(originalSize)
        var archive = Data(count: archiveLength)
        let decodedCount = archive.withUnsafeMutableBytes { archiveBytes in
            compressedArchive.withUnsafeBytes { compressedBytes in
                compression_decode_buffer(
                    archiveBytes.bindMemory(to: UInt8.self).baseAddress!,
                    archiveLength,
                    compressedBytes.bindMemory(to: UInt8.self).baseAddress!,
                    compressedArchive.count,
                    nil,
                    COMPRESSION_LZFSE
                )
            }
        }
        guard decodedCount == archiveLength else {
            throw PawAtlasVaultIssue.decompressionFailed
        }
        return archive
    }

    private func unfold(_ archive: Data, into destination: URL) throws {
        var cursor = 0
        guard try readBytes(8, from: archive, cursor: &cursor) == Data("YLVA0001".utf8) else {
            throw PawAtlasVaultIssue.invalidArchive
        }

        let itemCount = Int(try readUInt32(from: archive, cursor: &cursor))
        guard itemCount <= 4_096 else {
            throw PawAtlasVaultIssue.invalidArchive
        }

        for _ in 0..<itemCount {
            let pathLength = Int(try readUInt32(from: archive, cursor: &cursor))
            let fileLength = try readUInt64(from: archive, cursor: &cursor)
            guard pathLength > 0, pathLength <= 2_048,
                  fileLength <= UInt64(archive.count),
                  let relativePath = String(
                    data: try readBytes(pathLength, from: archive, cursor: &cursor),
                    encoding: .utf8
                  ), isSafe(relativePath) else {
                throw PawAtlasVaultIssue.invalidArchive
            }

            let fileBytes = try readBytes(Int(fileLength), from: archive, cursor: &cursor)
            let fileURL = destination.appendingPathComponent(relativePath, isDirectory: false)
            try FileManager.default.createDirectory(
                at: fileURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try fileBytes.write(to: fileURL, options: .atomic)
        }

        guard cursor == archive.count else {
            throw PawAtlasVaultIssue.invalidArchive
        }
    }

    private func isSafe(_ relativePath: String) -> Bool {
        guard !relativePath.hasPrefix("/"), !relativePath.hasPrefix("\\") else {
            return false
        }
        let pieces = relativePath.split(separator: "/", omittingEmptySubsequences: false)
        return !pieces.isEmpty && pieces.allSatisfy { !$0.isEmpty && $0 != "." && $0 != ".." }
    }

    private func readUInt32(from data: Data, cursor: inout Int) throws -> UInt32 {
        let bytes = try readBytes(4, from: data, cursor: &cursor)
        return bytes.enumerated().reduce(UInt32(0)) { partial, pair in
            partial | (UInt32(pair.element) << UInt32(pair.offset * 8))
        }
    }

    private func readUInt64(from data: Data, cursor: inout Int) throws -> UInt64 {
        let bytes = try readBytes(8, from: data, cursor: &cursor)
        return bytes.enumerated().reduce(UInt64(0)) { partial, pair in
            partial | (UInt64(pair.element) << UInt64(pair.offset * 8))
        }
    }

    private func decodeUInt64(_ data: Data, at offset: Int) throws -> UInt64 {
        var cursor = offset
        return try readUInt64(from: data, cursor: &cursor)
    }

    private func readBytes(_ length: Int, from data: Data, cursor: inout Int) throws -> Data {
        guard length >= 0, cursor >= 0, cursor <= data.count,
              length <= data.count - cursor else {
            throw PawAtlasVaultIssue.invalidArchive
        }
        let range = cursor..<(cursor + length)
        cursor += length
        return data.subdata(in: range)
    }
}

private enum PawAtlasVaultIssue: Error {
    case sealedAtlasMissing
    case invalidEnvelope
    case decompressionFailed
    case invalidArchive
    case entryPageMissing
}
