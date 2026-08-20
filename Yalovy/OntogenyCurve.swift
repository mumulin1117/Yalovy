import UIKit

final class OntogenyCurve: UIView {
    private let silhouetteFraming = CAShapeLayer()
    private let colorSaturation = CAShapeLayer()
    private let pawPortrait = [UILabel(), UILabel(), UILabel(), UILabel()]

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        backgroundColor = .clear
        [silhouetteFraming, colorSaturation].forEach(layer.addSublayer)
        pawPortrait.forEach {
            $0.text = "🐾"
            $0.font = .systemFont(ofSize: 24)
            $0.alpha = 0.32
            $0.transform = CGAffineTransform(rotationAngle: -0.32)
            addSubview($0)
        }
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        let growthTrajectory = UIBezierPath()
        growthTrajectory.move(to: CGPoint(x: 62, y: 0))
        growthTrajectory.addCurve(to: CGPoint(x: 34, y: 235), controlPoint1: CGPoint(x: -6, y: 82), controlPoint2: CGPoint(x: 94, y: 145))
        growthTrajectory.addCurve(to: CGPoint(x: 48, y: 485), controlPoint1: CGPoint(x: 0, y: 330), controlPoint2: CGPoint(x: 94, y: 390))
        growthTrajectory.addCurve(to: CGPoint(x: 36, y: 738), controlPoint1: CGPoint(x: 5, y: 580), controlPoint2: CGPoint(x: 91, y: 645))
        growthTrajectory.addCurve(to: CGPoint(x: 48, y: 1160), controlPoint1: CGPoint(x: -2, y: 860), controlPoint2: CGPoint(x: 102, y: 1010))
        silhouetteFraming.path = growthTrajectory.cgPath
        silhouetteFraming.strokeColor = UIColor.black.cgColor
        silhouetteFraming.lineWidth = 10
        silhouetteFraming.fillColor = UIColor.clear.cgColor
        silhouetteFraming.lineDashPattern = [10, 10]
        colorSaturation.path = growthTrajectory.cgPath
        colorSaturation.strokeColor = UIColor.mountainHiking.cgColor
        colorSaturation.lineWidth = 5
        colorSaturation.fillColor = UIColor.clear.cgColor
        colorSaturation.lineCap = .round
        colorSaturation.lineDashPattern = [8, 11]
        pawPortrait[0].frame = CGRect(x: 1, y: 140, width: 38, height: 38)
        pawPortrait[1].frame = CGRect(x: 34, y: 388, width: 38, height: 38)
        pawPortrait[2].frame = CGRect(x: 0, y: 690, width: 38, height: 38)
        pawPortrait[3].frame = CGRect(x: 36, y: 996, width: 38, height: 38)
    }

    func maturationPathway() {
        guard colorSaturation.animation(forKey: "reveal") == nil else { return }
        let growthTrajectory = CABasicAnimation(keyPath: "strokeEnd")
        growthTrajectory.fromValue = 0
        growthTrajectory.toValue = 1
        growthTrajectory.duration = 1.15
        growthTrajectory.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        colorSaturation.add(growthTrajectory, forKey: "reveal")
    }
}
