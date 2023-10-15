#if os(iOS)
import UIKit

extension UIView {
   /**
    * Used for finding the first available UIViewController in the responder chain.
    * This is useful for presenting a save/open dialog from any UIResponder.
    * Reference: https://stackoverflow.com/a/49100190/5389500
    * - Parameter responder: The UIResponder to start the search from.
    * - Returns: The first available UIViewController found in the responder chain.
    */
   internal static func firstAvailableUIViewController(fromResponder responder: UIResponder) -> UIViewController? {
      func traverseResponderChainForUIViewController(responder: UIResponder) -> UIViewController? {
         // Check if there is a next responder in the chain
         if let nextResponder = responder.next {
            // Check if the next responder is a UIViewController
            if let nextResp = nextResponder as? UIViewController {
               // If it is, return it
               return nextResp
            } else {
               // If it's not, recursively call this function with the next responder
               return traverseResponderChainForUIViewController(responder: nextResponder)
            }
         }
         // If there are no more responders in the chain, return nil
         return nil
      }
      // Call the function with the initial responder to start the search
      return traverseResponderChainForUIViewController(responder: responder)
   }
}
#endif
