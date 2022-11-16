#if os(iOS)
import UIKit
/**
 * VC ext
 */
extension UIViewController {
   /**
    * Returns the top most viewController (searching from root)
    * ## Examples:
    * UIViewCOntroller.topMostController()?.view.backgroundColor = .green
    */
   internal static func topMostController() -> UIViewController? {
      var topController: UIViewController? = rootVC /*was .keyWindow, but that is deprec<ated*/
      while let presentedVC = topController?.presentedViewController {
         topController = presentedVC
      }
      return topController
   }
   /**
    * Get access to root view controller from anywhere
    */
   private static var rootVC: UIViewController? {
      guard let window = UIApplication.shared.delegate?.window, let win = window else { return nil }
      return win.rootViewController?.presentedViewController ?? win.rootViewController
   }
}
#endif
