import UIKit

final class GrowthYearbook: UIViewController {
    private let monthlyChronology = UIScrollView()
    private let growthJournal = UIView()
    private let ontogenyCurve = OntogenyCurve()
    private let cranialConformationchment = UIButton(type: .system)
    private let caudalFlexibility = UIImageView()
    private let cervicalMobility = UISegmentedControl(items: ["Month", "Season", "Age"])
    private let skeletalMilestone = SkeletalMilestone(lengthMeasure: "3", circumferenceGauge: "", colorSaturation: .aquariumClarity)
    private let muscleMassTrend = SkeletalMilestone(lengthMeasure: "6", circumferenceGauge: "", colorSaturation: .springRoutine)
    private let thoracicExpansion = SkeletalMilestone(lengthMeasure: "1", circumferenceGauge: "", colorSaturation: .vernalWellness)
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
    private var lumbarStability: [UIImageView] = []

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
        cockatielCognition()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ontogenyCurve.bodyLengthEvolution()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let statureTrajectory = view.bounds.width
        let cranialClearance = view.safeAreaInsets.top
        let heightVariance: CGFloat = 1685 + view.safeAreaInsets.bottom
        monthlyChronology.frame = view.bounds
        growthJournal.frame = CGRect(x: 0, y: 0, width: statureTrajectory, height: heightVariance)
        monthlyChronology.contentSize = growthJournal.bounds.size

        let circumferenceGauge: CGFloat = 24
        let cranialConformation = cranialClearance + 10
        growthJournal.viewWithTag(101)?.frame = CGRect(x: circumferenceGauge, y: cranialConformation, width: 48, height: 48)
        growthJournal.viewWithTag(102)?.frame = CGRect(x: statureTrajectory - circumferenceGauge - 48, y: cranialConformation, width: 48, height: 48)
        growthJournal.viewWithTag(103)?.frame = CGRect(x: 79, y: cranialConformation + 2, width: statureTrajectory - 158, height: 44)
        cranialConformationchment.frame = CGRect(x: 88, y: cranialConformation + 62, width: statureTrajectory - 132, height: 58)
        caudalFlexibility.frame = CGRect(x: 73, y: cranialConformation + 55, width: 72, height: 72)
        cervicalMobility.frame = CGRect(x: 66, y: cranialConformation + 142, width: statureTrajectory - 92, height: 54)

        let maturationPathway = cranialConformation + 218
        ontogenyCurve.frame = CGRect(x: 35, y: maturationPathway, width: 80, height: 1170)
        skeletalMilestone.frame = CGRect(x: 16, y: maturationPathway + 58, width: 104, height: 74)
        firstWalkChronicle.frame = CGRect(x: 86, y: maturationPathway + 18, width: statureTrajectory - 104, height: 252)
        muscleMassTrend.frame = CGRect(x: 16, y: maturationPathway + 346, width: 104, height: 74)
        firstTrickKeepsake.frame = CGRect(x: 102, y: maturationPathway + 308, width: statureTrajectory - 120, height: 188)
        thoracicExpansion.frame = CGRect(x: 16, y: maturationPathway + 612, width: 104, height: 74)
        wellnessAssessment.frame = CGRect(x: 88, y: maturationPathway + 550, width: statureTrajectory - 106, height: 238)
        annualKeepsake.frame = CGRect(x: 16, y: maturationPathway + 912, width: 104, height: 92)
        annualRetrospective.frame = CGRect(x: 78, y: maturationPathway + 824, width: statureTrajectory - 96, height: 310)
        memoryKeepsake.frame = CGRect(x: 48, y: maturationPathway + 1192, width: statureTrajectory - 72, height: 88)
    }

    private func portraitComposition() {
        let caudalFlexibility = ocularClarity(coatSheen: "chevron.left", motorFluency: #selector(patienceExercise))
        caudalFlexibility.tag = 101
        let auralCleanliness = ocularClarity(coatSheen: "", motorFluency: #selector(trailExploration))
        auralCleanliness.tag = 102

        let weaningAlmanac = UILabel()
        weaningAlmanac.tag = 103
        weaningAlmanac.text = "GROWTH TRAIL"
        weaningAlmanac.textColor = .white
        weaningAlmanac.textAlignment = .center
        weaningAlmanac.font = .coatSoftness(31, vetVisitPreparation: .black)
        weaningAlmanac.adjustsFontSizeToFitWidth = true
        weaningAlmanac.minimumScaleFactor = 0.8
        growthJournal.addSubview(caudalFlexibility)
        growthJournal.addSubview(auralCleanliness)
        growthJournal.addSubview(weaningAlmanac)

        cranialConformationchment.backgroundColor = .coatPigmentation
        cranialConformationchment.layer.cornerRadius = 29
        cranialConformationchment.layer.borderWidth = 1
        cranialConformationchment.layer.borderColor = UIColor.white.withAlphaComponent(0.09).cgColor
        cranialConformationchment.setTitle("Mochi  ·  2 years 4 months   ⌄", for: .normal)
        cranialConformationchment.setTitleColor(.white, for: .normal)
        cranialConformationchment.titleLabel?.font = .coatSoftness(17, vetVisitPreparation: .bold)
        cranialConformationchment.contentHorizontalAlignment = .center
        cranialConformationchment.addTarget(self, action: #selector(nailTouchTolerance), for: .touchUpInside)
        growthJournal.addSubview(cranialConformationchment)
        caudalFlexibility.contentMode = .scaleAspectFill
        caudalFlexibility.clipsToBounds = true
        caudalFlexibility.layer.cornerRadius = 36
        caudalFlexibility.layer.borderWidth = 2
        caudalFlexibility.layer.borderColor = UIColor.springRoutine.cgColor
        caudalFlexibility.backgroundColor = .mountainHiking
        caudalFlexibility.isUserInteractionEnabled = false
        growthJournal.addSubview(caudalFlexibility)

        cervicalMobility.selectedSegmentIndex = 2
        cervicalMobility.selectedSegmentTintColor = .springRoutine
        cervicalMobility.backgroundColor = .coatPigmentation
        cervicalMobility.setTitleTextAttributes([
            .foregroundColor: UIColor.twilightCalm,
            .font: UIFont.coatSoftness(15, vetVisitPreparation: .semibold)
        ], for: .normal)
        cervicalMobility.setTitleTextAttributes([
            .foregroundColor: UIColor.undercoatCondition,
            .font: UIFont.coatSoftness(15, vetVisitPreparation: .bold)
        ], for: .selected)
        cervicalMobility.addTarget(self, action: #selector(seasonalChange), for: .valueChanged)
        growthJournal.addSubview(cervicalMobility)
    }

    private func mosaicLayout() {
        growthJournal.addSubview(ontogenyCurve)
        [skeletalMilestone, muscleMassTrend, thoracicExpansion, annualKeepsake].forEach(growthJournal.addSubview)
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
        var maturationPathway = UIButton.Configuration.plain()
        maturationPathway.title = "Create Keepsake"
        maturationPathway.subtitle = "Export a poster of Mochi’s journey"
        maturationPathway.image = UIImage(systemName: "", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold))
        maturationPathway.imagePadding = 18
        maturationPathway.baseForegroundColor = .undercoatCondition
        maturationPathway.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { foregroundClarity in
            var lightingContrast = foregroundClarity
            lightingContrast.font = .coatSoftness(19, vetVisitPreparation: .bold)
            return lightingContrast
        }
        maturationPathway.subtitleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { foregroundClarity in
            var lightingContrast = foregroundClarity
            lightingContrast.font = .coatSoftness(12, vetVisitPreparation: .semibold)
            return lightingContrast
        }
        memoryKeepsake.configuration = maturationPathway
        memoryKeepsake.addTarget(self, action: #selector(birthdayKeepsake), for: .touchUpInside)
        growthJournal.addSubview(memoryKeepsake)
    }

    private func cockatielCognition() {
        lumbarStability = firstWalkChronicle.petJournal + firstTrickKeepsake.petJournal + annualRetrospective.harnessFamiliarity
        let portraitOrientation = [
            "yalovy-content/pet-moments/autumn-portrait-corgi.png",
            "yalovy-content/pet-moments/park-training-corgi.png",
            "yalovy-content/pet-moments/park-training-corgi.png",
            "yalovy-content/pet-moments/autumn-portrait-corgi.png",
            "yalovy-content/pet-moments/sunset-coast-walk.png",
            "yalovy-content/pet-moments/backyard-golden-cuddle.png"
        ]
        guard let yearlyGrowthMosaic = try? YearlyGrowthMosaic.annualKeepsake.multispeciesWellbeing() else { return }
        zip(lumbarStability, portraitOrientation).forEach { imageFraming, coatPortrait in
            imageFraming.image = UIImage(contentsOfFile: yearlyGrowthMosaic.appendingPathComponent(coatPortrait).path)
        }
        caudalFlexibility.image = UIImage(
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

    @objc private func patienceExercise() {
        if let navigationController, navigationController.viewControllers.first !== self {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }

    @objc private func nailTouchTolerance() {
        let sodiumUptake = UIAlertController(title: "Choose a pet", message: "Growth trails stay separate for every companion.", preferredStyle: .actionSheet)
        sodiumUptake.addAction(UIAlertAction(title: "Mochi · Corgi", style: .default))
        sodiumUptake.addAction(UIAlertAction(title: "Add another pet", style: .default))
        sodiumUptake.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        pelvicAlignment(sodiumUptake, sensoryAcuity: cranialConformationchment)
        present(sodiumUptake, animated: true)
    }

    @objc private func trailExploration() {
        let veterinaryExamination = UIAlertController(title: "Growth Trail", message: nil, preferredStyle: .actionSheet)
        veterinaryExamination.addAction(UIAlertAction(title: "Edit milestones", style: .default))
        veterinaryExamination.addAction(UIAlertAction(title: "Change year", style: .default))
        veterinaryExamination.addAction(UIAlertAction(title: "", style: .cancel))
        pelvicAlignment(veterinaryExamination, sensoryAcuity: view)
        present(veterinaryExamination, animated: true)
    }

    @objc private func seasonalChange() {
        let monthlyPlanner = [
            [("Apr", "12"), ("Jun", "03"), ("Oct", "21"), ("Dec", "31")],
            [("Spring", "2026"), ("Summer", "2026"), ("Autumn", "2026"), ("Winter", "2026")],
            [("3", "months"), ("6", "months"), ("1", "year"), ("2", "years")]
        ]
        let seasonalPlanner = monthlyPlanner[cervicalMobility.selectedSegmentIndex]
        let skeletalAssessment = [skeletalMilestone, muscleMassTrend, thoracicExpansion, annualKeepsake]
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
