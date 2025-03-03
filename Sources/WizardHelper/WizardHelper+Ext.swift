import SwiftUI
// import WizardHelper
/**
 * Open (Hybrid macOS / iOS)
 * - Description: One api -> Works in 2 OSes
 */
extension WizardHelper {
   // typealias OpenResult = Result<[URL], Error>
   /**
    * - Fixme: ⚠️️ consider using Result again, check if we can easily get error
    */
   public typealias OnOpenCompleted = (_ url: URL?, _ error: Error?) -> Void
   /**
    * Opens a file and calls the completion handler with the URL of the opened file or an error.
    * - Parameter complete: A closure that is called when the file is opened or an error occurs. The closure takes two arguments: an optional URL and an optional Error. If the file is opened successfully, the URL is the URL of the file and the Error is nil. If an error occurs, the URL is nil and the Error is the error that occurred.
    * - Note: On macOS, if the user cancels the file open dialog, the Error is an NSError with the domain "User canceled" and the code 0.
    * - Note: MacOs supports only one file at the moment
    * - Fixme: ⚠️️ use result instead? I think e can get the caller code short etc
    * - Fixme: ⚠️️ Make an extension to wizardHelper that supports both os:
    * - Fixme: ⚠️️ and probably do the same for export, both should have onComplete etc
    * - Fixme: ⚠️️ ask copilot to improve this code
    * - Fixme: ⚠️️ use Result?
    */
   public static func openFile(complete: @escaping OnOpenCompleted) { // - Fixme: ⚠️️ this should probably be optional
      #if os(iOS)
      WizardHelper.promptOpenFile(view: rootController?.view, complete: { result in
         do {
            let urls: [URL] = try result.get() // Gets the result
            complete(urls.first, nil)
         } catch {
            complete(nil, error)
         }
      })
      #elseif os(macOS)
      let result: String? = WizardHelper.promptOpenFile()
      if let result = result {
         let url = URL(fileURLWithPath: result)
         complete(url, nil)
      } else {
         complete(nil, NSError.init(domain: "User canceled", code: 0))
      }
      #endif
   }

}
/**
 * Save file (Hybrid macOS / iOS)
 */
extension WizardHelper {
   /**
    * Saves a file from a specified URL to a location chosen by the user.
    * - Parameters:
    *   - fromURL: The URL of the file to save.
    *   - fileName: The default name for the saved file. If this parameter is nil, the last path component of fromURL is used.
    *   - onComplete: A closure that is called when the file is saved.
    * fileName is the suggested filename for macOS
    * - Note: We provide the view here, because WizardHelper can't find the view with swiftUI etc
    * - Fixme: ⚠️️ ask copilot to improve this code
    * - Fixme: ⚠️️ use Result?
    */
   public static func saveFile(
      fromURL: URL,
      fileName: String? = nil,
      // - Fixme: ⚠️️ Use typealias?
      onComplete: (() -> Void)?
   ) {
      #if os(iOS)
      WizardHelper.promptSaveFile(fromURL: fromURL, view: rootController?.view, onComplete: onComplete)
      #elseif os(macOS)
      WizardHelper.promptSaveFile(fromURL: fromURL, fileName: fileName ?? fromURL.lastPathComponent) // this blocks cycle
      onComplete?() // this is called after the line above concludes, after the user clicks save or cancel etc
      #endif
   }
}

// Logger.error("\(Trace.trace()) - Error: \(error.localizedDescription)", tag: .file) // Logs the error with the trace and tag
//      Swift.print("result:  \(String(describing: result))")
//               handleImportRequest(result: .failure(error)) // Handles the import request with the error
//               return nil
// switch result {
// case .success(let urls):
//   Swift.print("urls: \(urls)")
//   // Do something with the selected URLs
// case .failure(let error):
//   Swift.print("error:  \(error)")
//   // Handle the error
//   }
// Logger.error("\(Trace.trace()) - Error: \(error.localizedDescription)", tag: .file) // Logs the error with the trace and tag

//         guard let firstURL: URL = urls.first else { // Represents the first URL
//            Logger.error("\(Trace.trace()) - Err ⚠️️ open file", tag: .file) // Logs the error with the trace and tag
//            handleImportRequest(result: .failure(NSError(domain: "No urls", code: 0))) // Handles the import request with the error
//            return // Returns if the first URL is nil
//         }
