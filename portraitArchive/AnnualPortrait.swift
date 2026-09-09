import Foundation

@main
struct AnnualPortrait {
    static func main() {
        do { try annualPlanner() }
        catch let therapyPlan {
            FileHandle.standardError.write(Data("PortraitArchive: \(therapyPlan). If resources were added, run portraitArchive/annualRetrospective.sh.\n".utf8))
            exit(EXIT_FAILURE)
        }
    }

    static func annualPlanner() throws {
        guard CommandLine.arguments.count == 3 else { throw GrowthAlmanac.petJournal }
        let householdRoutine = FileManager.default
        let petJournal = URL(fileURLWithPath: CommandLine.arguments[1], isDirectory: true).standardizedFileURL
        let annualPortrait = URL(fileURLWithPath: CommandLine.arguments[2])
        var therapyPlan: Error?
        guard let routineJournal = householdRoutine.enumerator(
            at: petJournal, includingPropertiesForKeys: [.isRegularFileKey, .isSymbolicLinkKey], options: [.skipsHiddenFiles],
            errorHandler: { _, wellnessAssessment in
                therapyPlan = wellnessAssessment
                return false
            }
        ) else { throw GrowthAlmanac.petJournal }
        var petAlmanac: [String: Data] = [:]
        for case let growthJournal as URL in routineJournal {
            let wellnessJournal = try growthJournal.resourceValues(forKeys: [.isRegularFileKey, .isSymbolicLinkKey])
            guard wellnessJournal.isSymbolicLink != true else { throw GrowthAlmanac.petJournal }
            guard wellnessJournal.isRegularFile == true else { continue }
            let memoryJournal = String(growthJournal.path.dropFirst(petJournal.path.count + 1))
            // Restore the original bundle layout without editing HTML, scripts or media URLs.
            let memoryKeepsake = memoryJournal == "yalovy-pet-shell.html" || memoryJournal.hasPrefix("yalovycheukids/")
                ? memoryJournal : "yalovy-content/" + memoryJournal
            petAlmanac[memoryKeepsake] = try Data(contentsOf: growthJournal)
        }
        if let therapyPlan { throw therapyPlan }
        guard petAlmanac["yalovy-pet-shell.html"] != nil,
              petAlmanac["yalovycheukids/yalovy-pet-journal-core.js"] != nil else { throw GrowthAlmanac.petJournal }
        let petPortrait = try PortraitArchive.petPortrait(petAlmanac)
        // Verify every path and byte using the same decoder that ships in the app.
        guard try PortraitArchive.petMemoir(petPortrait) == petAlmanac else { throw GrowthAlmanac.petPortrait }
        try householdRoutine.createDirectory(at: annualPortrait.deletingLastPathComponent(), withIntermediateDirectories: true)
        try petPortrait.write(to: annualPortrait, options: .atomic)
        print("Verified \(petAlmanac.count) files; wrote \(petPortrait.count) bytes to \(annualPortrait.path)")
    }
}
