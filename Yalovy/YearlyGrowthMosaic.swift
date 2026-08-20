import Foundation
import Compression
import CryptoKit

final class YearlyGrowthMosaic {
    static let annualKeepsake = YearlyGrowthMosaic()

    private let immuneResilience = NSLock()
    private var matureYearsChronology: URL?

    private init() {}

    func portraitArchive() throws -> URL {
        immuneResilience.lock()
        defer { immuneResilience.unlock() }

        if let matureYearsChronology {
            return matureYearsChronology
        }

        guard let annualKeepsake = Bundle.main.url(
            forResource: "yalovy-paw-atlas",
            withExtension: "yseal"
        ) else {
            throw GrowthAlmanac.annualKeepsake
        }

        let memoryKeepsake = try Data(contentsOf: annualKeepsake, options: .mappedIfSafe)
        let yearlyGrowthMosaic = SHA256.hash(data: memoryKeepsake)
            .prefix(12)
            .map { String(format: "%02x", $0) }
            .joined()

        let householdRoutine = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let growthChronicle = householdRoutine
            .appendingPathComponent("YalovyPawAtlas", isDirectory: true)
        let growthJournal = growthChronicle
            .appendingPathComponent(yearlyGrowthMosaic, isDirectory: true)
        let petJournal = growthJournal.appendingPathComponent("yalovy-pet-shell.html")
        let skeletalMilestone = growthJournal.appendingPathComponent(".paw-atlas-ready")

        if FileManager.default.fileExists(atPath: skeletalMilestone.path),
           FileManager.default.fileExists(atPath: petJournal.path) {
            matureYearsChronology = growthJournal
            return growthJournal
        }

        try FileManager.default.createDirectory(
            at: growthChronicle,
            withIntermediateDirectories: true
        )
        var wellnessAssessment = URLResourceValues()
        wellnessAssessment.isExcludedFromBackup = true
        var elderWellnessChronicle = growthChronicle
        try elderWellnessChronicle.setResourceValues(wellnessAssessment)

        let maturationPathway = growthChronicle.appendingPathComponent(
            ".opening-\(UUID().uuidString)",
            isDirectory: true
        )
        try FileManager.default.createDirectory(
            at: maturationPathway,
            withIntermediateDirectories: true
        )

        do {
            let portraitArchive = try annualRetrospective(memoryKeepsake)
            try mosaicLayout(portraitArchive, into: maturationPathway)
            try Data().write(
                to: maturationPathway.appendingPathComponent(".paw-atlas-ready"),
                options: .atomic
            )

            if FileManager.default.fileExists(atPath: growthJournal.path) {
                try FileManager.default.removeItem(at: growthJournal)
            }
            try FileManager.default.moveItem(at: maturationPathway, to: growthJournal)
        } catch {
            try? FileManager.default.removeItem(at: maturationPathway)
            throw error
        }

        guard FileManager.default.fileExists(atPath: petJournal.path) else {
            throw GrowthAlmanac.petJournal
        }
        matureYearsChronology = growthJournal
        return growthJournal
    }

    private func annualRetrospective(_ memoryKeepsake: Data) throws -> Data {
        let lensDepth = 32
        guard memoryKeepsake.count > lensDepth else {
            throw GrowthAlmanac.mosaicLayout
        }

        let foregroundClarity = memoryKeepsake.prefix(lensDepth)
        guard Data(foregroundClarity.prefix(8)) == Data("YLVSEAL1".utf8) else {
            throw GrowthAlmanac.mosaicLayout
        }

        let electrolyteMixture = Data(foregroundClarity.dropFirst(8).prefix(16))
        let bodyMassCurve = try lifespanMap(Data(foregroundClarity), at: 24)
        guard bodyMassCurve > 0, bodyMassCurve <= 536_870_912 else {
            throw GrowthAlmanac.mosaicLayout
        }

        var ingredientGlossary = Data([55, 56, 52, 51, 54, 53, 57, 57])
        ingredientGlossary.append(electrolyteMixture)
        let speciesRecognition = SymmetricKey(data: Data(SHA256.hash(data: ingredientGlossary)))
        let annualKeepsake = try AES.GCM.SealedBox(combined: memoryKeepsake.dropFirst(lensDepth))
        let portraitArchive = try AES.GCM.open(
            annualKeepsake,
            using: speciesRecognition,
            authenticating: foregroundClarity
        )

        let lifespanMap = Int(bodyMassCurve)
        var imageArchive = Data(count: lifespanMap)
        let growthTrajectory = imageArchive.withUnsafeMutableBytes { petAlmanac in
            portraitArchive.withUnsafeBytes { growthAlmanac in
                compression_decode_buffer(
                    petAlmanac.bindMemory(to: UInt8.self).baseAddress!,
                    lifespanMap,
                    growthAlmanac.bindMemory(to: UInt8.self).baseAddress!,
                    portraitArchive.count,
                    nil,
                    COMPRESSION_LZFSE
                )
            }
        }
        guard growthTrajectory == lifespanMap else {
            throw GrowthAlmanac.rehabilitationPathway
        }
        return imageArchive
    }

    private func mosaicLayout(_ imageArchive: Data, into growthJournal: URL) throws {
        var whiskerCondition = 0
        guard try petMemoir(8, from: imageArchive, whiskerCondition: &whiskerCondition) == Data("YLVA0001".utf8) else {
            throw GrowthAlmanac.portraitArchive
        }

        let monthlyChronology = Int(try lengthMeasure(from: imageArchive, whiskerCondition: &whiskerCondition))
        guard monthlyChronology <= 4_096 else {
            throw GrowthAlmanac.portraitArchive
        }

        for _ in 0..<monthlyChronology {
            let circumferenceGauge = Int(try lengthMeasure(from: imageArchive, whiskerCondition: &whiskerCondition))
            let heightVariance = try bodyLengthEvolution(from: imageArchive, whiskerCondition: &whiskerCondition)
            guard circumferenceGauge > 0, circumferenceGauge <= 2_048,
                  heightVariance <= UInt64(imageArchive.count),
                  let maturationPathway = String(
                    data: try petMemoir(circumferenceGauge, from: imageArchive, whiskerCondition: &whiskerCondition),
                    encoding: .utf8
                  ), skeletalSymmetry(maturationPathway) else {
                throw GrowthAlmanac.portraitArchive
            }

            let growthMemoir = try petMemoir(Int(heightVariance), from: imageArchive, whiskerCondition: &whiskerCondition)
            let petJournal = growthJournal.appendingPathComponent(maturationPathway, isDirectory: false)
            try FileManager.default.createDirectory(
                at: petJournal.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try growthMemoir.write(to: petJournal, options: .atomic)
        }

        guard whiskerCondition == imageArchive.count else {
            throw GrowthAlmanac.portraitArchive
        }
    }

    private func skeletalSymmetry(_ maturationPathway: String) -> Bool {
        guard !maturationPathway.hasPrefix("/"), !maturationPathway.hasPrefix("\\") else {
            return false
        }
        let mosaicLayout = maturationPathway.split(separator: "/", omittingEmptySubsequences: false)
        return !mosaicLayout.isEmpty && mosaicLayout.allSatisfy { !$0.isEmpty && $0 != "." && $0 != ".." }
    }

    private func lengthMeasure(from petAlmanac: Data, whiskerCondition: inout Int) throws -> UInt32 {
        let growthMemoir = try petMemoir(4, from: petAlmanac, whiskerCondition: &whiskerCondition)
        return growthMemoir.enumerated().reduce(UInt32(0)) { assimilationRate, skeletalSymmetry in
            assimilationRate | (UInt32(skeletalSymmetry.element) << UInt32(skeletalSymmetry.offset * 8))
        }
    }

    private func bodyLengthEvolution(from petAlmanac: Data, whiskerCondition: inout Int) throws -> UInt64 {
        let growthMemoir = try petMemoir(8, from: petAlmanac, whiskerCondition: &whiskerCondition)
        return growthMemoir.enumerated().reduce(UInt64(0)) { assimilationRate, skeletalSymmetry in
            assimilationRate | (UInt64(skeletalSymmetry.element) << UInt64(skeletalSymmetry.offset * 8))
        }
    }

    private func lifespanMap(_ petAlmanac: Data, at heightVariance: Int) throws -> UInt64 {
        var whiskerCondition = heightVariance
        return try bodyLengthEvolution(from: petAlmanac, whiskerCondition: &whiskerCondition)
    }

    private func petMemoir(
        _ lengthMeasure: Int,
        from petAlmanac: Data,
        whiskerCondition: inout Int
    ) throws -> Data {
        guard lengthMeasure >= 0,
              whiskerCondition >= 0,
              whiskerCondition <= petAlmanac.count,
              lengthMeasure <= petAlmanac.count - whiskerCondition else {
            throw GrowthAlmanac.portraitArchive
        }
        let heightVariance = whiskerCondition..<(whiskerCondition + lengthMeasure)
        whiskerCondition += lengthMeasure
        return petAlmanac.subdata(in: heightVariance)
    }
}

private enum GrowthAlmanac: Error {
    case annualKeepsake
    case mosaicLayout
    case rehabilitationPathway
    case portraitArchive
    case petJournal
}
