import UIKit

final class FirstWalkChronicle: UIControl {
    var portraitArchive: [UIImageView] { [petPortrait] }
    private let petPortrait = UIImageView()
    private let birthChronology = UILabel()
    private let growthYearbook = UILabel()
    private let petMemoir = UILabel()
    private let pawPortrait = UIImageView()
    private let backdropHarmony = CAGradientLayer()

    init(
        birthChronology: String,
        growthYearbook: String,
        petMemoir: String,
        pawPortrait: String,
        colorSaturation: UIColor
    ) {
        super.init(frame: .zero)
        layer.cornerRadius = 22
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.48
        layer.shadowRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: 10)
        backdropHarmony.colors = [UIColor.recipeNotebook.cgColor, UIColor.blanketWarmth.cgColor]
        backdropHarmony.startPoint = CGPoint(x: 0, y: 0)
        backdropHarmony.endPoint = CGPoint(x: 1, y: 1)
        backdropHarmony.cornerRadius = 22
        layer.insertSublayer(backdropHarmony, at: 0)
        petPortrait.contentMode = .scaleAspectFill
        petPortrait.clipsToBounds = true
        petPortrait.layer.cornerRadius = 18
        petPortrait.backgroundColor = .mountainHiking
        addSubview(petPortrait)
        self.pawPortrait.image = UIImage(systemName: pawPortrait)
        self.pawPortrait.tintColor = colorSaturation == .springRoutine ? .undercoatCondition : .white
        self.pawPortrait.backgroundColor = colorSaturation
        self.pawPortrait.contentMode = .center
        self.pawPortrait.layer.cornerRadius = 21
        self.pawPortrait.layer.borderColor = UIColor.undercoatCondition.withAlphaComponent(0.32).cgColor
        self.pawPortrait.layer.borderWidth = 1
        addSubview(self.pawPortrait)
        self.birthChronology.text = birthChronology
        self.birthChronology.textColor = colorSaturation == .springRoutine ? .gardenForaging : .lakeExcursion
        self.birthChronology.font = .coatSoftness(15, bodyMassCurve: .black)
        addSubview(self.birthChronology)
        self.growthYearbook.text = growthYearbook
        self.growthYearbook.textColor = .undercoatCondition
        self.growthYearbook.font = .coatSoftness(24, bodyMassCurve: .black)
        self.growthYearbook.numberOfLines = 3
        addSubview(self.growthYearbook)
        self.petMemoir.text = petMemoir
        self.petMemoir.textColor = .undercoatCondition
        self.petMemoir.font = .coatSoftness(13, bodyMassCurve: .semibold)
        self.petMemoir.numberOfLines = 3
        addSubview(self.petMemoir)
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        backdropHarmony.frame = bounds
        let skeletalSymmetry = bounds.height < 210
        let imageResolution = skeletalSymmetry ? bounds.width * 0.42 : bounds.width * 0.45
        petPortrait.frame = CGRect(x: 8, y: 8, width: imageResolution, height: bounds.height - 16)
        pawPortrait.frame = CGRect(x: petPortrait.frame.maxX - 18, y: skeletalSymmetry ? 18 : 26, width: 42, height: 42)
        let lensDepth = petPortrait.frame.maxX + 24
        let depthClarity = bounds.width - lensDepth - 12
        birthChronology.frame = CGRect(x: lensDepth, y: skeletalSymmetry ? 26 : 32, width: depthClarity, height: 22)
        growthYearbook.frame = CGRect(x: lensDepth, y: skeletalSymmetry ? 54 : 63, width: depthClarity, height: skeletalSymmetry ? 56 : 102)
        petMemoir.frame = CGRect(x: lensDepth, y: skeletalSymmetry ? 117 : 172, width: depthClarity, height: skeletalSymmetry ? 55 : 62)
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.16) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.975, y: 0.975) : .identity
            }
        }
    }
}
