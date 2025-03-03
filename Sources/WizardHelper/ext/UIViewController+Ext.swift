#if os(iOS)
import UIKit
/**
 * VC ext
 */
extension UIViewController {
   /**
    * Returns the top-most `UIViewController` in the view controller hierarchy.
    * This function searches from the key window's root view controller and returns the top-most presented view controller.
    * - Returns: The top-most `UIViewController` in the view controller hierarchy.
    * - Fixme: ⚠️️ doc each line
    *  - Fixme: ⚠️️ ask copilot to improve it?
    */
   internal static func topMostController() -> UIViewController? {
      guard let keyWindow = UIApplication.shared.connectedScenes
         .compactMap({ $0 as? UIWindowScene })
         .flatMap({ $0.windows })
         .first(where: { $0.isKeyWindow }) else {
         return nil
      }
      var topController: UIViewController? = keyWindow.rootViewController
      while let presentedVC = topController?.presentedViewController {
         topController = presentedVC
      }
      return topController
   }
}
/**
 * A computed property that returns the root view controller of the key window.
 * - Note: Supports multiple scenes and better integration with SwiftUI.
 * - Fixme: ⚠️️ doc each line
 * - Fixme: ⚠️️ ask copilot to improve it?
 */
internal var rootController: UIViewController? {
   UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first(where: { $0.isKeyWindow })?.rootViewController
}
#endif


