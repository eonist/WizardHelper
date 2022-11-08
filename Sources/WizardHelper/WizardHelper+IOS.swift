#if os(iOS)
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
/**
 * Crossplatform-save-file-wizard for iOS and macOS
 * - Abstract let's you save file via save dialog with the same API for both iOS and Mac
 */
public final class WizardHelper {}

extension WizardHelper {
   /**
    * - Fixme: ⚠️️ the bellow requires access to a viewController, so probably move it to ViewController.swift and use event to propogte, or check if there is a method to get cur viewconteoller from the POV of view, or pov of current app state
    * - Parameters:
    *   - fromURL: the path to the source of the content to save
    *   - fileName: suggest fileName
    *   - view: the origin-view to launch from
    * ## Examples:
    * StorageHelper.promptSaveFile(fromURL: url, fileName: fileInfo.fileName, view: self)
    */
   public static func promptSaveFile(fromURL: URL, fileName: String, view: UIView) {
      let ac = UIActivityViewController(activityItems: [fromURL], applicationActivities: nil)
      ac.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
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
    * - Fixme: ⚠️️ Add the UTType code, it's iOS 14 only
    */
   public static func promptOpenFile(view: UIView) -> [URL] {
      let types: [String] = [kUTTypeJSON as String, kUTTypeText as String, kUTTypeZipArchive as String] // "public.json"
      let controller = OpenFileVC(documentTypes: types, in: .import) // choose your desired documents the user is allowed to select, choose your desired UIDocumentPickerMode
      controller.delegate = controller // let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)  //      let types = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
      // controller.modalPresentationStyle = .formSheet
      // controller.allowsMultipleSelection = false
      // controller.shouldShowFileExtensions = true
      guard let vc = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      vc.present(controller, animated: true)
      return controller.urls
   }
}
/**
 * Private helper
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
class OpenFileVC: UIDocumentPickerViewController, UIDocumentPickerDelegate {
   var urls: [URL] = []
   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
      self.urls = urls // do something with the selected documents
   }
   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
      self.urls = [url]  // do something with the selected document
   }
   func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      self.dismiss(animated: true, completion: nil)
   }
}
#endif
