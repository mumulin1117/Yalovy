import UIKit

final class HabitTransition: UIView {
    init(
        coatSheen: String,
        ingredientGlossary: String,
        lengthMeasure: String,
        seasonalChange: String,
        colorSaturation: UIColor
    ) {
        super.init(frame: .zero)
        let silhouetteFraming = UIImageView(image: UIImage(systemName: coatSheen))
        silhouetteFraming.tintColor = colorSaturation
        silhouetteFraming.contentMode = .scaleAspectFit
        silhouetteFraming.frame = CGRect(x: 30, y: 2, width: 38, height: 38)
        addSubview(silhouetteFraming)
        let nutrientMatrix = UILabel(frame: CGRect(x: 4, y: 48, width: 90, height: 18))
        nutrientMatrix.text = ingredientGlossary
        nutrientMatrix.textAlignment = .center
        nutrientMatrix.textColor = .twilightCalm
        nutrientMatrix.font = .coatSoftness(11, bodyMassCurve: .semibold)
        addSubview(nutrientMatrix)
        let circumferenceGauge = UILabel(frame: CGRect(x: 3, y: 69, width: 92, height: 43))
        circumferenceGauge.text = lengthMeasure
        circumferenceGauge.numberOfLines = 2
        circumferenceGauge.textAlignment = .center
        circumferenceGauge.textColor = .white
        circumferenceGauge.font = .coatSoftness(15, bodyMassCurve: .bold)
        addSubview(circumferenceGauge)
        let maturationPathway = UILabel(frame: CGRect(x: 2, y: 116, width: 94, height: 42))
        maturationPathway.text = seasonalChange
        maturationPathway.numberOfLines = 2
        maturationPathway.textAlignment = .center
        maturationPathway.textColor = colorSaturation
        maturationPathway.font = .coatSoftness(11, bodyMassCurve: .bold)
        addSubview(maturationPathway)
    }

    required init?(coder: NSCoder) { nil }
}
