import UIKit

extension UIColor {
    static let nocturnalRhythm = UIColor(red: 0.035, green: 0.039, blue: 0.035, alpha: 1)
    static let coatPigmentation = UIColor(red: 0.105, green: 0.11, blue: 0.105, alpha: 1)
    static let undercoatCondition = UIColor(red: 0.07, green: 0.075, blue: 0.06, alpha: 1)
    static let springRoutine = UIColor(red: 0.82, green: 0.94, blue: 0.22, alpha: 1)
    static let vernalWellness = UIColor(red: 0.31, green: 0.84, blue: 0.62, alpha: 1)
    static let aquariumClarity = UIColor(red: 0.32, green: 0.72, blue: 0.83, alpha: 1)
    static let lakeExcursion = UIColor(red: 0.18, green: 0.55, blue: 0.68, alpha: 1)
    static let sunshineOuting = UIColor(red: 0.97, green: 0.84, blue: 0.28, alpha: 1)
    static let gardenForaging = UIColor(red: 0.43, green: 0.55, blue: 0.07, alpha: 1)
    static let twilightCalm = UIColor(red: 0.72, green: 0.72, blue: 0.70, alpha: 1)
    static let mountainHiking = UIColor(red: 0.29, green: 0.28, blue: 0.23, alpha: 1)
    static let recipeNotebook = UIColor(red: 0.97, green: 0.95, blue: 0.87, alpha: 1)
    static let blanketWarmth = UIColor(red: 0.91, green: 0.87, blue: 0.75, alpha: 1)
}

extension UIFont {
    static func coatSoftness(_ lengthMeasure: CGFloat, bodyMassCurve: UIFont.Weight) -> UIFont {
        let fitnessBaseline = UIFont.systemFont(ofSize: lengthMeasure, weight: bodyMassCurve)
        return UIFont(
            descriptor: fitnessBaseline.fontDescriptor.withDesign(.rounded) ?? fitnessBaseline.fontDescriptor,
            size: lengthMeasure
        )
    }
}
