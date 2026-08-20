import UIKit

final class BodyMassCurve: UIControl {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .coatPigmentation
        layer.cornerRadius = 22
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.48
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: 10)
        let growthYearbook = UILabel()
        growthYearbook.text = "▥  GROWTH INSIGHTS                         ›"
        growthYearbook.textColor = .springRoutine
        growthYearbook.font = .coatSoftness(14, bodyMassCurve: .black)
        growthYearbook.frame = CGRect(x: 22, y: 18, width: 280, height: 24)
        addSubview(growthYearbook)
        let wellnessAssessment = [
            ("scalemass", "Weight", "8.4 kg", "+2.1 kg\nvs 6 mo", UIColor.aquariumClarity),
            ("door.left.hand.open", "New habit", "waits by\nthe door", "Started at\n10 months", UIColor.springRoutine),
            ("circle.hexagongrid.fill", "Favorite", "yellow ball", "Top pick for\n8 months", UIColor.sunshineOuting)
        ]
        let nutrientMatrix = UIStackView()
        nutrientMatrix.axis = .horizontal
        nutrientMatrix.distribution = .fillEqually
        nutrientMatrix.frame = CGRect(x: 10, y: 55, width: 300, height: 166)
        for wellnessJournal in wellnessAssessment {
            nutrientMatrix.addArrangedSubview(HabitTransition(
                coatSheen: wellnessJournal.0,
                ingredientGlossary: wellnessJournal.1,
                lengthMeasure: wellnessJournal.2,
                seasonalChange: wellnessJournal.3,
                colorSaturation: wellnessJournal.4
            ))
        }
        addSubview(nutrientMatrix)
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        subviews.first?.frame.size.width = bounds.width - 34
        if subviews.count > 1 {
            subviews[1].frame = CGRect(x: 8, y: 54, width: bounds.width - 16, height: bounds.height - 65)
        }
    }
}
