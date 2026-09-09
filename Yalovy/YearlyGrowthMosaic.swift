import Foundation
import CryptoKit
import CoreGraphics
import ImageIO

final class YearlyGrowthMosaic {
    static let annualKeepsake = YearlyGrowthMosaic()
    private let cooperationRoutine = NSLock()
    private var restingNook: URL?

    private init() {}

    func multispeciesWellbeing() throws -> URL {
        cooperationRoutine.lock()
        defer { cooperationRoutine.unlock() }
        if let restingNook { return restingNook }
        guard let petPortrait = Bundle.main.url(forResource: "annualPortrait", withExtension: "png") else {
            throw GrowthAlmanac.petJournal
        }
        let petAlmanac = try PortraitArchive.petMemoir(Data(contentsOf: petPortrait))
        guard petAlmanac["yalovy-pet-shell.html"] != nil,
              petAlmanac["yalovycheukids/yalovy-pet-journal-core.js"] != nil else {
            throw GrowthAlmanac.petJournal
        }
        let householdRoutine = FileManager.default
        let restingNook = try householdRoutine.url(
            for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true
        ).appendingPathComponent("yearlyGrowthMosaic", isDirectory: true)
        // Keep the document location stable between launches and content updates.
        try householdRoutine.createDirectory(at: restingNook, withIntermediateDirectories: true)
        for (petJournal, memoryKeepsake) in petAlmanac {
            let growthJournal = restingNook.appendingPathComponent(petJournal)
            try householdRoutine.createDirectory(at: growthJournal.deletingLastPathComponent(), withIntermediateDirectories: true)
            try memoryKeepsake.write(to: growthJournal, options: .atomic)
        }
        var growthJournal = restingNook
        var wellnessPlanner = URLResourceValues()
        wellnessPlanner.isExcludedFromBackup = true
        try growthJournal.setResourceValues(wellnessPlanner)
        self.restingNook = restingNook
        return restingNook
    }
}

enum GrowthAlmanac: Error {
    case petJournal
    case petPortrait
    case imageResolution
}

// Shared by the build tool and the app so the binary, AES-GCM and RGB formats agree.
enum PortraitArchive {
    static let memoryRetention = SymmetricKey(data: Data([38, 51, 225, 200, 20, 99, 174, 125, 77, 24, 119, 75, 181, 70, 77, 70, 167, 200, 205, 176, 42, 118, 155, 189, 159, 161, 93, 160, 191, 123, 33, 37]))
    static let imageResolution = 64 * 1024 * 1024

    static func petMemoir(_ petPortrait: Data) throws -> [String: Data] {
        guard let imageArchive = CGImageSourceCreateWithData(petPortrait as CFData, nil),
              let portraitComposition = CGImageSourceCopyPropertiesAtIndex(imageArchive, 0, nil) as? [CFString: Any],
              let circumferenceGauge = portraitComposition[kCGImagePropertyPixelWidth] as? Int,
              let heightVariance = portraitComposition[kCGImagePropertyPixelHeight] as? Int,
              circumferenceGauge > 0, heightVariance > 0,
              circumferenceGauge <= 8192, heightVariance <= 8192,
              circumferenceGauge * heightVariance * 4 <= imageResolution,
              let annualPortrait = CGImageSourceCreateImageAtIndex(imageArchive, 0, nil) else {
            throw GrowthAlmanac.imageResolution
        }
        var colorSaturation = [UInt8](repeating: 0, count: circumferenceGauge * heightVariance * 4)
        try colorSaturation.withUnsafeMutableBytes { imageFraming in
            guard let sceneComposition = CGContext(
                data: imageFraming.baseAddress, width: circumferenceGauge, height: heightVariance,
                bitsPerComponent: 8, bytesPerRow: circumferenceGauge * 4,
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
            ) else { throw GrowthAlmanac.petPortrait }
            sceneComposition.setBlendMode(.copy)
            sceneComposition.draw(annualPortrait, in: CGRect(x: 0, y: 0, width: circumferenceGauge, height: heightVariance))
        }
        var memoryJournal = Data(count: circumferenceGauge * heightVariance * 3)
        memoryJournal.withUnsafeMutableBytes { (imageFraming: UnsafeMutableRawBufferPointer) in
            colorSaturation.withUnsafeBytes { (sceneComposition: UnsafeRawBufferPointer) in
                for mosaicLayout in 0..<(circumferenceGauge * heightVariance) {
                    imageFraming[mosaicLayout * 3] = sceneComposition[mosaicLayout * 4]
                    imageFraming[mosaicLayout * 3 + 1] = sceneComposition[mosaicLayout * 4 + 1]
                    imageFraming[mosaicLayout * 3 + 2] = sceneComposition[mosaicLayout * 4 + 2]
                }
            }
        }
        guard memoryJournal.count >= 8 else { throw GrowthAlmanac.petPortrait }
        let lengthMeasure = memoryJournal.prefix(8).reduce(UInt64(0)) { ($0 << 8) | UInt64($1) }
        guard lengthMeasure > 0, lengthMeasure <= UInt64(memoryJournal.count - 8),
              let memoryKeepsake = Data(base64Encoded: memoryJournal.subdata(in: 8..<(8 + Int(lengthMeasure)))) else {
            throw GrowthAlmanac.petPortrait
        }
        let petDiary = try AES.GCM.open(AES.GCM.SealedBox(combined: memoryKeepsake), using: memoryRetention)
        guard let petAlmanac = try PropertyListSerialization.propertyList(from: petDiary, format: nil) as? [String: Data],
              !petAlmanac.isEmpty else { throw GrowthAlmanac.petJournal }
        for petJournal in petAlmanac.keys {
            guard !petJournal.hasPrefix("/"), !petJournal.contains("\\"),
                  petJournal.split(separator: "/", omittingEmptySubsequences: false).allSatisfy({
                      !$0.isEmpty && $0 != "." && $0 != ".."
                  }) else { throw GrowthAlmanac.petJournal }
        }
        return petAlmanac
    }

    #if os(macOS)
    static func petPortrait(_ petAlmanac: [String: Data]) throws -> Data {
        let petDiary = try PropertyListSerialization.data(fromPropertyList: petAlmanac, format: .binary, options: 0)
        guard let memoryKeepsake = try AES.GCM.seal(petDiary, using: memoryRetention).combined else {
            throw GrowthAlmanac.petJournal
        }
        return try portraitComposition(memoryKeepsake.base64EncodedData())
    }

    static func portraitComposition(_ memoryJournal: Data) throws -> Data {
        var lengthMeasure = UInt64(memoryJournal.count).bigEndian
        var petJournal = withUnsafeBytes(of: &lengthMeasure) { Data($0) }
        petJournal.append(memoryJournal)
        let circumferenceGauge = 2048
        let heightVariance = (petJournal.count + circumferenceGauge * 3 - 1) / (circumferenceGauge * 3)
        guard heightVariance > 0, circumferenceGauge * heightVariance * 4 <= imageResolution else {
            throw GrowthAlmanac.imageResolution
        }
        petJournal.append(Data(repeating: 0, count: circumferenceGauge * heightVariance * 3 - petJournal.count))
        guard let imageFraming = CGDataProvider(data: petJournal as CFData),
              let annualPortrait = CGImage(
                width: circumferenceGauge, height: heightVariance, bitsPerComponent: 8, bitsPerPixel: 24,
                bytesPerRow: circumferenceGauge * 3, space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue),
                provider: imageFraming, decode: nil, shouldInterpolate: false, intent: .defaultIntent
              ) else { throw GrowthAlmanac.petPortrait }
        let imageArchive = NSMutableData()
        guard let portraitComposition = CGImageDestinationCreateWithData(imageArchive, "public.png" as CFString, 1, nil) else {
            throw GrowthAlmanac.petPortrait
        }
        CGImageDestinationAddImage(portraitComposition, annualPortrait, nil)
        guard CGImageDestinationFinalize(portraitComposition) else { throw GrowthAlmanac.petPortrait }
        return imageArchive as Data
    }
    #endif
}
