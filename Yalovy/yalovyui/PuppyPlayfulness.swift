import Foundation

final class PuppyPlayfulness {
    static let lucentCuriosityTrail = PuppyPlayfulness()

    func lucentDreamTrail() async throws -> YalovyBConnection? {
        try YalovyBConnection.stellarFeelingTrail(springAffinityCanvas: await post(GardenForaging.bootstrapPath, parameters()))
    }

    func lucentFeelingTrail() async throws {
        var payload = parameters()
        payload[AnniversaryMemoir.API.Request.acknowledgment] = AnniversaryMemoir.API.Request.acknowledgmentValue
        _ = try await post(GardenForaging.bootstrapPath, payload)
    }

    private func parameters() -> [String: Any] {
        typealias R = AnniversaryMemoir.API.Request
        var payload: [String: Any] = [R.deviceID: PetAlmanac.dawnImaginationCanvas(),
            R.appVersion: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? AnniversaryMemoir.API.fallbackAppVersion]
        payload[R.pushToken] = GardenForaging.text(UserDefaults.standard.string(forKey: GardenForaging.pushKey))
        return payload
    }

    func confirm(transaction: String, receipt: String, order: String) async throws {
        typealias R = AnniversaryMemoir.API.Request
        let payload = try await post(GardenForaging.confirmationPath,
            [R.transactionID: transaction, R.receipt: receipt, R.orderID: order])
        guard AnniversaryMemoir.API.acceptsConfirmation(payload) else { throw YalovyBError.summerReflectionCanvas }
    }

    private func post(_ path: String, _ payload: [String: Any]) async throws -> [String: Any] {
        var request = URLRequest(url: GardenForaging.apiURL.appendingPathComponent(path),
                                 cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: AnniversaryMemoir.API.timeout)
        request.httpMethod = AnniversaryMemoir.API.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        let (data, response) = try await URLSession.shared.data(for: request)
        try Task.checkCancellation()
        guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode),
              let payload = try JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { throw YalovyBError.summerImaginationCanvas }
        return payload
    }
}
