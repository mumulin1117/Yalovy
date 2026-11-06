import Foundation

@MainActor
final class MonthlyPlanner {
    var onMessage: (([String: Any], TimeInterval?) -> Void)?
    var onUnavailable: (() -> Void)?
    var onChanged: (() -> Void)?
    private var configuration: YalovyBConnection
    private var connection: Task<Void, Never>?
    private var heartbeat: Task<Void, Never>?
    private var acknowledgment: Task<Void, Never>?
    private var socket: URLSessionWebSocketTask?
    private var receivedIDs: [String] = []
    private var reconnect = false
    private var failures = 0

    init(configuration: YalovyBConnection) { self.configuration = configuration }

    func start() {
        guard connection == nil else { return }
        connection = Task { [weak self] in
            while !Task.isCancelled {
                guard let self else { return }
                do {
                    if self.reconnect {
                        guard let next = try await PuppyPlayfulness.lucentCuriosityTrail.lucentDreamTrail()
                        else {
                            self.onUnavailable?()
                            return
                        }
                        guard next.channel == self.configuration.channel,
                              GardenForaging.sameOrigin(next.pageURL, self.configuration.pageURL)
                        else {
                            self.onChanged?()
                            return
                        }
                        self.configuration = next
                    }
                    self.reconnect = true
                    try Task.checkCancellation()
                    try await self.receive()
                } catch {
                    guard !Task.isCancelled else { return }
                    self.disconnect(code: .goingAway)
                    let delay = min(pow(2, Double(self.failures)), 30)
                    self.failures = min(self.failures + 1, 5)
                    try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
    }

    func stop() {
        reconnect = false
        connection?.cancel()
        connection = nil
        disconnect()
    }

    private func disconnect(code: URLSessionWebSocketTask.CloseCode = .normalClosure) {
        acknowledgment?.cancel()
        acknowledgment = nil
        heartbeat?.cancel()
        heartbeat = nil
        socket?.cancel(with: code, reason: nil)
        socket = nil
    }

    private func receive() async throws {
        // 以下 action/channel/messages/encoding 为 Ably 固定协议；项目业务字段在 AnniversaryMemoir.Bridge 中配置。
        let socket = URLSession.shared.webSocketTask(with: configuration.socketURL)
        self.socket = socket
        socket.resume()
        heartbeat = Task { [weak socket] in
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 25_000_000_000)
                guard !Task.isCancelled, let socket else { return }
                socket.sendPing { if $0 != nil { socket.cancel(with: .goingAway, reason: nil) } }
            }
        }
        while !Task.isCancelled {
            let message = try await socket.receive()
            try Task.checkCancellation()
            let data: Data
            switch message {
            case .data(let value): data = value
            case .string(let value): data = Data(value.utf8)
            @unknown default: continue
            }
            guard data.count <= 1_048_576,
                  let payload = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else { continue }
            switch payload["action"] as? Int {
            case 4:
                let data = try JSONSerialization.data(withJSONObject: ["action": 10, "channel": configuration.channel])
                try await socket.send(.string(String(decoding: data, as: UTF8.self)))
            case 11:
                guard self.socket === socket, payload["channel"] as? String == configuration.channel else { continue }
                failures = 0
                if acknowledgment == nil {
                    acknowledgment = Task {
                        for attempt in 0..<3 {
                            do {
                                try Task.checkCancellation()
                                return try await PuppyPlayfulness.lucentCuriosityTrail.lucentFeelingTrail()
                            }
                            catch {
                                guard !Task.isCancelled, attempt < 2 else { return }
                                try? await Task.sleep(nanoseconds: UInt64(attempt + 1) * 1_000_000_000)
                            }
                        }
                    }
                }
            case 15:
                guard payload["channel"] as? String == configuration.channel,
                      let messages = payload["messages"] as? [[String: Any]] else { continue }
                for (index, message) in messages.enumerated() {
                    let id = message["id"] as? String ?? (payload["id"] as? String).map { "\($0):\(index)" }
                    if let id {
                        if receivedIDs.contains(id) { continue }
                        receivedIDs = Array((receivedIDs + [id]).suffix(256))
                    }
                    if let value = Self.decode(message) { onMessage?(value, (message["timestamp"] ?? payload["timestamp"]) as? Double) }
                }
            case 5, 6, 8, 9, 13, 17: throw YalovyBError.summerImaginationCanvas
            default: break
            }
        }
    }

    static func decode(_ message: [String: Any]) -> [String: Any]? {
        var value: Any = message["data"] ?? [:]
        for encoding in (message["encoding"] as? String ?? "").split(separator: "/").reversed() {
            if encoding == "base64", let string = value as? String, let data = Data(base64Encoded: string) {
                value = String(data: data, encoding: .utf8) ?? ""
            } else if encoding == "json" {
                guard let dictionary = GardenForaging.dictionary(value) else { return nil }
                value = dictionary
            } else if encoding != "utf-8" { return nil }
        }
        return GardenForaging.dictionary(value)
    }
}
