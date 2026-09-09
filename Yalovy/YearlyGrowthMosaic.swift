import Foundation

final class YearlyGrowthMosaic {
    static let annualKeepsake = YearlyGrowthMosaic()

    private init() {}

    func portraitArchive() throws -> URL {
        guard let petJournal = Bundle.main.url(
            forResource: "yalovy-pet-shell",
            withExtension: "html"
        ) else {
            throw GrowthAlmanac.petJournal
        }
        return petJournal.deletingLastPathComponent()
    }
}

private enum GrowthAlmanac: Error {
    case petJournal
}
