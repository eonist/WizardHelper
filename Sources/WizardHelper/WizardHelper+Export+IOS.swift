#if os(iOS)
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
/**
 * Crossplatform-save-file-wizard for iOS and macOS
 * - Fixme: ⚠️️ 👉 move export and import into seperate files 👈
 * - Fixme: ⚠️️ Make typalias for closures and org better, also add support for custom filetypes etc
 * - Description: let's you save file via save dialog with the same API for both iOS and Mac
 */
public final class WizardHelper {}

extension WizardHelper {
   /**
    * Save a document located in a url. `UIActivityViewController will be opened
    * - Fixme: ⚠️️ The bellow requires access to a viewController, so probably move it to ViewController.swift and use event to propogte, or check if there is a method to get cur viewconteoller from the POV of view, or pov of current app state
    * - Fixme: ⚠️️ to add suggested name for file etc, might need to add UIActivityItemSource https://stackoverflow.com/a/40330064/5389500
    * - Important: Must be called from the main thread
    * - Parameters:
    *   - fromURL: The path to the source of the content to save
    *   - fileName: Suggest fileName
    *   - view: The origin-view to launch from
    *   - onComplete: on complete, do additional cleanup etc
    * ## Examples:
    * StorageHelper.promptSaveFile(fromURL: url, fileName: fileInfo.fileName, view: self)
    */
   public static func promptSaveFile(fromURL: URL/*, fileName: String*/, view: UIView? = nil, onComplete: (() -> Void)?) {
      guard let view = view ?? UIViewController.topMostController()?.view else { Swift.print("Err, ⚠️️ unable to get view"); return }
//      Swift.print("fileName:  \(fileName)")
//      Swift.print("fromURL:  \(fromURL)")
//      let dataToSave: [Any] = ["Save file: \(fileName)", fromURL] // [fromURL]
      let ac = UIActivityViewController(activityItems: [fromURL]/*dataToSave*/, applicationActivities: nil) // Activitis is items like share to twitter, copyToPasteboard, post to vimeo etc
      ac.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.copyToPasteboard] // We dont want airdrop
      ac.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
         Swift.print("👍 completionWithItemsHandler completed: \(completed) error: \(String(describing: error))")
         // ⚠️️ Note that completionWithItemsHandler may be called several times and you can end up deleting the file too early.
         if let shareError = error {
            print("save file - error while sharing: \(shareError.localizedDescription)")
            onComplete?()
            return
         } else {
            if completed {
               print("save file - completed")
               onComplete?()
            } else {
               print("save file - cancel")
               onComplete?()
            }
         }
         // ⚠️️ we can't do the bellow because if user cancels then temp is removed, but the user is still in the VC and can go into save and then there is no file, which then just bounce the user back etc. so we have to do it in completeion or somewhere not in cancel. more testing needed etc
//         do { // ref: https://stackoverflow.com/a/54031361/5389500
//            try FileManager.default.removeItem(at: fromURL)
//            Swift.print("Temporary file was successfully deleted. \(fromURL.absoluteString)")
//         } catch {
//            Swift.print("File " + fromURL.absoluteString + " can't be deleted.")
//         }
      }
      guard let vc: UIViewController = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      ac.popoverPresentationController?.sourceView = vc.view
      vc.present(ac, animated: true, completion: nil)
   }
   
}
#endif
