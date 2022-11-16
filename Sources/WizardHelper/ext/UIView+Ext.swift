#if os(iOS)
import UIKit
/**
 * Private helper
 */
extension UIView {
   /**
    * Used for prompting a save / open dialog
    * Reference: https://stackoverflow.com/a/49100190/5389500
    * - Parameter responder: - Fixme: ⚠️️
    * - Returns: - Fixme: ⚠️️
    */
   internal static func firstAvailableUIViewController(fromResponder responder: UIResponder) -> UIViewController? {
      func traverseResponderChainForUIViewController(responder: UIResponder) -> UIViewController? {
         if let nextResponder = responder.next {
            if let nextResp = nextResponder as? UIViewController {
               return nextResp
            } else {
               return traverseResponderChainForUIViewController(responder: nextResponder)
            }
         }
         return nil
      }
      return traverseResponderChainForUIViewController(responder: responder)
   }
}
#endif
