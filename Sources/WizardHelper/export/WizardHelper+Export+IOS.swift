#if os(iOS)
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
/**
 * Cross-platform save file wizard for iOS and macOS.
 * This class provides a unified API for saving files via a save dialog on both iOS and macOS.
 * - Note: The export and import functionality should be moved into separate files.
 * - Note: A typealias for closures and better organization should be added, as well as support for custom file types.
 */
public final class WizardHelper {}

extension WizardHelper {
   /**
   * Presents a save dialog for a file located at a given URL using `UIActivityViewController`.
   * This function should be called from the main thread.
   * - Note: The export and import functionality should be moved into separate files.
   * - Note: A typealias for closures and better organization should be added, as well as support for custom file types.
   * - Parameters:
   *   - fromURL: The URL of the file to save.
   *   - view: The view to launch the save dialog from.
   *   - onComplete: A closure to execute when the save dialog is completed or cancelled.
   * - Important: This function requires access to a view controller, so it should be moved to `ViewController.swift` and used with an event to propagate, or a method to get the current view controller from the point of view of the view or current app state should be added.
   * - Fixme: ⚠️️ To add a suggested name for the file, `UIActivityItemSource` should be added. See https://stackoverflow.com/a/40330064/5389500 for more information.
   * - Fixme: ⚠️️ add support for success or failure in the onComplete
   * ## Examples:
   * StorageHelper.promptSaveFile(fromURL: url, view: self) {
   *     // Do additional cleanup, etc.
   * }
   */
   public static func promptSaveFile(fromURL: URL, view: UIView? = nil, onComplete: (() -> Void)?) {
      // Get the view controller to present the save dialog from
      guard let view = view ?? UIViewController.topMostController()?.view else { Swift.print("Err, ⚠️️ unable to get view"); return }
      // Create the activity view controller with the file URL
      let ac = UIActivityViewController(activityItems: [fromURL], applicationActivities: nil)
      // Exclude AirDrop and copy to pasteboard activities
      ac.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.copyToPasteboard]
      // Set the completion handler for the activity view controller
      ac.completionWithItemsHandler = { (_: UIActivity.ActivityType?, completed: Bool, _: [Any]?, error: Error?) in
//         Swift.print("👍 completionWithItemsHandler completed: \(completed) error: \(String(describing: error))")
         if let shareError = error {
            _ = shareError
            // If there was an error, print it and call the completion handler
//            print("save file - error while sharing: \(shareError.localizedDescription)")
            onComplete?()
            return
         } else {
            if completed {
               // If the save was completed, print a message and call the completion handler
//               print("save file - completed")
               onComplete?()
            } else {
               // If the save was cancelled, print a message and call the completion handler
//               print("save file - cancel")
               onComplete?()
            }
         }
      }
       // ⚠️️ We can't do the bellow because if user cancels then temp is removed, but the user is still in the VC and can go into save and then there is no file, which then just bounce the user back etc. so we have to do it in completeion or somewhere not in cancel. more testing needed etc
         // do { // ref: https://stackoverflow.com/a/54031361/5389500
         //    try FileManager.default.removeItem(at: fromURL)
         //    Swift.print("Temporary file was successfully deleted. \(fromURL.absoluteString)")
         // } catch {
         //    Swift.print("File " + fromURL.absoluteString + " can't be deleted.")
         // }

      // Get the view controller to present the activity view controller from
      guard let vc: UIViewController = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      // Set the source view for the popover presentation controller and present the activity view controller
      ac.popoverPresentationController?.sourceView = vc.view
      // Present the activity view controller to the user
      vc.present(ac, animated: true, completion: nil)
   }
}
#endif
