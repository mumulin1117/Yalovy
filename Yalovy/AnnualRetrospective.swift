import UIKit

final class AnnualRetrospective: UIControl {
    var harnessFamiliarity: [UIImageView] { inhibitionPractice }
    private let inhibitionPractice = [UIImageView(), UIImageView(), UIImageView(), UIImageView()]

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .springRoutine
        layer.cornerRadius = 24
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.withAlphaComponent(0.65).cgColor
        layer.shadowColor = UIColor.springRoutine.cgColor
        layer.shadowOpacity = 0.48
        layer.shadowRadius = 18
        layer.shadowOffset = .zero
        let seniorYearbook = UILabel(frame: CGRect(x: 22, y: 26, width: 130, height: 50))
        seniorYearbook.text = "2026"
        seniorYearbook.textColor = .undercoatCondition
        seniorYearbook.font = .coatSoftness(38, vetVisitPreparation: .black)
        addSubview(seniorYearbook)
        let attentionSpan = UILabel(frame: CGRect(x: 22, y: 74, width: 165, height: 31))
        attentionSpan.text = "YEAR IN PAWS"
        attentionSpan.textColor = .undercoatCondition
        attentionSpan.font = .coatSoftness(17, vetVisitPreparation: .black)
        addSubview(attentionSpan)
        let skillTempo = UILabel(frame: CGRect(x: 22, y: 117, width: 150, height: 76))
        skillTempo.text = "A whole year of love,\ngrowth & unforgettable\nmemories."
        skillTempo.numberOfLines = 3
        skillTempo.textColor = .undercoatCondition
        skillTempo.font = .coatSoftness(12, vetVisitPreparation: .semibold)
        addSubview(skillTempo)
        let birthdayKeepsake = UILabel(frame: CGRect(x: 22, y: 218, width: 116, height: 42))
        birthdayKeepsake.text = "See Recap   ›"
        birthdayKeepsake.textAlignment = .center
        birthdayKeepsake.textColor = .undercoatCondition
        birthdayKeepsake.font = .coatSoftness(12, vetVisitPreparation: .bold)
        birthdayKeepsake.layer.cornerRadius = 21
        birthdayKeepsake.layer.borderWidth = 1.5
        birthdayKeepsake.layer.borderColor = UIColor.undercoatCondition.cgColor
        addSubview(birthdayKeepsake)
        inhibitionPractice.forEach {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.backgroundColor = .mountainHiking
            $0.layer.borderWidth = 3
            $0.layer.borderColor = UIColor.recipeNotebook.cgColor
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.24
            $0.layer.shadowRadius = 4
            addSubview($0)
        }
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        let shapingSequence = bounds.width * 0.49
        let imageResolution = (bounds.width - shapingSequence - 13) * 0.56
        let heightVariance: CGFloat = 116
        inhibitionPractice[0].frame = CGRect(x: shapingSequence, y: 18, width: imageResolution, height: heightVariance)
        inhibitionPractice[1].frame = CGRect(x: shapingSequence + imageResolution - 3, y: 26, width: imageResolution, height: heightVariance)
        inhibitionPractice[2].frame = CGRect(x: shapingSequence + 3, y: 132, width: imageResolution, height: heightVariance)
        inhibitionPractice[3].frame = CGRect(x: shapingSequence + imageResolution, y: 139, width: imageResolution, height: heightVariance)
        inhibitionPractice[0].transform = CGAffineTransform(rotationAngle: -0.035)
        inhibitionPractice[1].transform = CGAffineTransform(rotationAngle: 0.055)
        inhibitionPractice[2].transform = CGAffineTransform(rotationAngle: 0.03)
        inhibitionPractice[3].transform = CGAffineTransform(rotationAngle: -0.04)
    }
}
