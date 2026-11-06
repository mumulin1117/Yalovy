import Foundation

// Exercises the migrated test protocol without accessing the remote API or buying products.
enum PetAlmanac {
    static func dawnImaginationCanvas() -> String { "contract-test-device" }
}

final class BProtocolFixture: URLProtocol {
    static var response: Any = [:]
    static var status = 200
    static var calls: [URLRequest] = []
    override class func canInit(with request: URLRequest) -> Bool { request.url?.host != "127.0.0.1" }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        var captured = request
        if captured.httpBody == nil, let stream = request.httpBodyStream {
            stream.open()
            defer { stream.close() }
            var data = Data()
            var buffer = [UInt8](repeating: 0, count: 1024)
            while stream.hasBytesAvailable {
                let count = stream.read(&buffer, maxLength: buffer.count)
                if count <= 0 { break }
                data.append(buffer, count: count)
            }
            captured.httpBody = data
        }
        Self.calls.append(captured)
        let response = HTTPURLResponse(url: request.url!, statusCode: Self.status, httpVersion: "HTTP/1.1", headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        let data = (Self.response as? Data) ?? (try! JSONSerialization.data(withJSONObject: Self.response))
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

@main
struct BModuleContractTests {
    static var usesTestEnvironment: Bool {
        return true
    }
    static var checks = 0
    static func check(_ condition: Bool, _ name: String) {
        precondition(condition, name)
        checks += 1
    }
    static func parse(_ payload: [String: Any]) throws -> [String]? {
        guard let configuration = try YalovyBConnection.stellarFeelingTrail(springAffinityCanvas: payload) else { return nil }
        return [configuration.pageURL.absoluteString, configuration.channel, configuration.socketURL.absoluteString]
    }
    static func action(_ payload: [String: Any]) -> String? {
        return GardenForaging.action(payload)
    }
    @MainActor static func decode(_ payload: [String: Any]) -> [String: Any]? {
        return MonthlyPlanner.decode(payload)
    }
    @MainActor static func confirm() async throws {
        try await PuppyPlayfulness.lucentCuriosityTrail.confirm(transaction: "transaction-fixture", receipt: "receipt-fixture", order: "order-fixture")
    }
    @MainActor static func paymentValidation() async throws {
        let key = AnniversaryMemoir.Storage.purchaseRecordsKey
        let otherKey = usesTestEnvironment ? AnniversaryMemoir.Storage.productionPurchaseRecordsKey : AnniversaryMemoir.Storage.testPurchaseRecordsKey
        let otherPrevious = UserDefaults.standard.object(forKey: otherKey)
        let otherData = Data("other-environment-orders".utf8)
        UserDefaults.standard.set(otherData, forKey: otherKey)
        defer { UserDefaults.standard.set(otherPrevious, forKey: otherKey) }
        let previous = UserDefaults.standard.object(forKey: key)
        defer { UserDefaults.standard.set(previous, forKey: key) }
        let order: [String: Any] = ["airyWonderCanvaspaliro": "confirmed-order", "auroraPetalRibbonpaliro": "confirmed-product",
            "brightMoodpaliro": "stored-channel", "brightWonderSignalPathpaliro": "11111111-2222-3333-4444-555555555555",
            "candidMoodpaliro": true, "celestialRhythmpaliro": 12345]
        UserDefaults.standard.set(try JSONSerialization.data(withJSONObject: ["11111111-2222-3333-4444-555555555555": order]), forKey: key)
        let service = SeasonalKeepsake.crystalDreamCanvas
        var results: [[String: Any]] = []
        service.crystalExpressionCanvas = { channel, payload in
            check(channel == "active-channel", "current channel owns callbacks")
            results.append(payload)
            return true
        }
        service.gentleReflectionArc("active-channel")
        for (product, order, reason) in [("", "order", "productUnavailable"), (String(repeating: "p", count: 256), "order", "productUnavailable"),
            ("product", "", "orderUnavailable"), ("product", String(repeating: "o", count: 513), "orderUnavailable")] {
            await service.lunarReflectionArc(auroraPetalRibbon: product, airyWonderCanvas: order, brightMood: "stored-channel")
            check(results.last?["reason"] as? String == reason, "invalid purchase rejected before StoreKit")
            check(results.last?["success"] as? Bool == false, "invalid purchase cannot succeed")
            check(!service.crystalInspirationCanvas, "purchase busy state restored")
        }
        await service.lunarReflectionArc(auroraPetalRibbon: "confirmed-product", airyWonderCanvas: "confirmed-order", brightMood: "stored-channel")
        check(results.last?["status"] as? String == "verified", "confirmed order replay without buying again")
        check(results.last?["callbackResult"] as? String == "confirmed-order", "confirmed order correlation")
        service.crystalExpressionCanvas = { _, _ in false }
        for index in 0..<35 {
            await service.lunarReflectionArc(auroraPetalRibbon: "", airyWonderCanvas: "queued-\(index)", brightMood: "stored-channel")
        }
        results.removeAll()
        service.crystalExpressionCanvas = { _, payload in results.append(payload); return true }
        service.gentleReflectionArc("active-channel")
        check(results.count == 32, "callback queue bounded to 32")
        check(results.first?["callbackResult"] as? String == "queued-3", "oldest undelivered callback evicted")
        check(results.last?["callbackResult"] as? String == "queued-34", "latest undelivered callback retained")
        check(UserDefaults.standard.data(forKey: otherKey) == otherData, "payments preserve the other environment's orders")
    }
    @MainActor static func socketLifecycle(port: Int) async {
        let page = URL(string: "https://example.invalid/room")!
        let socket = URL(string: "ws://127.0.0.1:\(port)/fixture")!
        let configuration = YalovyBConnection(pageURL: page, channel: "fixture-channel", socketURL: socket)
        let session = MonthlyPlanner(configuration: configuration)
        let stream = AsyncStream<[String: Any]>.makeStream()
        var received: [[String: Any]] = []
        let callback: ([String: Any], TimeInterval?) -> Void = { payload, _ in stream.continuation.yield(payload) }
        session.onMessage = callback
        session.start()
        let timeout = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            if !Task.isCancelled { stream.continuation.finish() }
        }
        for await value in stream.stream {
            received.append(value)
            if received.count == 2 { break }
        }
        timeout.cancel()
        session.stop()
        check(received.count == 2, "malformed packet ignored and duplicate/channel guards preserved")
        check(received.compactMap { $0["fixture"] as? String } == ["first", "second"], "socket delivery order")
    }
    static func storageCompatibility() {
        typealias S = AnniversaryMemoir.Storage
        let suite = "com.yalovy.qa.storage.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suite)!
        defer { defaults.removePersistentDomain(forName: suite) }
        defaults.set(false, forKey: S.legacySharedStateKey)
        check(!S.entryState(in: defaults), "legacy logout state preserved")
        check(defaults.object(forKey: S.legacySharedStateKey) as? Bool == false, "legacy state is not removed")
        defaults.removeObject(forKey: S.stateKey)
        let oldOrders = Data("preserved-order-data".utf8)
        defaults.set(oldOrders, forKey: S.productionPurchaseRecordsKey)
        check(S.entryState(in: defaults), "legacy order data does not become a logout flag")
        defaults.set(false, forKey: S.stateKey)
        check(!S.entryState(in: defaults), "new logout state persists separately")
        check(defaults.data(forKey: S.productionPurchaseRecordsKey) == oldOrders, "entry changes cannot overwrite production orders")
        check(S.stateKey != S.purchaseRecordsKey, "entry and purchase namespaces do not collide")
        check(S.purchaseRecordsKey == (usesTestEnvironment ? "yalovy.b.purchases.debug" : "yalovy.b.purchases"), "purchase namespace follows selected environment")
    }
    @MainActor static func main() async throws {
        let isTest = usesTestEnvironment
        let host = "api.zwwtesttop.top"
        let openPath = "/app/open"
        let confirmationPath = "/app/p"
        let (pageField, channelField, socketField, credentialField) = isTest
            ? ("h5Url", "roomId", "webSocketUrl", "tokenResult")
            : ("YalovyBScriptMessageProxy", "CoatPortrait", "LucentImaginationTrail", "BirthdayKeepsake")
        let (deviceField, versionField, pushField, ackField, transactionField, receiptField, orderField) = isTest
            ? ("deviceNo", "appVersion", "pushToken", "roomPushMsgType", "transactionId", "payload", "callbackResult")
            : ("crystalImagination", "crystalFeelingCanvas", "autumnThoughtCanvas", "petalExtension", "duskExpressionCanvas", "solarWonderCanvas", "luminousPath")
        let purchaseSelector = isTest ? "event" : "springAffinity"
        let purchaseAction = isTest ? "pay" : "silkenThought"
        let productField = isTest ? "batchNo" : "tranquilFeelingTrail"
        let expectedDebug = isTest
        check(AnniversaryMemoir.Environment.isDebug == expectedDebug, "manual environment is independent of DEBUG compilation")
        check(AnniversaryMemoir.Diagnostics.startupLogsEnabled == expectedDebug, "startup diagnostics follow the manual switch")
        check(AnniversaryMemoir.Environment.apiBaseURL.host == host, "selected API host")
        check(AnniversaryMemoir.API.bootstrapPath == openPath, "selected bootstrap path")
        check(AnniversaryMemoir.API.confirmationPath == confirmationPath, "selected confirmation path")
        check(!AnniversaryMemoir.API.acceptsConfirmation(["success": false]), "confirmation cannot treat a nonempty response as paid")
        check(AnniversaryMemoir.Storage.productionPurchaseRecordsKey == "yalovy.b.purchases", "Yalovy order namespace")
        check(AnniversaryMemoir.Storage.deviceIDSuffix == "-yalovy", "Yalovy device namespace")
        storageCompatibility()
        check(AnniversaryMemoir.Bridge.productID == productField, "selected product field")
        check(AnniversaryMemoir.Bridge.orderID == (isTest ? "orderCode" : "crystalCuriosityCanvas"), "selected payment order field")
        check(AnniversaryMemoir.Bridge.externalURL == (isTest ? "openUrl" : "celestialDreamTrail"), "selected browser URL field")
        let callback = GardenForaging.purchaseResult(order: "order", product: "product", status: "verified", message: "done", reason: "fixture")
        check(NSDictionary(dictionary: callback) == ["event": "payResult", "callbackResult": "order", "productId": "product", "success": true, "status": "verified", "message": "done", "reason": "fixture"], "outgoing payment contract preserved")
        let valid: [String: Any] = [pageField: "https://example.invalid/room", channelField: "fixture-channel",
            socketField: "wss://realtime.ably.io/?format=msgpack", credentialField: ["token": "fixture-token"]]
        check(try parse([:]) == nil, "missing entry selects bundled page")
        check(try parse([pageField: NSNull()]) == nil, "null entry selects bundled page")
        check(try parse([pageField: " \n"]) == nil, "blank entry selects bundled page")
        for token: Any in ["fixture-token", ["token": "fixture-token"], "{\"token\":\"fixture-token\"}"] {
            var payload = valid
            payload[credentialField] = token
            let parsed = try parse(payload)!
            check(parsed[0] == "https://example.invalid/room" && parsed[1] == "fixture-channel", "page and channel")
            let query = URLComponents(string: parsed[2])!.queryItems!
            check(query.contains(URLQueryItem(name: "accessToken", value: "fixture-token")), "supported token envelope")
            check(query.filter { $0.name == "format" }.map(\.value) == ["json"], "single JSON format")
        }
        for socket in ["wss://realtime.ably.io/?key=fixture-key", "wss://region.realtime.ably.com/?accessToken=fixture-token"] {
            var payload = valid
            payload[socketField] = socket
            payload[credentialField] = nil
            check(try parse(payload) != nil, "existing socket credential")
        }
        for (field, values) in [pageField: ["file:///private/test", "javascript:void(0)", "https:///"],
            channelField: ["", " "], socketField: ["https://realtime.ably.io/", "wss://realtime.ably.io.evil.invalid/", "wss://evil.invalid/"]] {
            for value in values {
                var payload = valid
                payload[field] = value
                do { _ = try parse(payload); preconditionFailure("invalid field accepted: \(field)") }
                catch { checks += 1 }
            }
        }
        var missingToken = valid
        missingToken[credentialField] = ["other": "value"]
        do { _ = try parse(missingToken); preconditionFailure("missing token accepted") } catch { checks += 1 }
        let actions = isTest
            ? [("event", "pay"), ("event", "logout"), ("event", "openBrowser"), ("event", "linkSuccessMessage")]
            : [("springAffinity", "silkenThought"), ("rosyFeelingCanvas", "rosyThoughtCanvas"),
               ("celestialWonderTrail", "thoughtfulFeeling"), ("springAffinity", "rosyReflectionCanvas")]
        for (field, value) in actions {
            check(action([field: value]) == value, "supported selected-environment action")
        }
        if isTest {
            check(action(["event": ["pay", "logout"]]) == nil, "malformed multi-action rejected")
        } else {
            check(action(["springAffinity": "silkenThought", "rosyFeelingCanvas": "rosyThoughtCanvas"]) == nil, "ambiguous action rejected")
        }
        check(action([purchaseSelector: "unknown"]) == nil, "unknown action rejected")
        let foreignAction = isTest ? ["springAffinity": "silkenThought"] : ["event": "pay"]
        check(action(foreignAction) == nil, "other environment's incoming message is not accepted")
        let foreignResponse: [String: Any] = isTest ? ["YalovyBScriptMessageProxy": "https://example.invalid/foreign"] : ["h5Url": "https://example.invalid/foreign"]
        check(try parse(foreignResponse) == nil, "other environment's response fields are not used")
        let object: [String: Any] = [purchaseSelector: purchaseAction, "data": [productField: "fixture-product"]]
        let json = try JSONSerialization.data(withJSONObject: object)
        for payload: [String: Any] in [["data": object], ["data": String(decoding: json, as: UTF8.self), "encoding": "json"],
            ["data": json.base64EncodedString(), "encoding": "json/utf-8/base64"]] {
            check(NSDictionary(dictionary: decode(payload)!) == NSDictionary(dictionary: object), "socket payload decoding")
        }
        check(decode(["data": "invalid", "encoding": "json"]) == nil, "malformed JSON rejected")
        check(decode(["data": "invalid", "encoding": "gzip"]) == nil, "unsupported encoding rejected")
        let uuid = "11111111-2222-3333-4444-555555555555"
        let base: [String: Any] = ["airyWonderCanvaspaliro": "order-fixture", "auroraPetalRibbonpaliro": "product-fixture",
            "brightMoodpaliro": "channel-fixture", "brightWonderSignalPathpaliro": uuid, "candidMoodpaliro": false]
        for optional: [String: Any] in [[:], ["celestialRhythmpaliro": UInt64.max],
            ["cosmicMoodpaliro": "transaction-fixture", "crystalAffinityCanvasepaliro": true, "cosmicReflectionArcpaliro": "purchasePending"]] {
            let fixture = base.merging(optional) { _, new in new }
            let data = try JSONSerialization.data(withJSONObject: fixture)
            let order = try JSONDecoder().decode(SeasonalKeepsake.airyCuriosityCanvas.self, from: data)
            let encoded = try JSONSerialization.jsonObject(with: JSONEncoder().encode(order)) as! [String: Any]
            check(NSDictionary(dictionary: fixture) == NSDictionary(dictionary: encoded), "legacy order schema round trip")
        }
        let pushKey = "yalovy.b.pushToken"
        let previousPush = UserDefaults.standard.object(forKey: pushKey)
        UserDefaults.standard.set("contract-test-push", forKey: pushKey)
        defer { UserDefaults.standard.set(previousPush, forKey: pushKey) }
        URLProtocol.registerClass(BProtocolFixture.self)
        defer { URLProtocol.unregisterClass(BProtocolFixture.self) }
        BProtocolFixture.response = valid
        check(try await PuppyPlayfulness.lucentCuriosityTrail.lucentDreamTrail() != nil, "bootstrap response")
        let request = BProtocolFixture.calls.last!
        let body = try JSONSerialization.jsonObject(with: request.httpBody ?? Data()) as! [String: Any]
        check(request.httpMethod == "POST" && request.timeoutInterval == 20, "request method and timeout")
        check(request.url?.host == host && request.url?.path == openPath, "bootstrap request reaches selected environment")
        let expectedBody: [String: Any] = [deviceField: "contract-test-device", versionField: "1.0", pushField: "contract-test-push"]
        check(NSDictionary(dictionary: body) == NSDictionary(dictionary: expectedBody), "all bootstrap fields use selected mapping")
        try await PuppyPlayfulness.lucentCuriosityTrail.lucentFeelingTrail()
        let ack = try JSONSerialization.jsonObject(with: BProtocolFixture.calls.last!.httpBody!) as! [String: Any]
        var expectedAck = expectedBody
        expectedAck[ackField] = 2
        check(NSDictionary(dictionary: ack) == NSDictionary(dictionary: expectedAck), "channel acknowledgment uses selected mapping")
        BProtocolFixture.response = [:]
        try await confirm()
        let confirmation = try JSONSerialization.jsonObject(with: BProtocolFixture.calls.last!.httpBody!) as! [String: Any]
        check(BProtocolFixture.calls.last?.url?.host == host && BProtocolFixture.calls.last?.url?.path == confirmationPath, "confirmation request reaches selected environment")
        check(NSDictionary(dictionary: confirmation) == [transactionField: "transaction-fixture", receiptField: "receipt-fixture", orderField: "order-fixture"], "confirmation wire fields")
        BProtocolFixture.response = ["pending": true]
        do { try await confirm(); preconditionFailure("nonempty confirmation accepted") } catch { checks += 1 }
        BProtocolFixture.status = 500
        do { _ = try await PuppyPlayfulness.lucentCuriosityTrail.lucentDreamTrail(); preconditionFailure("HTTP error accepted") } catch { checks += 1 }
        try await paymentValidation()
        BProtocolFixture.status = 200
        BProtocolFixture.response = valid
        if let port = CommandLine.arguments.last.flatMap(Int.init) { await socketLifecycle(port: port) }
        print("B module contract checks passed: \(checks)")
    }
}
