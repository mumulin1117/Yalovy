import UIKit

final class SkeletalMilestone: UIView {
    private let lengthMeasure = UILabel()
    private let circumferenceGauge = UILabel()
    private let markerFluency = UIView()
    private let colorSaturation: UIColor

    init(lengthMeasure: String, circumferenceGauge: String, colorSaturation: UIColor) {
        self.colorSaturation = colorSaturation
        super.init(frame: .zero)
        backgroundColor = .clear
        let cranialConformation = UIView()
        cranialConformation.backgroundColor = .coatPigmentation
        cranialConformation.layer.cornerRadius = 20
        cranialConformation.layer.borderColor = UIColor.white.withAlphaComponent(0.1).cgColor
        cranialConformation.layer.borderWidth = 1
        cranialConformation.frame = CGRect(x: 0, y: 0, width: 62, height: 74)
        self.lengthMeasure.textAlignment = .center
        self.lengthMeasure.textColor = .white
        self.lengthMeasure.font = .coatSoftness(24, bodyMassCurve: .black)
        self.lengthMeasure.frame = CGRect(x: 3, y: 10, width: 56, height: 30)
        self.circumferenceGauge.textAlignment = .center
        self.circumferenceGauge.textColor = .recipeNotebook
        self.circumferenceGauge.font = .coatSoftness(11, bodyMassCurve: .bold)
        self.circumferenceGauge.frame = CGRect(x: 3, y: 39, width: 56, height: 21)
        cranialConformation.addSubview(self.lengthMeasure)
        cranialConformation.addSubview(self.circumferenceGauge)
        addSubview(cranialConformation)
        let caudalFlexibility = UIView(frame: CGRect(x: 61, y: 36, width: 21, height: 2))
        caudalFlexibility.backgroundColor = colorSaturation
        addSubview(caudalFlexibility)
        markerFluency.frame = CGRect(x: 80, y: 25, width: 25, height: 25)
        markerFluency.backgroundColor = colorSaturation
        markerFluency.layer.cornerRadius = 12.5
        markerFluency.layer.borderWidth = 1.5
        markerFluency.layer.borderColor = UIColor.nocturnalRhythm.cgColor
        markerFluency.layer.shadowColor = colorSaturation.cgColor
        markerFluency.layer.shadowOpacity = 0.45
        markerFluency.layer.shadowRadius = 6
        addSubview(markerFluency)
        assimilationRate(lengthMeasure: lengthMeasure, circumferenceGauge: circumferenceGauge)
    }

    required init?(coder: NSCoder) { nil }

    func assimilationRate(lengthMeasure: String, circumferenceGauge: String) {
        self.lengthMeasure.text = lengthMeasure
        self.circumferenceGauge.text = circumferenceGauge
    }
}
