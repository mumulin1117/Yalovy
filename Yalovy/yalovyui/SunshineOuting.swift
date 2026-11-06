import UIKit

extension UIView {
    func yalovyFill(_ parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
        NSLayoutConstraint.activate([topAnchor.constraint(equalTo: parent.topAnchor), bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor), trailingAnchor.constraint(equalTo: parent.trailingAnchor)])
    }
}

final class SunshineOuting: UIView {
    let sereneImaginationTrail = UIButton()
    private let background = UIImageView()
    private let spinner = UIActivityIndicatorView(style: .large)
    private let label = UILabel()
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 4 / 255, green: 3 / 255, blue: 19 / 255, alpha: 1)
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        background.yalovyFill(self)
        spinner.color = .white
        spinner.hidesWhenStopped = true
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        var button = UIButton.Configuration.filled()
        button.title = "Quick Login"
        button.baseBackgroundColor = UIColor(red: 0.78, green: 0.96, blue: 0.24, alpha: 1)
        button.baseForegroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        button.cornerStyle = .capsule
        sereneImaginationTrail.configuration = button
        [spinner, label, sereneImaginationTrail].forEach { stack.addArrangedSubview($0) }
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        let height = sereneImaginationTrail.heightAnchor.constraint(equalToConstant: 52)
        height.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -32),
            stack.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            label.widthAnchor.constraint(equalTo: stack.widthAnchor),
            sereneImaginationTrail.widthAnchor.constraint(equalTo: stack.widthAnchor), height])
    }
    required init?(coder: NSCoder) { nil }

    func stellarInspirationTrail(stellarReflectionTrail: Bool, stellarThoughtTrail: Bool) {
        background.image = UIImage(named: stellarReflectionTrail
            ? AnniversaryMemoir.Presentation.loadingBackground : AnniversaryMemoir.Presentation.fallbackBackground)
        stack.isHidden = !stellarReflectionTrail
        sereneImaginationTrail.isHidden = !stellarThoughtTrail
    }

    func stellarWonderTrail(_ busy: Bool, velvetCuriosityTrail: String? = nil) {
        sereneImaginationTrail.isEnabled = !busy
        sereneImaginationTrail.alpha = busy ? 0.55 : 1
        label.text = velvetCuriosityTrail ?? (busy ? "Connecting…" : nil)
        busy ? spinner.startAnimating() : spinner.stopAnimating()
    }
}
