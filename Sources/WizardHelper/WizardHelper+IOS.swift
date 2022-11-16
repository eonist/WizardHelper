#if os(iOS)
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
/**
 * Crossplatform-save-file-wizard for iOS and macOS
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
         Swift.print("👍 completionWithItemsHandler")
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
         do { // ref: https://stackoverflow.com/a/54031361/5389500
            try FileManager.default.removeItem(at: fromURL)
            Swift.print("Temporary file was successfully deleted. \(fromURL.absoluteString)")
         } catch {
            Swift.print("File " + fromURL.absoluteString + " can't be deleted.")
         }
      }
      guard let vc: UIViewController = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      ac.popoverPresentationController?.sourceView = vc.view
      vc.present(ac, animated: true, completion: nil)
   }
   /**
    * Open file
    * - Note: ref: https://stackoverflow.com/a/48851508/5389500
    * - Note: iOS 14: https://stackoverflow.com/a/42370660/5389500
    * - Note: apple docs: https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller and https://developer.apple.com/documentation/uikit/view_controllers/adding_a_document_browser_to_your_app/presenting_selected_documents
    * - Note: all files: "public.data"
    * - Remark: Seems like we cant make this sync like macOS ref: https://stackoverflow.com/a/40521834/5389500
    * - Note: Some claim it still possible with a counter and notification etc: https://stackoverflow.com/a/48659562/5389500
    * - Fixme: ⚠️️ Add the UTType code, it's iOS 14 only
    * - Parameters:
    *   - view: - Fixme: ⚠️️
    *   - types: - Fixme: ⚠️️
    *   - complete: - Fixme: ⚠️️
    */
   public static func promptOpenFile(view: UIView? = nil, types: [String] = defaultTypes, complete: @escaping (_ urls: [URL]) -> Void) {
      guard let view = view ?? UIViewController.topMostController()?.view else { Swift.print("Err, ⚠️️ unable to get view"); return }
//      Swift.print("promptOpenFile")
      let controller = OpenFileVC(documentTypes: types, in: .import) // choose your desired documents the user is allowed to select, choose your desired UIDocumentPickerMode
      controller.delegate = controller // let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)  //      let types = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
      controller.onComplete = complete
      // controller.modalPresentationStyle = .formSheet
      // controller.allowsMultipleSelection = false
      // controller.shouldShowFileExtensions = true
      // - Fixme: ⚠️️ Probably use the topMostVC call and drop view param etc
      guard let vc = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      vc.present(controller, animated: true) { Swift.print("prompt completed presenting") }
   }
}
/**
 * Helper
 */
extension WizardHelper {
   /**
    * - Fixme: ⚠️️ move to const ext
    */
   public static let defaultTypes: [String] = {
      let jsonStr = kUTTypeJSON as String
      let textStr = kUTTypeText as String
      let zipStr = kUTTypeZipArchive as String
      return [jsonStr, textStr, zipStr] // "public.json"
   }()
}
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
/**
 * VC ext
 */
extension UIViewController {
   /**
    * Returns the top most viewController (searching from root)
    * ## Examples:
    * UIViewCOntroller.topMostController()?.view.backgroundColor = .green
    */
   fileprivate static func topMostController() -> UIViewController? {
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
/**
 * - Fixme: ⚠️️ add doc
 */
class OpenFileVC: UIDocumentPickerViewController, UIDocumentPickerDelegate {
   // - Fixme: ⚠️️ make urls optional to account for cancel
   var onComplete: (_ urls: [URL]) -> Void = { _ in Swift.print("on default complete")}
//   var urls: [URL] = []
   /**
    * - Fixme: ⚠️️ doc
    * - Parameters:
    *   - controller: - Fixme: ⚠️️
    *   - urls: - Fixme: ⚠️️
    */
   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
//      self.urls = urls // do something with the selected documents
      Swift.print("didPickDocumentsAt")
      onComplete(urls)
   }
   /**
    * - Fixme: ⚠️️ doc
    * - Parameters:
    *   - controller: - Fixme: ⚠️️
    *   - url: - Fixme: ⚠️️
    */
   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//      self.urls = [url]  // do something with the selected document
      Swift.print("didPickDocumentAt")
      onComplete([url])
   }
   /**
    * - Fixme: ⚠️️
    * - Parameter controller: - Fixme: ⚠️️
    */
   func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      Swift.print("documentPickerWasCancelled")
      self.dismiss(animated: true, completion: nil)
      onComplete([])
   }
}
#endif
