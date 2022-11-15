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
    * - Fixme: ⚠️️ The bellow requires access to a viewController, so probably move it to ViewController.swift and use event to propogte, or check if there is a method to get cur viewconteoller from the POV of view, or pov of current app state
    * - Parameters:
    *   - fromURL: The path to the source of the content to save
    *   - fileName: Suggest fileName
    *   - view: The origin-view to launch from
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
    * - Remark: Seems like we cant make this sync like macOS ref: https://stackoverflow.com/a/40521834/5389500
    * - Note: Some claim it still possible with a counter and notification etc: https://stackoverflow.com/a/48659562/5389500
    * - Fixme: ⚠️️ Add the UTType code, it's iOS 14 only
    * - Parameters:
    *   - view: - Fixme: ⚠️️
    *   - types: - Fixme: ⚠️️
    *   - complete: - Fixme: ⚠️️
    */
   public static func promptOpenFile(view: UIView, types: [String] = defaultTypes, complete: @escaping (_ urls: [URL]) -> Void) {
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
