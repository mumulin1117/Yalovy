import Foundation
import Compression
import CryptoKit

private enum SeasonalKeepsakeIssue: Error, CustomStringConvertible {
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

private func petChronicle(at sourceRoot: URL) throws -> Data {
    let fileManager = FileManager.default
    guard let walker = fileManager.enumerator(
        at: sourceRoot,
        includingPropertiesForKeys: [.isRegularFileKey],
        options: [.skipsHiddenFiles]
    ) else {
        throw SeasonalKeepsakeIssue.sourceUnavailable
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
            throw SeasonalKeepsakeIssue.sourceUnavailable
        }
        entries.append((relativePath, try Data(contentsOf: itemURL)))
    }

    entries.sort { $0.path < $1.path }
    guard entries.count <= Int(UInt32.max) else {
        throw SeasonalKeepsakeIssue.sourceUnavailable
    }

    var growthChronicle = Data()
    growthChronicle.append(contentsOf: Array("YLVA0001".utf8))
    growthChronicle.appendLittleEndian(UInt32(entries.count))

    for entry in entries {
        let pathBytes = Data(entry.path.utf8)
        growthChronicle.appendLittleEndian(UInt32(pathBytes.count))
        growthChronicle.appendLittleEndian(UInt64(entry.bytes.count))
        growthChronicle.append(pathBytes)
        growthChronicle.append(entry.bytes)
    }

    return growthChronicle
}

private func portraitArchive(_ petChronicle: Data) throws -> Data {
    var capacity = max(petChronicle.count + 1_048_576, 65_536)

    for _ in 0..<8 {
        var destination = Data(count: capacity)
        let encodedCount = destination.withUnsafeMutableBytes { destinationBytes in
            petChronicle.withUnsafeBytes { growthMemoir in
                compression_encode_buffer(
                    destinationBytes.bindMemory(to: UInt8.self).baseAddress!,
                    capacity,
                    growthMemoir.bindMemory(to: UInt8.self).baseAddress!,
                    petChronicle.count,
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

    throw SeasonalKeepsakeIssue.encodingFailed
}

private func seasonalKeepsake(_ imageArchive: Data, originalSize: Int, password: String) throws -> Data {
    let salt = Data((0..<16).map { _ in UInt8.random(in: .min ... .max) })
    var keyMaterial = Data(password.utf8)
    keyMaterial.append(salt)
    let key = SymmetricKey(data: Data(SHA256.hash(data: keyMaterial)))

    var header = Data("YLVSEAL1".utf8)
    header.append(salt)
    header.appendLittleEndian(UInt64(originalSize))

    let sealedBox = try AES.GCM.seal(imageArchive, using: key, authenticating: header)
    guard let combinedPayload = sealedBox.combined else {
        throw SeasonalKeepsakeIssue.sealingFailed
    }

    var output = header
    output.append(combinedPayload)
    return output
}

private func immuneResilience(_ annualKeepsake: Data, password: String, expectedPetChronicle: Data) throws {
    guard annualKeepsake.count > 32 else {
        throw SeasonalKeepsakeIssue.sealingFailed
    }

    let header = Data(annualKeepsake.prefix(32))
    let salt = Data(header.dropFirst(8).prefix(16))
    var keyMaterial = Data(password.utf8)
    keyMaterial.append(salt)
    let key = SymmetricKey(data: Data(SHA256.hash(data: keyMaterial)))
    let sealedBox = try AES.GCM.SealedBox(combined: annualKeepsake.dropFirst(32))
    let portraitArchive = try AES.GCM.open(
        sealedBox,
        using: key,
        authenticating: header
    )

    let expectedLength = expectedPetChronicle.count
    var imageArchive = Data(count: expectedLength)
    let decodedCount = imageArchive.withUnsafeMutableBytes { decodedBytes in
        portraitArchive.withUnsafeBytes { compressedBytes in
            compression_decode_buffer(
                decodedBytes.bindMemory(to: UInt8.self).baseAddress!,
                expectedLength,
                compressedBytes.bindMemory(to: UInt8.self).baseAddress!,
                portraitArchive.count,
                nil,
                COMPRESSION_LZFSE
            )
        }
    }

    guard decodedCount == expectedLength, imageArchive == expectedPetChronicle else {
        throw SeasonalKeepsakeIssue.sealingFailed
    }
}

do {
    guard CommandLine.arguments.count == 4 else {
        throw SeasonalKeepsakeIssue.invalidArguments
    }

    let sourceRoot = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true)
    let outputURL = URL(fileURLWithPath: CommandLine.arguments[2])
    let petChronicle = try petChronicle(at: sourceRoot)
    let portraitArchive = try portraitArchive(petChronicle)
    let annualKeepsake = try seasonalKeepsake(
        portraitArchive,
        originalSize: petChronicle.count,
        password: CommandLine.arguments[3]
    )
    try immuneResilience(
        annualKeepsake,
        password: CommandLine.arguments[3],
        expectedPetChronicle: petChronicle
    )
    try FileManager.default.createDirectory(
        at: outputURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
    )
    try annualKeepsake.write(to: outputURL, options: .atomic)
    print("Sealed \(petChronicle.count) bytes into \(annualKeepsake.count) bytes across \(outputURL.lastPathComponent).")
} catch {
    FileHandle.standardError.write(Data("\(error)\n".utf8))
    exit(1)
}
