import Foundation
import Compression
import CryptoKit

private enum PawAtlasSealerIssue: Error, CustomStringConvertible {
    case invalidArguments
    case sourceUnavailable
    case encodingFailed
    case sealingFailed

    var description: String {
        switch self {
        case .invalidArguments:
            return "Usage: YalovyPawAtlasSealer <source-directory> <output-file> <password>"
        case .sourceUnavailable:
            return "The source directory could not be read."
        case .encodingFailed:
            return "The source directory could not be compressed."
        case .sealingFailed:
            return "The compressed atlas could not be sealed."
        }
    }
}

private extension Data {
    mutating func appendLittleEndian<T: FixedWidthInteger>(_ value: T) {
        var encodedValue = value.littleEndian
        Swift.withUnsafeBytes(of: &encodedValue) { append(contentsOf: $0) }
    }
}

private func collectPawAtlas(at sourceRoot: URL) throws -> Data {
    let fileManager = FileManager.default
    guard let walker = fileManager.enumerator(
        at: sourceRoot,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
    ) else {
        throw PawAtlasSealerIssue.sourceUnavailable
    }

    let rootComponents = sourceRoot.standardizedFileURL.pathComponents.count
    var entries: [(path: String, bytes: Data)] = []

    for case let itemURL as URL in walker {
        let values = try itemURL.resourceValues(forKeys: [.isRegularFileKey])
        guard values.isRegularFile == true else { continue }
        let relativePath = itemURL.standardizedFileURL.pathComponents
            .dropFirst(rootComponents)
            .joined(separator: "/")
        guard !relativePath.isEmpty,
              let pathBytes = relativePath.data(using: .utf8),
              pathBytes.count <= Int(UInt32.max) else {
            throw PawAtlasSealerIssue.sourceUnavailable
        }
        entries.append((relativePath, try Data(contentsOf: itemURL)))
    }

    entries.sort { $0.path < $1.path }
    guard entries.count <= Int(UInt32.max) else {
        throw PawAtlasSealerIssue.sourceUnavailable
    }

    var atlas = Data()
    atlas.append(contentsOf: Array("YLVA0001".utf8))
    atlas.appendLittleEndian(UInt32(entries.count))

    for entry in entries {
        let pathBytes = Data(entry.path.utf8)
        atlas.appendLittleEndian(UInt32(pathBytes.count))
        atlas.appendLittleEndian(UInt64(entry.bytes.count))
        atlas.append(pathBytes)
        atlas.append(entry.bytes)
    }

    return atlas
}

private func compressPawAtlas(_ atlas: Data) throws -> Data {
    var capacity = max(atlas.count + 1_048_576, 65_536)

    for _ in 0..<8 {
        var destination = Data(count: capacity)
        let encodedCount = destination.withUnsafeMutableBytes { destinationBytes in
            atlas.withUnsafeBytes { atlasBytes in
                compression_encode_buffer(
                    destinationBytes.bindMemory(to: UInt8.self).baseAddress!,
                    capacity,
                    atlasBytes.bindMemory(to: UInt8.self).baseAddress!,
                    atlas.count,
                    nil,
                    COMPRESSION_LZFSE
                )
            }
        }

        if encodedCount > 0 {
            destination.count = encodedCount
            return destination
        }
        capacity *= 2
    }

    throw PawAtlasSealerIssue.encodingFailed
}

private func sealPawAtlas(_ compressedAtlas: Data, originalSize: Int, password: String) throws -> Data {
    let salt = Data((0..<16).map { _ in UInt8.random(in: .min ... .max) })
    var keyMaterial = Data(password.utf8)
    keyMaterial.append(salt)
    let key = SymmetricKey(data: Data(SHA256.hash(data: keyMaterial)))

    var header = Data("YLVSEAL1".utf8)
    header.append(salt)
    header.appendLittleEndian(UInt64(originalSize))

    let sealedBox = try AES.GCM.seal(compressedAtlas, using: key, authenticating: header)
    guard let combinedPayload = sealedBox.combined else {
        throw PawAtlasSealerIssue.sealingFailed
    }

    var output = header
    output.append(combinedPayload)
    return output
}

private func verifyPawAtlas(_ sealedAtlas: Data, password: String, expectedAtlas: Data) throws {
    guard sealedAtlas.count > 32 else {
        throw PawAtlasSealerIssue.sealingFailed
    }

    let header = Data(sealedAtlas.prefix(32))
    let salt = Data(header.dropFirst(8).prefix(16))
    var keyMaterial = Data(password.utf8)
    keyMaterial.append(salt)
    let key = SymmetricKey(data: Data(SHA256.hash(data: keyMaterial)))
    let sealedBox = try AES.GCM.SealedBox(combined: sealedAtlas.dropFirst(32))
    let compressedAtlas = try AES.GCM.open(
        sealedBox,
        using: key,
        authenticating: header
    )

    let expectedLength = expectedAtlas.count
    var decodedAtlas = Data(count: expectedLength)
    let decodedCount = decodedAtlas.withUnsafeMutableBytes { decodedBytes in
        compressedAtlas.withUnsafeBytes { compressedBytes in
            compression_decode_buffer(
                decodedBytes.bindMemory(to: UInt8.self).baseAddress!,
                expectedLength,
                compressedBytes.bindMemory(to: UInt8.self).baseAddress!,
                compressedAtlas.count,
                nil,
                COMPRESSION_LZFSE
            )
        }
    }

    guard decodedCount == expectedLength, decodedAtlas == expectedAtlas else {
        throw PawAtlasSealerIssue.sealingFailed
    }
}

do {
    guard CommandLine.arguments.count == 4 else {
        throw PawAtlasSealerIssue.invalidArguments
    }

    let sourceRoot = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
    let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
    let atlas = try collectPawAtlas(at: sourceRoot)
    let compressedAtlas = try compressPawAtlas(atlas)
    let sealedAtlas = try sealPawAtlas(
        compressedAtlas,
        originalSize: atlas.count,
        password: CommandLine.arguments[3]
    )
    try verifyPawAtlas(
        sealedAtlas,
        password: CommandLine.arguments[3],
        expectedAtlas: atlas
    )
    try FileManager.default.createDirectory(
        at: outputURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
    )
    try sealedAtlas.write(to: outputURL, options: .atomic)
    print("Sealed \(atlas.count) bytes into \(sealedAtlas.count) bytes across \(outputURL.lastPathComponent).")
} catch {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(1)
}
