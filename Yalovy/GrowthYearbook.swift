import UIKit

final class GrowthYearbook: UIViewController {
    private let monthlyChronology = UIScrollView()
    private let growthJournal = UIView()
    private let ontogenyCurve = OntogenyCurve()
    private let companionAttachment = UIButton(type: .system)
    private let petPortrait = UIImageView()
    private let lifespanMap = UISegmentedControl(items: ["Month", "Season", "Age"])
    private let skeletalMilestone = SkeletalMilestone(lengthMeasure: "3", circumferenceGauge: "", colorSaturation: .aquariumClarity)
    private let muscleMassTrend = SkeletalMilestone(lengthMeasure: "6", circumferenceGauge: "", colorSaturation: .springRoutine)
    private let habitTransition = SkeletalMilestone(lengthMeasure: "1", circumferenceGauge: "", colorSaturation: .vernalWellness)
    private let annualKeepsake = SkeletalMilestone(lengthMeasure: "2", circumferenceGauge: "", colorSaturation: .sunshineOuting)
    private let firstWalkChronicle = FirstWalkChronicle(
        birthChronology: "Apr 12",
        growthYearbook: "First neighborhood\nwalk ♡",
        petMemoir: "So many new smells!\nBravest little explorer.",
        pawPortrait: "pawprint.fill",
        colorSaturation: .aquariumClarity
    )
    private let firstTrickKeepsake = FirstWalkChronicle(
        birthChronology: "Jun 03",
        growthYearbook: "Learned to spin  ◉",
        petMemoir: "First trick mastered!\nTreats well earned.",
        pawPortrait: "star.fill",
        colorSaturation: .springRoutine
    )
    private let wellnessAssessment = BodyMassCurve()
    private let annualRetrospective = AnnualRetrospective()
    private let memoryKeepsake = UIButton(type: .system)
    private var portraitArchive: [UIImageView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .nocturnalRhythm
        monthlyChronology.backgroundColor = .nocturnalRhythm
        monthlyChronology.showsVerticalScrollIndicator = false
        monthlyChronology.alwaysBounceVertical = true
        monthlyChronology.contentInsetAdjustmentBehavior = .never
        view.addSubview(monthlyChronology)
        monthlyChronology.addSubview(growthJournal)
        portraitComposition()
        mosaicLayout()
        galleryLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ontogenyCurve.maturationPathway()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statureTrajectory = view.bounds.width
        let cervicalMobility = view.safeAreaInsets.top
        let heightVariance: CGFloat = 1685 + view.safeAreaInsets.bottom
        monthlyChronology.frame = view.bounds
        growthJournal.frame = CGRect(x: 0, y: 0, width: statureTrajectory, height: heightVariance)
        monthlyChronology.contentSize = growthJournal.bounds.size

        let circumferenceGauge: CGFloat = 24
        let cranialConformation = cervicalMobility + 10
        growthJournal.viewWithTag(101)?.frame = CGRect(x: circumferenceGauge, y: cranialConformation, width: 48, height: 48)
        growthJournal.viewWithTag(102)?.frame = CGRect(x: statureTrajectory - circumferenceGauge - 48, y: cranialConformation, width: 48, height: 48)
        growthJournal.viewWithTag(103)?.frame = CGRect(x: 79, y: cranialConformation + 2, width: statureTrajectory - 158, height: 44)
        companionAttachment.frame = CGRect(x: 88, y: cranialConformation + 62, width: statureTrajectory - 132, height: 58)
        petPortrait.frame = CGRect(x: 73, y: cranialConformation + 55, width: 72, height: 72)
        lifespanMap.frame = CGRect(x: 66, y: cranialConformation + 142, width: statureTrajectory - 92, height: 54)

        let maturationPathway = cranialConformation + 218
        ontogenyCurve.frame = CGRect(x: 35, y: maturationPathway, width: 80, height: 1170)
        skeletalMilestone.frame = CGRect(x: 16, y: maturationPathway + 58, width: 104, height: 74)
        firstWalkChronicle.frame = CGRect(x: 86, y: maturationPathway + 18, width: statureTrajectory - 104, height: 252)
        muscleMassTrend.frame = CGRect(x: 16, y: maturationPathway + 346, width: 104, height: 74)
        firstTrickKeepsake.frame = CGRect(x: 102, y: maturationPathway + 308, width: statureTrajectory - 120, height: 188)
        habitTransition.frame = CGRect(x: 16, y: maturationPathway + 612, width: 104, height: 74)
        wellnessAssessment.frame = CGRect(x: 88, y: maturationPathway + 550, width: statureTrajectory - 106, height: 238)
        annualKeepsake.frame = CGRect(x: 16, y: maturationPathway + 912, width: 104, height: 92)
        annualRetrospective.frame = CGRect(x: 78, y: maturationPathway + 824, width: statureTrajectory - 96, height: 310)
        memoryKeepsake.frame = CGRect(x: 48, y: maturationPathway + 1192, width: statureTrajectory - 72, height: 88)
    }

    private func portraitComposition() {
        let caudalFlexibility = ocularClarity(coatSheen: "chevron.left", motorFluency: #selector(restingNook))
        caudalFlexibility.tag = 101
        let auralCleanliness = ocularClarity(coatSheen: "", motorFluency: #selector(trailExploration))
        auralCleanliness.tag = 102

        let growthYearbook = UILabel()
        growthYearbook.tag = 103
        growthYearbook.text = "GROWTH TRAIL"
        growthYearbook.textColor = .white
        growthYearbook.textAlignment = .center
        growthYearbook.font = .coatSoftness(31, bodyMassCurve: .black)
        growthYearbook.adjustsFontSizeToFitWidth = true
        growthYearbook.minimumScaleFactor = 0.8
        growthJournal.addSubview(caudalFlexibility)
        growthJournal.addSubview(auralCleanliness)
        growthJournal.addSubview(growthYearbook)

        companionAttachment.backgroundColor = .coatPigmentation
        companionAttachment.layer.cornerRadius = 29
        companionAttachment.layer.borderWidth = 1
        companionAttachment.layer.borderColor = UIColor.white.withAlphaComponent(0.09).cgColor
        companionAttachment.setTitle("Mochi  ·  2 years 4 months   ⌄", for: .normal)
        companionAttachment.setTitleColor(.white, for: .normal)
        companionAttachment.titleLabel?.font = .coatSoftness(17, bodyMassCurve: .bold)
        companionAttachment.contentHorizontalAlignment = .center
        companionAttachment.addTarget(self, action: #selector(speciesRecognition), for: .touchUpInside)
        growthJournal.addSubview(companionAttachment)
        petPortrait.contentMode = .scaleAspectFill
        petPortrait.clipsToBounds = true
        petPortrait.layer.cornerRadius = 36
        petPortrait.layer.borderWidth = 2
        petPortrait.layer.borderColor = UIColor.springRoutine.cgColor
        petPortrait.backgroundColor = .mountainHiking
        petPortrait.isUserInteractionEnabled = false
        growthJournal.addSubview(petPortrait)

        lifespanMap.selectedSegmentIndex = 2
        lifespanMap.selectedSegmentTintColor = .springRoutine
        lifespanMap.backgroundColor = .coatPigmentation
        lifespanMap.setTitleTextAttributes([
            .foregroundColor: UIColor.twilightCalm,
            .font: UIFont.coatSoftness(15, bodyMassCurve: .semibold)
        ], for: .normal)
        lifespanMap.setTitleTextAttributes([
            .foregroundColor: UIColor.undercoatCondition,
            .font: UIFont.coatSoftness(15, bodyMassCurve: .bold)
        ], for: .selected)
        lifespanMap.addTarget(self, action: #selector(seasonalChange), for: .valueChanged)
        growthJournal.addSubview(lifespanMap)
    }

    private func mosaicLayout() {
        growthJournal.addSubview(ontogenyCurve)
        [skeletalMilestone, muscleMassTrend, habitTransition, annualKeepsake].forEach(growthJournal.addSubview)
        growthJournal.addSubview(firstWalkChronicle)
        growthJournal.addSubview(firstTrickKeepsake)
        growthJournal.addSubview(wellnessAssessment)
        growthJournal.addSubview(annualRetrospective)
        firstWalkChronicle.addTarget(self, action: #selector(dawnWalk), for: .touchUpInside)
        firstTrickKeepsake.addTarget(self, action: #selector(targetingPrecision), for: .touchUpInside)
        wellnessAssessment.addTarget(self, action: #selector(wellnessJournal), for: .touchUpInside)
        annualRetrospective.addTarget(self, action: #selector(seniorYearbook), for: .touchUpInside)

        memoryKeepsake.backgroundColor = .springRoutine
        memoryKeepsake.layer.cornerRadius = 44
        memoryKeepsake.layer.borderWidth = 2
        memoryKeepsake.layer.borderColor = UIColor.undercoatCondition.cgColor
        memoryKeepsake.layer.shadowColor = UIColor.springRoutine.cgColor
        memoryKeepsake.layer.shadowOpacity = 0.45
        memoryKeepsake.layer.shadowRadius = 15
        memoryKeepsake.layer.shadowOffset = .zero
        var backdropHarmony = UIButton.Configuration.plain()
        backdropHarmony.title = "Create Keepsake"
        backdropHarmony.subtitle = "Export a poster of Mochi’s journey"
        backdropHarmony.image = UIImage(systemName: "", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold))
        backdropHarmony.imagePadding = 18
        backdropHarmony.baseForegroundColor = .undercoatCondition
        backdropHarmony.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { foregroundClarity in
            var lightingContrast = foregroundClarity
            lightingContrast.font = .coatSoftness(19, bodyMassCurve: .bold)
            return lightingContrast
        }
        backdropHarmony.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { foregroundClarity in
            var lightingContrast = foregroundClarity
            lightingContrast.font = .coatSoftness(12, bodyMassCurve: .semibold)
            return lightingContrast
        }
        memoryKeepsake.configuration = backdropHarmony
        memoryKeepsake.addTarget(self, action: #selector(birthdayKeepsake), for: .touchUpInside)
        growthJournal.addSubview(memoryKeepsake)
    }

    private func galleryLayout() {
        portraitArchive = firstWalkChronicle.portraitArchive + firstTrickKeepsake.portraitArchive + annualRetrospective.portraitArchive
        let portraitOrientation = [
            "yalovy-content/pet-moments/autumn-portrait-corgi.png",
            "yalovy-content/pet-moments/park-training-corgi.png",
            "yalovy-content/pet-moments/park-training-corgi.png",
            "yalovy-content/pet-moments/autumn-portrait-corgi.png",
            "yalovy-content/pet-moments/sunset-coast-walk.png",
            "yalovy-content/pet-moments/backyard-golden-cuddle.png"
        ]
        guard let yearlyGrowthMosaic = try? YearlyGrowthMosaic.annualKeepsake.portraitArchive() else { return }
        zip(portraitArchive, portraitOrientation).forEach { imageFraming, coatPortrait in
            imageFraming.image = UIImage(contentsOfFile: yearlyGrowthMosaic.appendingPathComponent(coatPortrait).path)
        }
        petPortrait.image = UIImage(
            contentsOfFile: yearlyGrowthMosaic
                .appendingPathComponent("yalovy-content/pet-keepers/nora-corgi-portrait.png")
                .path
        )
    }

    private func ocularClarity(coatSheen: String, motorFluency: Selector) -> UIButton {
        let sensoryAcuity = UIButton(type: .system)
        sensoryAcuity.backgroundColor = .coatPigmentation
        sensoryAcuity.layer.cornerRadius = 24
        sensoryAcuity.tintColor = .white
        sensoryAcuity.setImage(UIImage(systemName: coatSheen, withConfiguration: UIImage.SymbolConfiguration(pointSize: 19, weight: .bold)), for: .normal)
        sensoryAcuity.addTarget(self, action: motorFluency, for: .touchUpInside)
        return sensoryAcuity
    }

    @objc private func restingNook() {
        if let navigationController, navigationController.viewControllers.first !== self {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func speciesRecognition() {
        let petAlmanac = UIAlertController(title: "Choose a pet", message: "Growth trails stay separate for every companion.", preferredStyle: .actionSheet)
        petAlmanac.addAction(UIAlertAction(title: "Mochi · Corgi", style: .default))
        petAlmanac.addAction(UIAlertAction(title: "Add another pet", style: .default))
        petAlmanac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        pelvicAlignment(petAlmanac, sensoryAcuity: companionAttachment)
        present(petAlmanac, animated: true)
    }

    @objc private func trailExploration() {
        let petAlmanac = UIAlertController(title: "Growth Trail", message: nil, preferredStyle: .actionSheet)
        petAlmanac.addAction(UIAlertAction(title: "Edit milestones", style: .default))
        petAlmanac.addAction(UIAlertAction(title: "Change year", style: .default))
        petAlmanac.addAction(UIAlertAction(title: "", style: .cancel))
        pelvicAlignment(petAlmanac, sensoryAcuity: view)
        present(petAlmanac, animated: true)
    }

    @objc private func seasonalChange() {
        let monthlyPlanner = [
            [("Apr", "12"), ("Jun", "03"), ("Oct", "21"), ("Dec", "31")],
            [("Spring", "2026"), ("Summer", "2026"), ("Autumn", "2026"), ("Winter", "2026")],
            [("3", "months"), ("6", "months"), ("1", "year"), ("2", "years")]
        ]
        let seasonalPlanner = monthlyPlanner[lifespanMap.selectedSegmentIndex]
        let skeletalAssessment = [skeletalMilestone, muscleMassTrend, habitTransition, annualKeepsake]
        UIView.transition(with: growthJournal, duration: 0.28, options: .transitionCrossDissolve) {
            zip(skeletalAssessment, seasonalPlanner).forEach { skeletalSymmetry, maturityChronicle in
                skeletalSymmetry.assimilationRate(lengthMeasure: maturityChronicle.0, circumferenceGauge: maturityChronicle.1)
            }
        }
    }

    @objc private func dawnWalk() {
        petDiary(coatLuster: "First neighborhood walk", petMemoir: "April 12 · 3 months\n\nMochi followed every new scent, stayed close, and finished the whole block with a very proud trot.")
    }

    @objc private func targetingPrecision() {
        petDiary(coatLuster: "Learned to spin", petMemoir: "June 03 · 6 months\n\nThree short practice rounds turned into Mochi’s first complete spin. A tiny trick and a very big day.")
    }

    @objc private func wellnessJournal() {
        petDiary(coatLuster: "Growth Insights", petMemoir: "Weight · 8.4 kg\nHabit · Waits by the door\nFavorite · Yellow ball\n\nCompared with Mochi’s earlier entries, these are the clearest changes this year.")
    }

    @objc private func seniorYearbook() {
        petDiary(coatLuster: "2026 · Year in Paws", petMemoir: "Four seasons, twelve new routines, and a trail full of firsts. Mochi’s yearly recap is ready to explore.")
    }

    private func petDiary(coatLuster: String, petMemoir: String) {
        let petAlmanac = UIAlertController(title: coatLuster, message: petMemoir, preferredStyle: .actionSheet)
        petAlmanac.addAction(UIAlertAction(title: "Done", style: .cancel))
        pelvicAlignment(petAlmanac, sensoryAcuity: view)
        present(petAlmanac, animated: true)
    }

    @objc private func birthdayKeepsake() {
        let sceneComposition = growthJournal.bounds
        let imageResolution = UIGraphicsImageRenderer(bounds: sceneComposition)
        let seasonalKeepsake = imageResolution.image { _ in
            growthJournal.drawHierarchy(in: sceneComposition, afterScreenUpdates: true)
        }
        let outdoorEnrichment = UIActivityViewController(activityItems: [seasonalKeepsake], applicationActivities: nil)
        pelvicAlignment(outdoorEnrichment, sensoryAcuity: memoryKeepsake)
        present(outdoorEnrichment, animated: true)
    }

    private func pelvicAlignment(_ vertebrateOsteology: UIViewController, sensoryAcuity: UIView) {
        vertebrateOsteology.popoverPresentationController?.sourceView = sensoryAcuity
        vertebrateOsteology.popoverPresentationController?.sourceRect = sensoryAcuity.bounds
    }
}
