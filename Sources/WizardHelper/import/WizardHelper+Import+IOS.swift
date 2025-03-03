#if os(iOS)
/**
 * Import UIKit for iOS-specific user interface elements.
 * Import MobileCoreServices for UTType constants.
 * Import UniformTypeIdentifiers for UTType instances.
 */
import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

extension WizardHelper {
   /**
    * A type alias for the result of an open operation, which is either an array of URLs or an error.
    */
   public typealias OnOpenResult = Result<[URL], Error>
   /**
    * A type alias for the completion handler of an open operation, which takes an `OnOpenResult` as its parameter.
    * - Parameter result: The result of the open operation.
    */
   public typealias OnOpenComplete = (_ result: OnOpenResult) -> Void
   /**
    * The default completion handler for an open operation, which simply logs the result.
    * - Parameter result: The result of the open operation.
    */
   public static var defaultOnOpenComplete: OnOpenComplete {
      { result in
         Swift.print("on default complete result: \(result)")
      }
   }
   /**
    * Presents an `OpenFileVC` instance on the first available `UIViewController` from the responder chain.
    * - Remark: All files: "public.data"
    * - Note: This method uses `OpenFileVC` instead of `UIDocumentPickerViewController` to support iOS 13 and earlier.
    * - Note: Ref: https://stackoverflow.com/a/48851508/5389500
    * - Note: iOS 14: https://stackoverflow.com/a/42370660/5389500
    * - Note: Apple docs: https://developer.apple.com/documentation/uikit/uidocumentpickerviewcontroller and https://developer.apple.com/documentation/uikit/view_controllers/adding_a_document_browser_to_your_app/presenting_selected_documents
    * - Note: Some claim it still possible with a counter and notification etc: https://stackoverflow.com/a/48659562/5389500
    * - Note: Seems like we cant make this sync like macOS ref: https://stackoverflow.com/a/40521834/5389500
    * - Fixme: ⚠️️ 👉 Add the UTType code, it's iOS 14 only 👈
    * - Fixme: ⚠️️ get rid of the fatal error
    * - Fixme: ⚠️️ add example
    * - Fixme: ⚠️️ we will probably make this non static and use singlton to access it in the future?
    * - Parameters:
    *   - view: The view to start the responder chain from.
    *   - types: An array of UTType instances that represent the allowed file types.
    *   - complete: A closure that is called when the user has selected a file.
    */
   public static func promptOpenFile(
      view: UIView? = nil,
      types: [UTType] = defaultTypes,
      complete: @escaping OnOpenComplete
   ) {
      guard let view = view ?? UIViewController.topMostController()?.view else { Swift.print("Err, ⚠️️ unable to get view"); return }
      // Swift.print("promptOpenFile")
      let controller = OpenFileVC(forOpeningContentTypes: types) // Create a new instance of OpenFileVC for opening content types
      // let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
      // let types = UTType.types(tag: "json", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
      controller.delegate = controller // Set the delegate of the OpenFileVC instance to itself
      controller.onComplete = complete // Set the onComplete closure of the OpenFileVC instance to the provided closure
      // controller.modalPresentationStyle = .overFullScreen
      // controller.modalPresentationStyle = .formSheet
      // controller.allowsMultipleSelection = false
      // controller.shouldShowFileExtensions = true
      guard let vc = UIView.firstAvailableUIViewController(fromResponder: view) else { fatalError("ViewController not reachable") } // Get the first available UIViewController from the responder chain
      vc.present(controller, animated: true) { /*Swift.print("WizardHelper - prompt completed presenting")*/ } // Present the OpenFileVC instance on the UIViewController instance
   }
}
/**
 * A view controller for opening a file in the iOS document picker.
 */
private class OpenFileVC: UIDocumentPickerViewController, UIDocumentPickerDelegate {
   /**
    * The completion handler for an open operation, which is called when the user has selected a file or cancelled the operation.
    * - Note: The `urls` parameter is optional to account for when the user cancels the operation.
    */
   var onComplete: WizardHelper.OnOpenComplete = WizardHelper.defaultOnOpenComplete // (_ urls: [URL]) -> Void = { _ in Swift.print("on default complete")}
   // var urls: [URL] = []
   /**
    * The delegate method that is called when the user has selected one or more documents in the `UIDocumentPickerViewController`.
    * - Parameters:
    *   - controller: The `UIDocumentPickerViewController` instance that called the delegate method.
    *   - urls: An array of `URL` instances that represent the selected documents.
    * - Note: This method is not currently being used, as the `OpenFileVC` class is being used instead of `UIDocumentPickerViewController`.
    */
   func documentPicker(
      _ controller: UIDocumentPickerViewController,
      didPickDocumentsAt urls: [URL]
   ) {
      // self.urls = urls // do something with the selected documents
      // Swift.print("OpenFileVC - didPickDocumentsAt")
      // The OpenFileVC class is being used instead of UIDocumentPickerViewController
      onComplete(.success(urls)) // Call the onComplete closure with the array of URLs as a success result
      // onComplete(.failure(error)) // Call the onComplete closure with an error result, if necessary
   }
   /**
    * The delegate method that is called when the user has selected a document in the `UIDocumentPickerViewController`.
    * - Parameters:
    *   - controller: The `UIDocumentPickerViewController` instance that called the delegate method.
    *   - url: The `URL` instance that represents the selected document.
    * - Note: This method is not currently being used, as the `OpenFileVC` class is being used instead of `UIDocumentPickerViewController`.
    */
   func documentPicker(
      _ controller: UIDocumentPickerViewController,
      didPickDocumentAt url: URL
   ) {
      // self.urls = [url]  // do something with the selected document
      // Swift.print("OpenFileVC - didPickDocumentAt")
      onComplete(.success([url])) // Call the onComplete closure with the selected URL as a success result
   }
   /**
    * The delegate method that is called when the user cancels the `UIDocumentPickerViewController`.
    * - Parameter controller: The `UIDocumentPickerViewController` instance that called the delegate method.
    * - Note: This method dismisses the `UIDocumentPickerViewController` and calls the `onComplete` closure with a failure result that indicates the user cancelled the operation.
    * - Fixme: ⚠️️ Create a user canceled error case so we can switch on it
    */
   func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
      // Swift.print("OpenFileVC - documentPickerWasCancelled")
      self.dismiss(animated: true, completion: nil)
      onComplete(.failure(NSError(domain: "User canceled", code: 0))) // Call the onComplete closure with a failure result that indicates the user cancelled the operation
   }
}
/**
 * Helper - consts
 */
extension WizardHelper {
   /**
    * The default array of `UTType` instances that represent the allowed file types for an import operation.
    * - Note: This array includes `.json`, `.text`, `.zip`, and `.data` by default.
    * - Fixme: ⚠️️ Move to a constant extension.
    */
   public static let defaultTypes: [UTType] = {
      [
         .json, // JSON data ("public.json")
         .text, // Plain text
         .zip, // ZIP archive
         .data // Raw data
      ] // Array of UTType instances that represent the allowed file types for an import operation
   }()
}
#endif
