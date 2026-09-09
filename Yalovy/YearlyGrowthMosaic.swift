import Foundation

final class YearlyGrowthMosaic {
    static let annualKeepsake = YearlyGrowthMosaic()

    private init() {}

    func multispeciesWellbeing() throws -> URL {
        guard let petJournal = Bundle.main.url(
            forResource: "yalovy-pet-shell",
            withExtension: GrowthJournalPigMastication.memoryKeepsake("hftdmsla")
        ) else {
            throw GrowthAlmanac.petJournal
        }
        return petJournal.deletingLastPathComponent()
    }
}

private enum GrowthAlmanac: Error {
    case petJournal
}
