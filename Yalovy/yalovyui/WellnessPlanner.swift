import UIKit
import UserNotifications

final class WellnessPlanner: NSObject, UNUserNotificationCenterDelegate {
    static let velvetWonderTrail = WellnessPlanner()
    func velvetThoughtTrail(velvetFeelingTrail: Data) {
        let token = velvetFeelingTrail.map { String(format: "%02x", $0) }.joined()
        let previous = UserDefaults.standard.string(forKey: GardenForaging.pushKey)
        UserDefaults.standard.set(token, forKey: GardenForaging.pushKey)
        if token != previous { Task { _ = try? await PuppyPlayfulness.lucentCuriosityTrail.lucentDreamTrail() } }
    }
    func velvetExpressionTrail() {
        Task { await SeasonalKeepsake.crystalDreamCanvas.luminousPath() }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                               withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound, .badge])
    }
}
