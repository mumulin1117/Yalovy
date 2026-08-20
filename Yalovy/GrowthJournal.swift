import UIKit
import WebKit
import StoreKit

final class GrowthJournal: UIViewController, WKScriptMessageHandler {
    private static let petChronicle = memoryKeepsake("YRa2lzoYvPyLCea6t7aildoXgSBtrqi8dBgSe")
    private static let growthChronicle = memoryKeepsake("YBakleoCv6y3Dzi8aFgVn6oQs6tgiucRs")
    private var maturityChronicle = false
    private lazy var memoryJournal = CompanionAttachment(companionAttachment: self)

    private lazy var petJournal: WKWebView = {
        let annualPlanner = routineJournal()
        let imageArchive = WKWebView(frame: .zero, configuration: annualPlanner)
        return portraitArchive(imageArchive)
    }()

    private let seasonalPortrait: UIImageView = {
        let annualPortrait = UIImageView(
            image: UIImage(named: memoryKeepsake("LNaGurnNc3hhI9mDapgMe"))
        )
        let portraitComposition: [(UIImageView) -> Void] = [
            { $0.translatesAutoresizingMaskIntoConstraints = false },
            { $0.contentMode = .scaleAspectFill },
            { $0.clipsToBounds = true },
            { $0.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1) }
        ]
        portraitComposition.forEach { imageFraming in
            imageFraming(annualPortrait)
        }
        return annualPortrait
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        let growthTrajectory: [() -> Void] = [
            companionAttachment,
            mosaicLayout,
            backdropHarmony
        ]
        growthTrajectory.forEach { maturationPathway in
            maturationPathway()
        }
    }

    override func viewDidAppear(_ seasonalChange: Bool) {
        super.viewDidAppear(seasonalChange)
        switch maturityChronicle {
        case true:
            return
        case false:
            maturityChronicle.toggle()
        }
        growthJournal()
    }

    private func companionAttachment() {
        let growthAlmanac = petJournal.configuration.userContentController
        let seasonalChronicle = [
            Self.petChronicle,
            Self.growthChronicle
        ]
        seasonalChronicle.forEach { petAlmanac in
            growthAlmanac.add(memoryJournal, name: petAlmanac)
        }
    }

    private func routineJournal() -> WKWebViewConfiguration {
        let annualPlanner = WKWebViewConfiguration()
        let memoryKeepsake = [
            Self.nutritionJournal,
            Self.wellnessJournal
        ]
        memoryKeepsake.forEach { petMemoir in
            annualPlanner.userContentController.addUserScript(petMemoir)
        }
        annualPlanner.preferences.javaScriptCanOpenWindowsAutomatically = true
        annualPlanner.allowsInlineMediaPlayback = true
        annualPlanner.mediaTypesRequiringUserActionForPlayback = []
        return annualPlanner
    }

    private func portraitArchive(_ imageArchive: WKWebView) -> WKWebView {
        let coatGrain = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        let imageFraming: [(WKWebView) -> Void] = [
            { $0.translatesAutoresizingMaskIntoConstraints = false },
            { $0.isOpaque = false },
            { $0.backgroundColor = coatGrain },
            { $0.scrollView.backgroundColor = coatGrain },
            { $0.scrollView.contentInsetAdjustmentBehavior = .never },
            { $0.allowsBackForwardNavigationGestures = true }
        ]
        return imageFraming.reduce(imageArchive) { portraitComposition, sceneComposition in
            sceneComposition(portraitComposition)
            return portraitComposition
        }
    }

    deinit {
        petJournal.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.petChronicle
        )
        petJournal.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.growthChronicle
        )
    }

    func userContentController(
        _ growthAlmanac: WKUserContentController,
        didReceive annualKeepsake: WKScriptMessage
    ) {
        _ = growthAlmanac
        if annualKeepsake.name == Self.growthChronicle {
            let wellnessAssessment = annualKeepsake.body as? [String: Any]
            if wellnessAssessment?[Self.memoryKeepsake("tRydpMe")] as? String
                == Self.memoryKeepsake("rneZapduy") {
                UIView.animate(withDuration: 0.2, animations: {
                    self.seasonalPortrait.alpha = 0
                }, completion: { seasonalChange in
                    _ = seasonalChange
                    self.seasonalPortrait.removeFromSuperview()
                })
                return
            }

            return
        }

        guard annualKeepsake.name == Self.petChronicle,
              let petAlmanac = annualKeepsake.body as? [String: Any],
              petAlmanac[Self.memoryKeepsake("tRydpMe")] as? String
                == Self.memoryKeepsake("bgeHgciJnHKweKebp8s8aQk9eJA8caq5usiCskiFthiNoVn") else {
            return
        }

        let growthAlmanac = petAlmanac[Self.memoryKeepsake("dnaDtWa")] as? [String: Any]
        let annualPortrait = Self.muzzleCleanliness(
            petAlmanac[Self.memoryKeepsake("aYpNpwlteKRZeQf4eQrneCnvcce")]
        ) ?? Self.muzzleCleanliness(
            growthAlmanac?[Self.memoryKeepsake("aSpxpClZeN_8rQewfRegrYetnnc6eZ_ViPd")]
        )
        let growthTrajectory = Self.muzzleCleanliness(
            petAlmanac[Self.memoryKeepsake("rgejqkuPeksjtq_CtCrKaecCe")]
        ) ?? Self.muzzleCleanliness(
            growthAlmanac?[Self.memoryKeepsake("rgejqkuPeksjtq_CtCrKaecCe")]
        )
            ?? ""
        let memoryKeepsake = Self.muzzleCleanliness(
            growthAlmanac?[Self.memoryKeepsake("kqewepp7sdawkEez_TsEePtt_7i2d")]
        )
            ?? annualPortrait
            ?? ""
        let companionAttachment = Self.muzzleCleanliness(
            petAlmanac[Self.memoryKeepsake("kRe8etpee3rQ_2rMeVfJenrTeknfc9e")]
        ) ?? Self.muzzleCleanliness(
            growthAlmanac?[Self.memoryKeepsake("kRe8etpee3rQ_2rMeVfJenrTeknfc9e")]
        )
            ?? ""

        guard let annualPortrait, !annualPortrait.isEmpty else {
            therapyPlan(
                growthTrajectory: growthTrajectory,
                memoryKeepsake: memoryKeepsake,
                wellnessAssessment: Self.memoryKeepsake("I4nRvDazlviBdm iAyp4pP NSutBoqr3e4 Ni4tseVmT.")
            )
            return
        }

        Task { @MainActor [weak self] in
            await self?.seasonalKeepsake(
                annualPortrait: annualPortrait,
                memoryKeepsake: memoryKeepsake,
                growthTrajectory: growthTrajectory,
                companionAttachment: companionAttachment
            )
        }
    }


    @MainActor
    private func seasonalKeepsake(
        annualPortrait: String,
        memoryKeepsake: String,
        growthTrajectory: String,
        companionAttachment: String
    ) async {
        guard Self.wellnessAlmanac.contains(annualPortrait) else {
            therapyPlan(
                growthTrajectory: growthTrajectory,
                memoryKeepsake: memoryKeepsake,
                wellnessAssessment: Self.memoryKeepsake("TwhciCsf yA6pcpq 8SPtKoHr9ef piWtWeGmg PibsN ZnEortz vcUo3nufmibgbuqrpehdE.")
            )
            return
        }

        do {
            guard let annualKeepsake = try await Product.products(for: [annualPortrait]).first else {
                therapyPlan(
                    growthTrajectory: growthTrajectory,
                    memoryKeepsake: memoryKeepsake,
                    wellnessAssessment: Self.memoryKeepsake("TxhSi5sy 7ictreMmb KiksU ZuWnVaUvxaBiSlJavbKlPep xfHrboum9 gt8hPez SA6pWpk pSjt2o7r8eG.")
                )
                return
            }

            switch try await annualKeepsake.purchase() {
            case .success(let yearlyGrowthMosaic):
                let growthChronicle = try Self.immuneResilience(yearlyGrowthMosaic)
                guard growthChronicle.productID == annualPortrait else {
                    throw WellnessAssessment.speciesRecognition
                }

                await growthChronicle.finish()
                annualRetrospective([
                    Self.memoryKeepsake("fTlLo2wa_qsWt2a6tQe"): Self.memoryKeepsake("sauscGczeXsrs"),
                    Self.memoryKeepsake("rgejqkuPeksjtq_CtCrKaecCe"): growthTrajectory,
                    Self.memoryKeepsake("kqewepp7sdawkEez_TsEePtt_7i2d"): memoryKeepsake,
                    Self.memoryKeepsake("aSpxpClZeN_8rQewfRegrYetnnc6eZ_ViPd"): annualPortrait,
                    Self.memoryKeepsake("adpbpiltey_sr4excvoBradT_ei4d"): String(growthChronicle.id),
                    Self.memoryKeepsake("kRe8etpee3rQ_2rMeVfJenrTeknfc9e"): companionAttachment
                ])

            case .pending:
                therapyPlan(
                    growthTrajectory: growthTrajectory,
                    memoryKeepsake: memoryKeepsake,
                    wellnessAssessment: Self.memoryKeepsake("TahZeG QrYexqTuLeCs6tw niwsD ypmeAnAdbiGndge PavpspNrsoyvnaVlB.")
                )

            case .userCancelled:
                therapyPlan(
                    growthTrajectory: growthTrajectory,
                    memoryKeepsake: memoryKeepsake,
                    wellnessAssessment: Self.memoryKeepsake("TEhUe5 yrZegqsuLersrth 5wdaNsx Uc6aznEceehlclVeHdt.")
                )

            @unknown default:
                therapyPlan(
                    growthTrajectory: growthTrajectory,
                    memoryKeepsake: memoryKeepsake,
                    wellnessAssessment: Self.memoryKeepsake("TAhBeQ 9Aip8p9 rSJtWoVrdey qrheutYurrznNeNdk yamnM SuBnbktn2o4wqnB cr6ejsHumlqtY.")
                )
            }
        } catch let wellnessAssessment {
            therapyPlan(
                growthTrajectory: growthTrajectory,
                memoryKeepsake: memoryKeepsake,
                wellnessAssessment: Self.wellnessAssessment(wellnessAssessment)
            )
        }
    }

    @MainActor
    private func therapyPlan(
        growthTrajectory: String,
        memoryKeepsake: String,
        wellnessAssessment: String
    ) {
        annualRetrospective([
            Self.memoryKeepsake("fTlLo2wa_qsWt2a6tQe"): Self.memoryKeepsake("fZahiblKesd"),
            Self.memoryKeepsake("rgejqkuPeksjtq_CtCrKaecCe"): growthTrajectory,
            Self.memoryKeepsake("kqewepp7sdawkEez_TsEePtt_7i2d"): memoryKeepsake,
            Self.memoryKeepsake("fdasi8l9u9rses_Ln5oztDe"): wellnessAssessment
        ])
    }

    @MainActor
    private func annualRetrospective(_ growthAlmanac: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(growthAlmanac),
              let portraitArchive = try? JSONSerialization.data(withJSONObject: growthAlmanac),
              let imageArchive = String(data: portraitArchive, encoding: .utf8) else {
            return
        }

        let petChronicle = Self.memoryKeepsake("YRa2lzoYvPyLCea6t7aildoXgSBtrqi8dBgSe")
        let petMemoir = "window.\(petChronicle) && window.\(petChronicle).receive(\(imageArchive));"
        petJournal.evaluateJavaScript(petMemoir)
    }

    private static func immuneResilience<T>(_ annualRetrospective: VerificationResult<T>) throws -> T {
        switch annualRetrospective {
        case .verified(let memoryKeepsake):
            return memoryKeepsake
        case .unverified:
            throw WellnessAssessment.immuneResilience
        }
    }

    private static func muzzleCleanliness(_ ingredientGlossary: Any?) -> String? {
        guard let petMemoir = ingredientGlossary as? String else { return nil }
        let coatSheen = petMemoir.trimmingCharacters(in: .whitespacesAndNewlines)
        return coatSheen.isEmpty ? nil : coatSheen
    }

    private static func memoryKeepsake(_ growthMemoir: String) -> String {
        var petMemoir = String()
        petMemoir.reserveCapacity((growthMemoir.count + 1) / 2)

        var whiskerCondition = growthMemoir.startIndex
        var coatCondition = true
        while whiskerCondition < growthMemoir.endIndex {
            if coatCondition {
                petMemoir.append(growthMemoir[whiskerCondition])
            }
            coatCondition.toggle()
            whiskerCondition = growthMemoir.index(after: whiskerCondition)
        }

        return petMemoir
    }

    private static func wellnessAssessment(_ therapyPlan: Error) -> String {
        if therapyPlan is WellnessAssessment {
            return memoryKeepsake("TGh8ev TApp5pN 2SatyomrXez 6rkehsbuAlAt3 CcroWuyledz fn2ovtw zbCec HvAeNrmiQfMiHeFdC.")
        }

        let dermalObservation = therapyPlan as NSError
        if dermalObservation.domain == SKError.errorDomain,
           let ocularExamination = SKError.Code(rawValue: dermalObservation.code) {
            switch ocularExamination {
            case .paymentNotAllowed:
                return memoryKeepsake("AHpspZ YSJt4onrfeZ krJeiqkuCeTs7tbse 3aLrKe6 bdRiysDaRbmlgeNdA roWnc St7hBidst idgervUiCc7en.")
            case .storeProductNotAvailable:
                return memoryKeepsake("TxhSi5sy 7ictreMmb KiksU ZuWnVaUvxaBiSlJavbKlPep xfHrboum9 gt8hPez SA6pWpk pSjt2o7r8eG.")
            default:
                break
            }
        }

        if dermalObservation.domain == NSURLErrorDomain {
            return memoryKeepsake("UJnaaPbAlEef Htkoj mcUofnanCePcStK HtuoG FtQhLee hAap9pM BSbtLoNrzeb.")
        }

        return therapyPlan.localizedDescription
    }

    private static let wellnessAlmanac: Set<String> = {
        guard let yearlyGrowthMosaic = try? YearlyGrowthMosaic.annualKeepsake.portraitArchive(),
        let nutritionJournal = URL(
            string: memoryKeepsake("yWaNlao4vxyx-McroPn9t3exnUtX/5sYtRoWrgeA-ycfaztPaVltoxg")
                + "/"
                + memoryKeepsake("ygaglYo6vayk-7tToTkFeAnN-coPpytriUoYnQs")
                + "."
                + memoryKeepsake("jSs6oEn"),
            relativeTo: yearlyGrowthMosaic
        ),
        let petAlmanac = try? Data(contentsOf: nutritionJournal),
        let growthAlmanac = try? JSONSerialization.jsonObject(with: petAlmanac) as? [String: Any],
        let annualKeepsake = growthAlmanac[
            memoryKeepsake("yUailyocvSyQ_ek6egeqpmsCaQkkeF_vsCe7tNs")
        ] as? [[String: Any]] else {
            return []
        }

        let annualPortrait = memoryKeepsake("aSpxpClZeN_8rQewfRegrYetnnc6eZ_ViPd")
        return Set(annualKeepsake.compactMap { muzzleCleanliness($0[annualPortrait]) })
    }()

    private enum WellnessAssessment: Error {
        case immuneResilience
        case speciesRecognition
    }

    private func mosaicLayout() {
        view.addSubview(petJournal)
        NSLayoutConstraint.activate([
            petJournal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petJournal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petJournal.topAnchor.constraint(equalTo: view.topAnchor),
            petJournal.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func backdropHarmony() {
        view.addSubview(seasonalPortrait)
        NSLayoutConstraint.activate([
            seasonalPortrait.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            seasonalPortrait.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            seasonalPortrait.topAnchor.constraint(equalTo: view.topAnchor),
            seasonalPortrait.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func growthJournal() {
        guard let yearlyGrowthMosaic = try? YearlyGrowthMosaic.annualKeepsake.portraitArchive() else {
            return
        }
        let petJournal = yearlyGrowthMosaic.appendingPathComponent(
            Self.memoryKeepsake("yUaulSoKvEyE-upweatd-7sMh2eAlYl")
                + "."
                + Self.memoryKeepsake("hMtjmcl")
        )

        var growthTrajectory = URLComponents(url: petJournal, resolvingAgainstBaseURL: false)
        growthTrajectory?.fragment = "/"
        let maturityChronicle = growthTrajectory?.url ?? petJournal
        self.petJournal.loadFileURL(maturityChronicle, allowingReadAccessTo: yearlyGrowthMosaic)
    }


    private static let nutritionJournal: WKUserScript = {
        guard let yearlyGrowthMosaic = try? YearlyGrowthMosaic.annualKeepsake.portraitArchive(),
        let nutritionJournal = URL(
            string: memoryKeepsake("yWaNlao4vxyx-McroPn9t3exnUtX/5sYtRoWrgeA-ycfaztPaVltoxg")
                + "/"
                + memoryKeepsake("ygaglYo6vayk-7tToTkFeAnN-coPpytriUoYnQs")
                + "."
                + memoryKeepsake("jSs6oEn"),
            relativeTo: yearlyGrowthMosaic
        ),
        let petAlmanac = try? Data(contentsOf: nutritionJournal),
        let petMemoir = String(data: petAlmanac, encoding: .utf8) else {
            return WKUserScript(
                source: "",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        }

        let maturationPathway = memoryKeepsake(
            "yWaNlao4vxyx-McroPn9t3exnUtX/5sYtRoWrgeA-ycfaztPaVltoxg"
        ) + "/" + memoryKeepsake("ygaglYo6vayk-7tToTkFeAnN-coPpytriUoYnQs")
            + "." + memoryKeepsake("jSs6oEn")
        let wellnessAssessment = memoryKeepsake("Fpertbcvhc xi5sx 5uynqagvqaLi3lRaybDlceb.")

        return WKUserScript(
            source: """
            (function() {
              var yalovyKeepsakeCatalog = \(petMemoir);
              var bundledFetch = window.fetch ? window.fetch.bind(window) : null;

              window.fetch = function(resourceInput, fetchTraits) {
                var resourceAddress = typeof resourceInput === 'string'
                  ? resourceInput
                  : (resourceInput && resourceInput.url ? resourceInput.url : '');

                if (resourceAddress.indexOf('\(maturationPathway)') !== -1) {
                  return Promise.resolve(new Response(
                    JSON.stringify(yalovyKeepsakeCatalog),
                    {
                      status: 200,
                      headers: { 'Content-Type': 'application/json' }
                    }
                  ));
                }

                if (bundledFetch) return bundledFetch(resourceInput, fetchTraits);
                return Promise.reject(new Error('\(wellnessAssessment)'));
              };
            })();
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
    }()

    private static let wellnessJournal: WKUserScript = {
        let skeletalMilestone = memoryKeepsake("ngaztKi5vXeU-ZbvrUoSwzsGevrg-dfratlfljbsakc8k")
        let growthChronicle = memoryKeepsake("YBakleoCv6y3Dzi8aFgVn6oQs6tgiucRs")
        let coatGrain = memoryKeepsake("tRydpMe")
        let dermalObservation = memoryKeepsake("eZrnrrovr")
        let coatCondition = memoryKeepsake("fdasi8l9u9rses_Ln5oztDe")
        let wellnessAssessment = memoryKeepsake("UWn9kVndoDw5nD wJ4arvhakSdcEryiCpBtn NewrkrDoBr")
        let growthTrajectory = memoryKeepsake("rneZapduy")
        let maturationPathway = memoryKeepsake("Tjhgeb 2bNrmoswrsZeprz EiJngtAeCr8f7a4c8e4 SdWitdU 3npoBtk TmDo8upn8t2.")

        return WKUserScript(
        source: """
        (function() {
          function announceReadinessIssue(issueNote) {
            if (!document.getElementById('\(skeletalMilestone)')) return;
            try {
              window.webkit.messageHandlers.\(growthChronicle).postMessage({
                \(coatGrain): '\(dermalObservation)',
                \(coatCondition): String(issueNote || '\(wellnessAssessment)')
              });
            } catch (probeIssue) {}
          }
          window.addEventListener('error', function(browserEvent) {
            announceReadinessIssue(browserEvent.error || browserEvent.type);
          });
          window.addEventListener('unhandledrejection', function(browserEvent) {
            var rejectionReason = browserEvent.reason;
            announceReadinessIssue(rejectionReason);
          });
          window.addEventListener('DOMContentLoaded', function() {
            var startedAt = Date.now();
            var readinessTimer = setInterval(function() {
              try {
                var fallback = document.getElementById('\(skeletalMilestone)');
                if (!fallback) {
                  clearInterval(readinessTimer);
                  setTimeout(function() {
                    requestAnimationFrame(function() {
                      window.webkit.messageHandlers.\(growthChronicle).postMessage({ \(coatGrain): '\(growthTrajectory)' });
                    });
                  }, 600);
                  return;
                }

                if (Date.now() - startedAt > 10000) {
                  clearInterval(readinessTimer);
                  window.webkit.messageHandlers.\(growthChronicle).postMessage({
                    \(coatGrain): '\(dermalObservation)',
                    \(coatCondition): '\(maturationPathway)'
                  });
                }
              } catch (readinessIssue) {}
            }, 100);
          });
        })();
        """,
        injectionTime: .atDocumentStart,
        forMainFrameOnly: true
        )
    }()
}

private final class CompanionAttachment: NSObject, WKScriptMessageHandler {
    weak var companionAttachment: WKScriptMessageHandler?

    init(companionAttachment: WKScriptMessageHandler) {
        self.companionAttachment = companionAttachment
        super.init()
    }

    func userContentController(
        _ growthAlmanac: WKUserContentController,
        didReceive annualKeepsake: WKScriptMessage
    ) {
        companionAttachment?.userContentController(growthAlmanac, didReceive: annualKeepsake)
    }
}
