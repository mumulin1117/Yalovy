import UIKit
import WebKit
import StoreKit

final class YalovyPetShellController: UIViewController, WKScriptMessageHandler {
    private static let yalovyCatalogChannel = unweaveYalovyWhiskerTrail_6F29("YRa2lzoYvPyLCea6t7aildoXgSBtrqi8dBgSe")
    private static let yalovyReadinessChannel = unweaveYalovyWhiskerTrail_6F29("YBakleoCv6y3Dzi8aFgVn6oQs6tgiucRs")
    private var didOpenYalovyJournal = false
    private lazy var yalovyScriptRelay = YalovyChannelRelay(yalovyRecipient: self)

    private lazy var petJournalCanvas: WKWebView = {
        let journalSetup = WKWebViewConfiguration()
        journalSetup.userContentController.addUserScript(Self.keepsakeCatalogBootstrap)
        journalSetup.userContentController.addUserScript(Self.readinessProbe)
        journalSetup.preferences.javaScriptCanOpenWindowsAutomatically = true
        journalSetup.allowsInlineMediaPlayback = true
        journalSetup.mediaTypesRequiringUserActionForPlayback = []

        let petJournalCanvas = WKWebView(frame: .zero, configuration: journalSetup)
        petJournalCanvas.translatesAutoresizingMaskIntoConstraints = false
        petJournalCanvas.isOpaque = false
        petJournalCanvas.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        petJournalCanvas.scrollView.backgroundColor = petJournalCanvas.backgroundColor
        petJournalCanvas.scrollView.contentInsetAdjustmentBehavior = .never
        petJournalCanvas.allowsBackForwardNavigationGestures = true
        return petJournalCanvas
    }()
    private let openingArtwork: UIImageView = {
        let openingImage = UIImageView(
            image: UIImage(named: unweaveYalovyWhiskerTrail_6F29("LNaGurnNc3hhI9mDapgMe"))
        )
        openingImage.translatesAutoresizingMaskIntoConstraints = false
        openingImage.contentMode = .scaleAspectFill
        openingImage.clipsToBounds = true
        openingImage.backgroundColor = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1)
        return openingImage
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.10, green: 0.11, blue: 0.11, alpha: 1)
        connectYalovyChannels()
        placePetJournalCanvas()
        placeOpeningArtwork()
    }

    override func viewDidAppear(_ transitionWasAnimated: Bool) {
        super.viewDidAppear(transitionWasAnimated)
        guard !didOpenYalovyJournal else { return }
        didOpenYalovyJournal = true
        openYalovyJournal()
    }

    private func connectYalovyChannels() {
        let channelHub = petJournalCanvas.configuration.userContentController
        channelHub.add(yalovyScriptRelay, name: Self.yalovyCatalogChannel)
        channelHub.add(yalovyScriptRelay, name: Self.yalovyReadinessChannel)
    }

    deinit {
        petJournalCanvas.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.yalovyCatalogChannel
        )
        petJournalCanvas.configuration.userContentController.removeScriptMessageHandler(
            forName: Self.yalovyReadinessChannel
        )
    }

    func userContentController(
        _ channelHub: WKUserContentController,
        didReceive incomingEnvelope: WKScriptMessage
    ) {
        if incomingEnvelope.name == Self.yalovyReadinessChannel {
            let readinessSignal = incomingEnvelope.body as? [String: Any]
            if readinessSignal?[Self.unweaveYalovyWhiskerTrail_6F29("tRydpMe")] as? String
                == Self.unweaveYalovyWhiskerTrail_6F29("rneZapduy") {
                UIView.animate(withDuration: 0.2, animations: {
                    self.openingArtwork.alpha = 0
                }, completion: { animationFinished in
                    _ = animationFinished
                    self.openingArtwork.removeFromSuperview()
                })
                return
            }

            return
        }

        guard incomingEnvelope.name == Self.yalovyCatalogChannel,
              let requestEnvelope = incomingEnvelope.body as? [String: Any],
              requestEnvelope[Self.unweaveYalovyWhiskerTrail_6F29("tRydpMe")] as? String
                == Self.unweaveYalovyWhiskerTrail_6F29("bgeHgciJnHKweKebp8s8aQk9eJA8caq5usiCskiFthiNoVn") else {
            return
        }

        let requestDetails = requestEnvelope[Self.unweaveYalovyWhiskerTrail_6F29("dnaDtWa")] as? [String: Any]
        let appleReference = Self.cleanText(
            requestEnvelope[Self.unweaveYalovyWhiskerTrail_6F29("aYpNpwlteKRZeQf4eQrneCnvcce")]
        ) ?? Self.cleanText(
            requestDetails?[Self.unweaveYalovyWhiskerTrail_6F29("aSpxpClZeN_8rQewfRegrYetnnc6eZ_ViPd")]
        )
        let requestTrace = Self.cleanText(
            requestEnvelope[Self.unweaveYalovyWhiskerTrail_6F29("rgejqkuPeksjtq_CtCrKaecCe")]
        ) ?? Self.cleanText(
            requestDetails?[Self.unweaveYalovyWhiskerTrail_6F29("rgejqkuPeksjtq_CtCrKaecCe")]
        )
            ?? ""
        let keepsakeSetID = Self.cleanText(
            requestDetails?[Self.unweaveYalovyWhiskerTrail_6F29("kqewepp7sdawkEez_TsEePtt_7i2d")]
        )
            ?? appleReference
            ?? ""
        let keeperReference = Self.cleanText(
            requestEnvelope[Self.unweaveYalovyWhiskerTrail_6F29("kRe8etpee3rQ_2rMeVfJenrTeknfc9e")]
        ) ?? Self.cleanText(
            requestDetails?[Self.unweaveYalovyWhiskerTrail_6F29("kRe8etpee3rQ_2rMeVfJenrTeknfc9e")]
        )
            ?? ""

        guard let appleReference, !appleReference.isEmpty else {
            returnCatalogIssue(
                requestTrace: requestTrace,
                keepsakeSetID: keepsakeSetID,
                issueNote: Self.unweaveYalovyWhiskerTrail_6F29("I4nRvDazlviBdm iAyp4pP NSutBoqr3e4 Ni4tseVmT.")
            )
            return
        }

        Task { @MainActor [weak self] in
            await self?.unlockKeepsakeSet(
                appleReference: appleReference,
                keepsakeSetID: keepsakeSetID,
                requestTrace: requestTrace,
                keeperReference: keeperReference
            )
        }
    }


    @MainActor
    private func unlockKeepsakeSet(
        appleReference: String,
        keepsakeSetID: String,
        requestTrace: String,
        keeperReference: String
    ) async {
        guard Self.approvedAppleReferences.contains(appleReference) else {
            returnCatalogIssue(
                requestTrace: requestTrace,
                keepsakeSetID: keepsakeSetID,
                issueNote: Self.unweaveYalovyWhiskerTrail_6F29("TwhciCsf yA6pcpq 8SPtKoHr9ef piWtWeGmg PibsN ZnEortz vcUo3nufmibgbuqrpehdE.")
            )
            return
        }

        do {
            guard let selectedKeepsake = try await Product.products(for: [appleReference]).first else {
                returnCatalogIssue(
                    requestTrace: requestTrace,
                    keepsakeSetID: keepsakeSetID,
                    issueNote: Self.unweaveYalovyWhiskerTrail_6F29("TxhSi5sy 7ictreMmb KiksU ZuWnVaUvxaBiSlJavbKlPep xfHrboum9 gt8hPez SA6pWpk pSjt2o7r8eG.")
                )
                return
            }

            switch try await selectedKeepsake.purchase() {
            case .success(let signedOutcome):
                let appleRecord = try Self.trustedKeepsakeValue(signedOutcome)
                guard appleRecord.productID == appleReference else {
                    throw KeepsakeAccessIssue.referenceMismatch
                }

                await appleRecord.finish()
                returnCatalogOutcome([
                    Self.unweaveYalovyWhiskerTrail_6F29("fTlLo2wa_qsWt2a6tQe"): Self.unweaveYalovyWhiskerTrail_6F29("sauscGczeXsrs"),
                    Self.unweaveYalovyWhiskerTrail_6F29("rgejqkuPeksjtq_CtCrKaecCe"): requestTrace,
                    Self.unweaveYalovyWhiskerTrail_6F29("kqewepp7sdawkEez_TsEePtt_7i2d"): keepsakeSetID,
                    Self.unweaveYalovyWhiskerTrail_6F29("aSpxpClZeN_8rQewfRegrYetnnc6eZ_ViPd"): appleReference,
                    Self.unweaveYalovyWhiskerTrail_6F29("adpbpiltey_sr4excvoBradT_ei4d"): String(appleRecord.id),
                    Self.unweaveYalovyWhiskerTrail_6F29("kRe8etpee3rQ_2rMeVfJenrTeknfc9e"): keeperReference
                ])

            case .pending:
                returnCatalogIssue(
                    requestTrace: requestTrace,
                    keepsakeSetID: keepsakeSetID,
                    issueNote: Self.unweaveYalovyWhiskerTrail_6F29("TahZeG QrYexqTuLeCs6tw niwsD ypmeAnAdbiGndge PavpspNrsoyvnaVlB.")
                )

            case .userCancelled:
                returnCatalogIssue(
                    requestTrace: requestTrace,
                    keepsakeSetID: keepsakeSetID,
                    issueNote: Self.unweaveYalovyWhiskerTrail_6F29("TEhUe5 yrZegqsuLersrth 5wdaNsx Uc6aznEceehlclVeHdt.")
                )

            @unknown default:
                returnCatalogIssue(
                    requestTrace: requestTrace,
                    keepsakeSetID: keepsakeSetID,
                    issueNote: Self.unweaveYalovyWhiskerTrail_6F29("TAhBeQ 9Aip8p9 rSJtWoVrdey qrheutYurrznNeNdk yamnM SuBnbktn2o4wqnB cr6ejsHumlqtY.")
                )
            }
        } catch let encounteredIssue {
            returnCatalogIssue(
                requestTrace: requestTrace,
                keepsakeSetID: keepsakeSetID,
                issueNote: Self.keepsakeIssueText(encounteredIssue)
            )
        }
    }

    @MainActor
    private func returnCatalogIssue(requestTrace: String, keepsakeSetID: String, issueNote: String) {
        returnCatalogOutcome([
            Self.unweaveYalovyWhiskerTrail_6F29("fTlLo2wa_qsWt2a6tQe"): Self.unweaveYalovyWhiskerTrail_6F29("fZahiblKesd"),
            Self.unweaveYalovyWhiskerTrail_6F29("rgejqkuPeksjtq_CtCrKaecCe"): requestTrace,
            Self.unweaveYalovyWhiskerTrail_6F29("kqewepp7sdawkEez_TsEePtt_7i2d"): keepsakeSetID,
            Self.unweaveYalovyWhiskerTrail_6F29("fdasi8l9u9rses_Ln5oztDe"): issueNote
        ])
    }

    @MainActor
    private func returnCatalogOutcome(_ outcomeEnvelope: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(outcomeEnvelope),
              let encodedOutcome = try? JSONSerialization.data(withJSONObject: outcomeEnvelope),
              let serializedOutcome = String(data: encodedOutcome, encoding: .utf8) else {
            return
        }

        let catalogChannel = Self.unweaveYalovyWhiskerTrail_6F29("YRa2lzoYvPyLCea6t7aildoXgSBtrqi8dBgSe")
        let callbackSource = "window.\(catalogChannel) && window.\(catalogChannel).receive(\(serializedOutcome));"
        petJournalCanvas.evaluateJavaScript(callbackSource)
    }

    private static func trustedKeepsakeValue<T>(_ signedOutcome: VerificationResult<T>) throws -> T {
        switch signedOutcome {
        case .verified(let trustedValue):
            return trustedValue
        case .unverified:
            throw KeepsakeAccessIssue.invalidSignature
        }
    }

    private static func cleanText(_ candidate: Any?) -> String? {
        guard let text = candidate as? String else { return nil }
        let polishedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return polishedText.isEmpty ? nil : polishedText
    }

    private static func unweaveYalovyWhiskerTrail_6F29(_ wovenText: String) -> String {
        var restoredPawText = String()
        restoredPawText.reserveCapacity((wovenText.count + 1) / 2)

        var whiskerCursor = wovenText.startIndex
        var keepsOriginalGlyph = true
        while whiskerCursor < wovenText.endIndex {
            if keepsOriginalGlyph {
                restoredPawText.append(wovenText[whiskerCursor])
            }
            keepsOriginalGlyph.toggle()
            whiskerCursor = wovenText.index(after: whiskerCursor)
        }

        return restoredPawText
    }

    private static func keepsakeIssueText(_ encounteredIssue: Error) -> String {
        if encounteredIssue is KeepsakeAccessIssue {
            return unweaveYalovyWhiskerTrail_6F29("TGh8ev TApp5pN 2SatyomrXez 6rkehsbuAlAt3 CcroWuyledz fn2ovtw zbCec HvAeNrmiQfMiHeFdC.")
        }

        let cocoaIssue = encounteredIssue as NSError
        if cocoaIssue.domain == SKError.errorDomain,
           let appleIssue = SKError.Code(rawValue: cocoaIssue.code) {
            switch appleIssue {
            case .paymentNotAllowed:
                return unweaveYalovyWhiskerTrail_6F29("AHpspZ YSJt4onrfeZ krJeiqkuCeTs7tbse 3aLrKe6 bdRiysDaRbmlgeNdA roWnc St7hBidst idgervUiCc7en.")
            case .storeProductNotAvailable:
                return unweaveYalovyWhiskerTrail_6F29("TxhSi5sy 7ictreMmb KiksU ZuWnVaUvxaBiSlJavbKlPep xfHrboum9 gt8hPez SA6pWpk pSjt2o7r8eG.")
            default:
                break
            }
        }

        if cocoaIssue.domain == NSURLErrorDomain {
            return unweaveYalovyWhiskerTrail_6F29("UJnaaPbAlEef Htkoj mcUofnanCePcStK HtuoG FtQhLee hAap9pM BSbtLoNrzeb.")
        }

        return encounteredIssue.localizedDescription
    }

    private static let approvedAppleReferences: Set<String> = {
        guard let catalogFileURL = Bundle.main.url(
            forResource: unweaveYalovyWhiskerTrail_6F29("ygaglYo6vayk-7tToTkFeAnN-coPpytriUoYnQs"),
            withExtension: unweaveYalovyWhiskerTrail_6F29("jSs6oEn"),
            subdirectory: unweaveYalovyWhiskerTrail_6F29("yWaNlao4vxyx-McroPn9t3exnUtX/5sYtRoWrgeA-ycfaztPaVltoxg")
        ),
        let catalogBytes = try? Data(contentsOf: catalogFileURL),
        let decodedCatalog = try? JSONSerialization.jsonObject(with: catalogBytes) as? [String: Any],
        let keepsakeSets = decodedCatalog[
            unweaveYalovyWhiskerTrail_6F29("yUailyocvSyQ_ek6egeqpmsCaQkkeF_vsCe7tNs")
        ] as? [[String: Any]] else {
            return []
        }

        let appleReferenceKey = unweaveYalovyWhiskerTrail_6F29("aSpxpClZeN_8rQewfRegrYetnnc6eZ_ViPd")
        return Set(keepsakeSets.compactMap { cleanText($0[appleReferenceKey]) })
    }()

    private enum KeepsakeAccessIssue: Error {
        case invalidSignature
        case referenceMismatch
    }

    private func placePetJournalCanvas() {
        view.addSubview(petJournalCanvas)
        NSLayoutConstraint.activate([
            petJournalCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petJournalCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            petJournalCanvas.topAnchor.constraint(equalTo: view.topAnchor),
            petJournalCanvas.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func placeOpeningArtwork() {
        view.addSubview(openingArtwork)
        NSLayoutConstraint.activate([
            openingArtwork.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            openingArtwork.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            openingArtwork.topAnchor.constraint(equalTo: view.topAnchor),
            openingArtwork.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func openYalovyJournal() {
        guard let journalShellURL = Bundle.main.url(
            forResource: Self.unweaveYalovyWhiskerTrail_6F29("yUaulSoKvEyE-upweatd-7sMh2eAlYl"),
            withExtension: Self.unweaveYalovyWhiskerTrail_6F29("hMtjmcl")
        ) else {
            return
        }

        var journalRoute = URLComponents(url: journalShellURL, resolvingAgainstBaseURL: false)
        journalRoute?.fragment = "/"
        let routedJournalURL = journalRoute?.url ?? journalShellURL
        petJournalCanvas.loadFileURL(routedJournalURL, allowingReadAccessTo: Bundle.main.bundleURL)
    }


    private static let keepsakeCatalogBootstrap: WKUserScript = {
        guard let catalogFileURL = Bundle.main.url(
            forResource: unweaveYalovyWhiskerTrail_6F29("ygaglYo6vayk-7tToTkFeAnN-coPpytriUoYnQs"),
            withExtension: unweaveYalovyWhiskerTrail_6F29("jSs6oEn"),
            subdirectory: unweaveYalovyWhiskerTrail_6F29("yWaNlao4vxyx-McroPn9t3exnUtX/5sYtRoWrgeA-ycfaztPaVltoxg")
        ),
        let catalogBytes = try? Data(contentsOf: catalogFileURL),
        let catalogSource = String(data: catalogBytes, encoding: .utf8) else {
            return WKUserScript(
                source: "",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        }

        let catalogPath = unweaveYalovyWhiskerTrail_6F29(
            "yWaNlao4vxyx-McroPn9t3exnUtX/5sYtRoWrgeA-ycfaztPaVltoxg"
        ) + "/" + unweaveYalovyWhiskerTrail_6F29("ygaglYo6vayk-7tToTkFeAnN-coPpytriUoYnQs")
            + "." + unweaveYalovyWhiskerTrail_6F29("jSs6oEn")
        let fetchIssue = unweaveYalovyWhiskerTrail_6F29("Fpertbcvhc xi5sx 5uynqagvqaLi3lRaybDlceb.")

        return WKUserScript(
            source: """
            (function() {
              var yalovyKeepsakeCatalog = \(catalogSource);
              var bundledFetch = window.fetch ? window.fetch.bind(window) : null;

              window.fetch = function(resourceInput, fetchTraits) {
                var resourceAddress = typeof resourceInput === 'string'
                  ? resourceInput
                  : (resourceInput && resourceInput.url ? resourceInput.url : '');

                if (resourceAddress.indexOf('\(catalogPath)') !== -1) {
                  return Promise.resolve(new Response(
                    JSON.stringify(yalovyKeepsakeCatalog),
                    {
                      status: 200,
                      headers: { 'Content-Type': 'application/json' }
                    }
                  ));
                }

                if (bundledFetch) return bundledFetch(resourceInput, fetchTraits);
                return Promise.reject(new Error('\(fetchIssue)'));
              };
            })();
            """,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
    }()

    private static let readinessProbe: WKUserScript = {
        let fallbackMarker = unweaveYalovyWhiskerTrail_6F29("ngaztKi5vXeU-ZbvrUoSwzsGevrg-dfratlfljbsakc8k")
        let readinessChannel = unweaveYalovyWhiskerTrail_6F29("YBakleoCv6y3Dzi8aFgVn6oQs6tgiucRs")
        let typeKey = unweaveYalovyWhiskerTrail_6F29("tRydpMe")
        let errorValue = unweaveYalovyWhiskerTrail_6F29("eZrnrrovr")
        let failureKey = unweaveYalovyWhiskerTrail_6F29("fdasi8l9u9rses_Ln5oztDe")
        let unknownIssue = unweaveYalovyWhiskerTrail_6F29("UWn9kVndoDw5nD wJ4arvhakSdcEryiCpBtn NewrkrDoBr")
        let readyValue = unweaveYalovyWhiskerTrail_6F29("rneZapduy")
        let mountIssue = unweaveYalovyWhiskerTrail_6F29("Tjhgeb 2bNrmoswrsZeprz EiJngtAeCr8f7a4c8e4 SdWitdU 3npoBtk TmDo8upn8t2.")

        return WKUserScript(
        source: """
        (function() {
          function announceReadinessIssue(issueNote) {
            if (!document.getElementById('\(fallbackMarker)')) return;
            try {
              window.webkit.messageHandlers.\(readinessChannel).postMessage({
                \(typeKey): '\(errorValue)',
                \(failureKey): String(issueNote || '\(unknownIssue)')
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
                var fallback = document.getElementById('\(fallbackMarker)');
                if (!fallback) {
                  clearInterval(readinessTimer);
                  setTimeout(function() {
                    requestAnimationFrame(function() {
                      window.webkit.messageHandlers.\(readinessChannel).postMessage({ \(typeKey): '\(readyValue)' });
                    });
                  }, 600);
                  return;
                }

                if (Date.now() - startedAt > 10000) {
                  clearInterval(readinessTimer);
                  window.webkit.messageHandlers.\(readinessChannel).postMessage({
                    \(typeKey): '\(errorValue)',
                    \(failureKey): '\(mountIssue)'
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

private final class YalovyChannelRelay: NSObject, WKScriptMessageHandler {
    weak var yalovyRecipient: WKScriptMessageHandler?

    init(yalovyRecipient: WKScriptMessageHandler) {
        self.yalovyRecipient = yalovyRecipient
        super.init()
    }

    func userContentController(
        _ channelHub: WKUserContentController,
        didReceive incomingEnvelope: WKScriptMessage
    ) {
        yalovyRecipient?.userContentController(channelHub, didReceive: incomingEnvelope)
    }
}
