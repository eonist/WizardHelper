import SwiftUI
// import WizardHelper
/**
 * Open (Hybrid macOS / iOS)
 */
extension WizardHelper {
   // typealias OpenResult = Result<[URL], Error>
   /**
    * - Fixme: ⚠️️ consider using Result again, check if we can easily get error
    */
   public typealias OnOpenCompleted = (_ url: URL?, _ error: Error?) -> Void
   /**
    * - Note: MacOs supports only one file at the moment
    * - Fixme: ⚠️️ use result instead? I think e can get the caller code short etc
    * - Fixme: ⚠️️ Make an extension to wizardHelper that supports both os:
    * - Fixme: ⚠️️ and probably do the same for export, both should have onComplete etc
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
    * - Fixme: ⚠️️ add doc
    * fileName is the suggested filename for macOS
    * - Note: We provide the view here, because WizardHelper can't find the view with swiftUI etc
    */
   static func saveFile(fromURL: URL, fileName: String? = nil, onComplete: (()-> Void)?) {
      #if os(iOS)
      WizardHelper.promptSaveFile(fromURL: fromURL, view: rootController?.view, onComplete: onComplete)
      #elseif os(macOS)
      WizardHelper.promptSaveFile(fromURL: fromURL, fileName: fileName ?? fromURL.lastPathComponent) // this blocks cycle
      onComplete?() // this is called after the line above concludes, after the user clicks save or cancel etc
      #endif
   }
}
//Logger.error("\(Trace.trace()) - Error: \(error.localizedDescription)", tag: .file) // Logs the error with the trace and tag
//      Swift.print("result:  \(String(describing: result))")
//               handleImportRequest(result: .failure(error)) // Handles the import request with the error
//               return nil
//switch result {
//case .success(let urls):
//   Swift.print("urls: \(urls)")
//   // Do something with the selected URLs
//case .failure(let error):
//   Swift.print("error:  \(error)")
//   // Handle the error
//   }
//Logger.error("\(Trace.trace()) - Error: \(error.localizedDescription)", tag: .file) // Logs the error with the trace and tag

//         guard let firstURL: URL = urls.first else { // Represents the first URL
//            Logger.error("\(Trace.trace()) - Err ⚠️️ open file", tag: .file) // Logs the error with the trace and tag
//            handleImportRequest(result: .failure(NSError(domain: "No urls", code: 0))) // Handles the import request with the error
//            return // Returns if the first URL is nil
//         }


