#if os(iOS)
import UIKit
/**
 * Crossplatform-save-file-wizard for iOS and macOS
 * - Abstract let's you save file via save dialog with the same API for both iOS and Mac
 * - Fixme: ⚠️️ Possibly move to own repo 👈
 */
final class StorageHelper {}

extension StorageHelper {
   /**
    * - Fixme: ⚠️️ the bellow requires access to a viewController, so probably move it to ViewController.swift and use event to propogte, or check if there is a method to get cur viewconteoller from the POV of view, or pov of current app state
    * - Parameters:
    *   - fromURL: the path to the source of the content to save
    *   - fileName: suggest fileName
    *   - view: the origin-view to launch from
    * ## Examples:
    * StorageHelper.promptSaveFile(fromURL: url, fileName: fileInfo.fileName, view: self)
    */
   static func promptSaveFile(fromURL: URL, fileName: String, view: UIView) {
      let ac = UIActivityViewController(activityItems: [fromURL], applicationActivities: nil)
      ac.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
      guard let vc = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      ac.popoverPresentationController?.sourceView = vc.view // might
      vc.present(ac, animated: true, completion: nil)
   }
}
/**
 * Private heper
 */
extension UIView {
   /**
    * Used for prompting a save / open dialog
    * Reference: https://stackoverflow.com/a/49100190/5389500
    */
   fileprivate static func firstAvailableUIViewController(fromResponder responder: UIResponder) -> UIViewController? {
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
