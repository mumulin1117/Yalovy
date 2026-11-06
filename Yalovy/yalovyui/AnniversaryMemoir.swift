import Foundation

private struct YalovyBRequestFieldMapping {
    let deviceID: String
    let appVersion: String
    let pushToken: String
    let acknowledgment: String
    let transactionID: String
    let receipt: String
    let orderID: String
}

private struct YalovyBResponseFieldMapping {
    let pageURL: String
    let credential: String
    let channel: String
    let socketURL: String
    let credentialToken: String
}

private struct YalovyBIncomingMessageMapping {
    let data: String
    let purchaseSelector: String
    let closeSelector: String
    let openSelector: String
    let forwardSelector: String
    let productID: String
    let orderID: String
    let externalURL: String
    let directCloseHandler: String
}

private struct YalovyBOutgoingMessageMapping {
    let event: String
    let orderID: String
    let productID: String
    let success: String
    let status: String
    let message: String
    let reason: String
    let openEvent: String
    let openState: String
    let source: String
    let nativeSource: String
}

private struct YalovyBEventNames {
    let purchase: String
    let close: String
    let open: String
    let purchaseResult: String
    let forward: String
}

private struct YalovyBEnvironmentConfiguration {
    let baseURL: URL
    let openPath: String
    let receiptVerificationPath: String
    let requestFields: YalovyBRequestFieldMapping
    let responseFields: YalovyBResponseFieldMapping
    let incomingMessages: YalovyBIncomingMessageMapping
    let outgoingMessages: YalovyBOutgoingMessageMapping
    let events: YalovyBEventNames
}

/// Yalovy B 接入配置。当前使用用户选定的参考项目测试协议。
/// 正式环境须另行提供 Yalovy 的域名和完整协议映射；不复用参考 App 的正式服务。
enum AnniversaryMemoir {
    enum Environment {
        // 当前协议模式为 test，独立于 Xcode Debug / Release 构建类型。
        static let isDebug = true
        static var apiBaseURL: URL { AnniversaryMemoir.current.baseURL }
    }

    // 用户选定的参考测试环境：请求、返回、消息和支付回调使用同一套字段。
    private static let test = YalovyBEnvironmentConfiguration(
        baseURL: URL(string: "https://api.zwwtesttop.top")!,
        openPath: "/app/open",
        receiptVerificationPath: "/app/p",
        requestFields: YalovyBRequestFieldMapping(
            deviceID: "deviceNo",
            appVersion: "appVersion",
            pushToken: "pushToken",
            acknowledgment: "roomPushMsgType",
            transactionID: "transactionId",
            receipt: "payload",
            orderID: "callbackResult"
        ),
        responseFields: YalovyBResponseFieldMapping(
            pageURL: "h5Url",
            credential: "tokenResult",
            channel: "roomId",
            socketURL: "webSocketUrl",
            credentialToken: "token"
        ),
        incomingMessages: YalovyBIncomingMessageMapping(
            data: "data",
            purchaseSelector: "event",
            closeSelector: "event",
            openSelector: "event",
            forwardSelector: "event",
            productID: "batchNo",
            orderID: "orderCode",
            externalURL: "openUrl",
            directCloseHandler: "Close"
        ),
        outgoingMessages: YalovyBOutgoingMessageMapping(
            event: "event",
            orderID: "callbackResult",
            productID: "productId",
            success: "success",
            status: "status",
            message: "message",
            reason: "reason",
            openEvent: "nativeOpenState",
            openState: "state",
            source: "source",
            nativeSource: "native"
        ),
        events: YalovyBEventNames(
            purchase: "pay",
            close: "logout",
            open: "openBrowser",
            purchaseResult: "payResult",
            forward: "linkSuccessMessage"
        )
    )
    // 用户选定的参考测试环境：请求、返回、消息和支付回调使用同一套字段。
    private static let normal = YalovyBEnvironmentConfiguration(
        baseURL: URL(string: "https://api.zwwtesttop.top")!,
        openPath: "/app/open",
        receiptVerificationPath: "/app/p",
        requestFields: YalovyBRequestFieldMapping(
            deviceID: "deviceNo",
            appVersion: "appVersion",
            pushToken: "pushToken",
            acknowledgment: "roomPushMsgType",
            transactionID: "transactionId",
            receipt: "payload",
            orderID: "callbackResult"
        ),
        responseFields: YalovyBResponseFieldMapping(
            pageURL: "h5Url",
            credential: "tokenResult",
            channel: "roomId",
            socketURL: "webSocketUrl",
            credentialToken: "token"
        ),
        incomingMessages: YalovyBIncomingMessageMapping(
            data: "data",
            purchaseSelector: "event",
            closeSelector: "event",
            openSelector: "event",
            forwardSelector: "event",
            productID: "batchNo",
            orderID: "orderCode",
            externalURL: "openUrl",
            directCloseHandler: "Close"
        ),
        outgoingMessages: YalovyBOutgoingMessageMapping(
            event: "event",
            orderID: "callbackResult",
            productID: "productId",
            success: "success",
            status: "status",
            message: "message",
            reason: "reason",
            openEvent: "nativeOpenState",
            openState: "state",
            source: "source",
            nativeSource: "native"
        ),
        events: YalovyBEventNames(
            purchase: "pay",
            close: "logout",
            open: "openBrowser",
            purchaseResult: "payResult",
            forward: "linkSuccessMessage"
        )
    )
    private static var current: YalovyBEnvironmentConfiguration {Environment.isDebug ? test : normal }

    // 以下兼容入口供现有网络、WebView、支付模块复用，所有协议字符串均读取当前整套配置。
    enum API {
        static var bootstrapPath: String { current.openPath }
        static var confirmationPath: String { current.receiptVerificationPath }
        static let method = "POST"
        static let timeout: TimeInterval = 20
        static let fallbackAppVersion = "1.0"
        static let bootstrapAttempts = 2
        enum Request {
            private static var fields: YalovyBRequestFieldMapping { current.requestFields }
            static var deviceID: String { fields.deviceID }
            static var appVersion: String { fields.appVersion }
            static var pushToken: String { fields.pushToken }
            static var acknowledgment: String { fields.acknowledgment }
            static let acknowledgmentValue = 2
            static var transactionID: String { fields.transactionID }
            static var receipt: String { fields.receipt }
            static var orderID: String { fields.orderID }
        }
        enum Response {
            private static var fields: YalovyBResponseFieldMapping { current.responseFields }
            static var pageURL: String { fields.pageURL }
            static var channel: String { fields.channel }
            static var socketURL: String { fields.socketURL }
            static var credential: String { fields.credential }
            static var credentialToken: String { fields.credentialToken }
        }
        // 【协议联动】两套验单接口目前均以空 JSON 对象 {} 表示确认成功，不把非空响应当作成功。
        static func acceptsConfirmation(_ payload: [String: Any]) -> Bool { payload.isEmpty }
    }

    enum Bridge {
        private static var fields: YalovyBIncomingMessageMapping { current.incomingMessages }
        static var data: String { fields.data }
        static var purchaseSelector: String { fields.purchaseSelector }
        static var purchaseAction: String { current.events.purchase }
        static var closeSelector: String { fields.closeSelector }
        static var closeAction: String { current.events.close }
        static var openSelector: String { fields.openSelector }
        static var openAction: String { current.events.open }
        static var forwardSelector: String { fields.forwardSelector }
        static var forwardAction: String { current.events.forward }
        static var directCloseHandler: String { fields.directCloseHandler }
        static var productID: String { fields.productID }
        static var orderID: String { fields.orderID }
        static var externalURL: String { fields.externalURL }
    }

    enum Callback {
        private static var fields: YalovyBOutgoingMessageMapping { current.outgoingMessages }
        static var event: String { fields.event }
        static var purchaseEvent: String { current.events.purchaseResult }
        static var orderID: String { fields.orderID }
        static var productID: String { fields.productID }
        static var success: String { fields.success }
        static var status: String { fields.status }
        static var message: String { fields.message }
        static var reason: String { fields.reason }
        static var openEvent: String { fields.openEvent }
        static var openState: String { fields.openState }
        static var source: String { fields.source }
        static var nativeSource: String { fields.nativeSource }
        // verified/pending/failed/cancelled 等支付状态值继续使用原有状态机约定。
    }

    enum Diagnostics {
        static let startupLogsEnabled = Environment.isDebug
        static func startup(_ metric: String, value: Any? = nil) {
            guard startupLogsEnabled else { return }
            print("[Yalovy B startup] \(metric)\(value.map { "=\($0)" } ?? "")")
        }
        static func elapsed(_ metric: String, since start: TimeInterval) {
            guard startupLogsEnabled else { return }
            startup(metric, value: (ProcessInfo.processInfo.systemUptime - start) * 1000)
        }
    }

    // 以下为两套环境共用的原生能力及项目资源，按模板保留在协议映射块之外。
    enum Network {
        static let pageSchemes = ["https", "http"]
        static let socketSchemes = ["wss", "ws"]
        static let externalSchemes = ["https", "http", "itms-apps"]
        // Ably 固定协议；域名白名单不能改为任意域名放行，更换服务商时还需适配消息协议。
        static let socketHosts = ["realtime.ably.io", "realtime.ably.com"]
        static let socketCredentialQueryNames = ["accessToken", "key"]
        static let socketTokenQueryName = "accessToken"
    }

    enum Storage {
        // 【历史数据】正式订单继续读取旧键；测试订单单独保存，绝不向测试接口提交正式补单。
        static let legacySharedStateKey = "yalovy.b.purchases"
        static let productionPurchaseRecordsKey = legacySharedStateKey
        static let testPurchaseRecordsKey = "yalovy.b.purchases.debug"
        static var purchaseRecordsKey: String { Environment.isDebug ? testPurchaseRecordsKey : productionPurchaseRecordsKey }
        // 旧版入口状态与订单共用一个键，登录 / 退出时可能覆盖订单；现在独立保存两套入口状态。
        static var stateKey: String { Environment.isDebug ? "yalovy.b.purchases.entry.debug" : "yalovy.b.purchases.entry" }
        static func entryState(in defaults: UserDefaults = .standard) -> Bool {
            if let value = defaults.object(forKey: stateKey) as? Bool { return value }
            // 只兼容旧布尔状态；旧键里的订单 Data 保持原样，不删除、不覆盖。
            let value = defaults.object(forKey: legacySharedStateKey) as? Bool ?? true
            defaults.set(value, forKey: stateKey)
            return value
        }
        static let pushTokenKey = "yalovy.b.pushToken"
        // 【新项目必核对】【历史数据】设备身份跨环境保持一致，优先使用实际 Bundle ID。
        static let fallbackBundleID = "com.petsshareing.yalovy"
        static let legacyFallbackBundleID = "com.petsshareing.yalovy"
        static let legacyServiceSuffix = ".yalovy"
        static let deviceAccountSuffix = ".yalovy.device"
        static let legacyDeviceAccountSuffix = ".yalovy.device.id"
        // 设备标识写入当前 App 的 Keychain，避免使用参考项目固定设备号。
        static let deviceIDSuffix = "-yalovy"
    }

    enum Presentation {
        // 【新项目必核对】本地 Assets.xcassets 必须包含以下资源。
        static let loadingBackground = "fallbackBackground"
        static let fallbackBackground = "LaunchImage"
        static let purchaseAccessibilityID = "yalovy.b.purchaseResult"
        // 【协议联动】与当前工程及 2170e6e 一致的 B 页安全区 CSS 变量名。
        static let safeAreaTopCSS = "--cozyBackgroundDollnoro"
        static let safeAreaBottomCSS = "--winterBackgroundDollpavo"
    }
}

import UIKit
import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func configureYalovyBServices() {
        SeasonalKeepsake.crystalDreamCanvas.gentleMood()
        UNUserNotificationCenter.current().delegate = WellnessPlanner.velvetWonderTrail
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        WellnessPlanner.velvetWonderTrail.velvetThoughtTrail(velvetFeelingTrail: deviceToken)
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        WellnessPlanner.velvetWonderTrail.velvetExpressionTrail()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.noData)
    }
}
