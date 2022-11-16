#if os(iOS)
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

extension WizardHelper {
   /**
    * Open file
    * - Note: ref: https://stackoverflow.com/a/48851508/5389500
    * - Note: iOS 14: https://stackoverflow.com/a/42370660/5389500
    * - Note: apple docs: https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller and https://developer.apple.com/documentation/uikit/view_controllers/adding_a_document_browser_to_your_app/presenting_selected_documents
    * - Note: all files: "public.data"
    * - Remark: Seems like we cant make this sync like macOS ref: https://stackoverflow.com/a/40521834/5389500
    * - Note: Some claim it still possible with a counter and notification etc: https://stackoverflow.com/a/48659562/5389500
    * - Fixme: ⚠️️ 👉 Add the UTType code, it's iOS 14 only 👈
    * - Parameters:
    *   - view: - Fixme: ⚠️️
    *   - types: - Fixme: ⚠️️
    *   - complete: - Fixme: ⚠️️
    */
   public static func promptOpenFile(view: UIView? = nil, types: [UTType] = defaultTypes, complete: @escaping (_ urls: [URL]) -> Void) {
      guard let view = view ?? UIViewController.topMostController()?.view else { Swift.print("Err, ⚠️️ unable to get view"); return }
      //      Swift.print("promptOpenFile")
      let controller = OpenFileVC.init(forOpeningContentTypes: types)//.init(documentTypes: types, in: .import) // choose your desired documents the user is allowed to select, choose your desired UIDocumentPickerMode
      controller.delegate = controller // let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)  //      let types = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
      //      controller.directoryURL?.startAccessingSecurityScopedResource()
      controller.onComplete = complete
      //      controller.modalPresentationStyle = .overFullScreen
      // controller.modalPresentationStyle = .formSheet
      // controller.allowsMultipleSelection = false
      // controller.shouldShowFileExtensions = true
      // - Fixme: ⚠️️ Probably use the topMostVC call and drop view param etc
      guard let vc = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") }
      vc.present(controller, animated: true) { Swift.print("WizardHelper - prompt completed presenting") }
   }
}
/**
 * - Fixme: ⚠️️ add doc
 */
private class OpenFileVC: UIDocumentPickerViewController, UIDocumentPickerDelegate {
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
      // self.urls = urls // do something with the selected documents
      Swift.print("OpenFileVC - didPickDocumentsAt")
      onComplete(urls)
   }
   /**
    * - Fixme: ⚠️️ doc
    * - Parameters:
    *   - controller: - Fixme: ⚠️️
    *   - url: - Fixme: ⚠️️
    */
   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
      // self.urls = [url]  // do something with the selected document
      Swift.print("OpenFileVC - didPickDocumentAt")
      onComplete([url])
   }
   /**
    * - Fixme: ⚠️️
    * - Parameter controller: - Fixme: ⚠️️
    */
   func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      Swift.print("OpenFileVC - documentPickerWasCancelled")
      self.dismiss(animated: true, completion: nil)
      onComplete([])
   }
}
/**
 * Helper - consts
 */
extension WizardHelper {
   /**
    * - Fixme: ⚠️️ move to const ext
    */
   public static let defaultTypes: [UTType] = {
      [UTType.json, UTType.text, UTType.zip] // "public.json"
   }()
}
#endif
