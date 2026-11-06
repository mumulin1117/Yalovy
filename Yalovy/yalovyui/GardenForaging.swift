import Foundation

// Wire fields and persisted keys retain their existing values.
enum GardenForaging {
    static let apiURL = AnniversaryMemoir.Environment.apiBaseURL
    static let bootstrapPath = AnniversaryMemoir.API.bootstrapPath
    static let confirmationPath = AnniversaryMemoir.API.confirmationPath
    static let stateKey = AnniversaryMemoir.Storage.stateKey
    static let pushKey = AnniversaryMemoir.Storage.pushTokenKey
    static let close = AnniversaryMemoir.Bridge.closeAction

    static func text(_ value: Any?) -> String? {
        guard let value = value as? String else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    static func dictionary(_ value: Any?) -> [String: Any]? {
        if let value = value as? [String: Any] { return value }
        guard let value = value as? String, let data = value.data(using: .utf8) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    }

    static func sameOrigin(_ lhs: URL, _ rhs: URL) -> Bool {
        func port(_ url: URL) -> Int { url.port ?? (url.scheme == "https" ? 443 : 80) }
        return lhs.scheme?.lowercased() == rhs.scheme?.lowercased()
            && lhs.host?.lowercased() == rhs.host?.lowercased() && port(lhs) == port(rhs)
    }

    static func action(_ payload: [String: Any]) -> String? {
        typealias B = AnniversaryMemoir.Bridge
        let fields = [(B.purchaseSelector, B.purchaseAction), (B.closeSelector, close),
                      (B.openSelector, B.openAction), (B.forwardSelector, B.forwardAction)]
        let matches = fields.filter { text(payload[$0.0]) == $0.1 }
        return matches.count == 1 ? matches.first?.1 : nil
    }

    static func externalURL(_ value: Any?) -> URL? {
        guard var value = text(value) else { return nil }
        if value.hasPrefix("["), value.hasSuffix(")"), let range = value.range(of: "](", options: .backwards) {
            value = String(value[range.upperBound...].dropLast())
        }
        return text(value).flatMap(URL.init(string:))
    }

    static func purchaseResult(order: String, product: String, status: String, message: String,
                               reason: String? = nil) -> [String: Any] {
        typealias C = AnniversaryMemoir.Callback
        var payload: [String: Any] = [C.event: C.purchaseEvent, C.orderID: order, C.productID: product,
                                    C.success: status == "verified", C.status: status, C.message: message]
        if let reason { payload[C.reason] = reason }
        return payload
    }
}

struct YalovyBConnection {
    let pageURL: URL
    let channel: String
    let socketURL: URL

    static func stellarFeelingTrail(springAffinityCanvas payload: [String: Any]) throws -> Self? {
        typealias R = AnniversaryMemoir.API.Response
        typealias N = AnniversaryMemoir.Network
        guard let value = payload[R.pageURL], !(value is NSNull) else { return nil }
        if let value = value as? String, GardenForaging.text(value) == nil { return nil }
        guard let page = GardenForaging.text(value), let pageURL = URL(string: page),
              N.pageSchemes.contains(pageURL.scheme?.lowercased() ?? ""), pageURL.host != nil,
              let channel = GardenForaging.text(payload[R.channel]),
              let socket = GardenForaging.text(payload[R.socketURL]),
              var components = URLComponents(string: socket),
              N.socketSchemes.contains(components.scheme?.lowercased() ?? ""),
              let host = components.host?.lowercased(),
              N.socketHosts.contains(where: { host == $0 || host.hasSuffix("." + $0) })
        else { throw YalovyBError.summerInspirationCanvas }
        let tokenValue = payload[R.credential]
        let token = GardenForaging.dictionary(tokenValue).map { GardenForaging.text($0[R.credentialToken]) }
            ?? GardenForaging.text(tokenValue)
        var query = components.queryItems ?? []
        if !query.contains(where: { N.socketCredentialQueryNames.contains($0.name) && !($0.value ?? "").isEmpty }) {
            guard let token else { throw YalovyBError.summerInspirationCanvas }
            query.append(URLQueryItem(name: N.socketTokenQueryName, value: token))
        }
        query.removeAll { $0.name == "format" }
        components.queryItems = query + [URLQueryItem(name: "format", value: "json")]
        guard let socketURL = components.url else { throw YalovyBError.summerInspirationCanvas }
        return Self(pageURL: pageURL, channel: channel, socketURL: socketURL)
    }
}

enum YalovyBError: LocalizedError {
    case summerImaginationCanvas, summerInspirationCanvas, summerReflectionCanvas
    var errorDescription: String? {
        switch self {
        case .summerImaginationCanvas: return "Unable to connect. Please try again."
        case .summerInspirationCanvas: return "The connection details are incomplete. Please try again later."
        case .summerReflectionCanvas: return "Your purchase is awaiting confirmation. Please try again later."
        }
    }
}
