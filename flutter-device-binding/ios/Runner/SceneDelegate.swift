import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  /// The Health-ID callback arrives as a universal link once the insurer is
  /// done. It is offered to the Health-ID channel first: that channel takes it
  /// only when it matches the redirect it is waiting for, so any other link
  /// falls through to Flutter untouched.
  override func scene(
    _ scene: UIScene,
    continue userActivity: NSUserActivity
  ) {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL,
       Channels.shared.healthId.handle(callback: url) {
      return
    }
    super.scene(scene, continue: userActivity)
  }
}
