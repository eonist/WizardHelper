#if os(macOS)
import Cocoa
final public class StorageHelper {}
/**
 * Util
 */
extension StorageHelper {
   /**
    * Save
    * - Parameters:
    *   - fileName: The suggested destination file name
    *   - fromURL: the origin URL of the file to save
    */
   public static func promptSaveFile(fromURL: URL, fileName: String) {
      let dialog: NSSavePanel = .initialize(["txt", "pdf", "mp3"], "Save file…", true) // Prompt the file viewer
      dialog.directoryURL = URL(fileURLWithPath: String(NSString(string: "~/Desktop/").expandingTildeInPath))
      dialog.nameFieldStringValue = fileName // "test.json etc"
      let respons = dialog.runModal()
      if let toURL: URL = dialog.url, respons == NSApplication.ModalResponse.OK { // Make sure that a path was chosen
         Swift.print("write to url.path.tildePath: \(toURL.path)")
         move(from: fromURL, to: toURL)
      }
   }
}
extension StorageHelper {
   /**
    * - Parameters:
    *   - fromURL: "/path/to/old"
    *   - toURL: "/path/to/new"
    * - Fixme: ⚠️️ additional catch clauses:
    * catch NSCocoaError.FileNoSuchFileError { print("Error: no such file exists" )
    * catch NSCocoaError.FileReadUnsupportedSchemeError { print("Error: unsupported scheme (should be 'file://')") }
    * - Important: ⚠️️ paths must be created with: URL(fileURLWithPath: directory) and then .path
    * - Important: ⚠️️ the toURL needs to have the name of the file as well.
    */
   @discardableResult fileprivate static func move(from: URL, to: URL) -> Bool {
      let fileManager = FileManager.default
      do {
         try fileManager.moveItem(at: from, to: to)
      } catch let error as NSError {
         Swift.print("Error: \(error.domain)")
         return false
      }
      return true
   }
}
extension NSSavePanel {
   /**
    * Creates An NSSavePanel instance
    * - Note: the initialize word is used instead of init, as init requires much more code to get working
    * ## Examples:
    * see git project
    */
   static func initialize(_ allowedFileTypes: [String] = ["xml"], _ title: String = "Save As", _ canCreateDirectories: Bool = true) -> NSSavePanel {
      let panel = NSSavePanel()
      panel.canCreateDirectories = canCreateDirectories
      panel.allowedFileTypes = allowedFileTypes // ["css","html","pdf","png"]
      panel.title = title
      return panel
   }
}
#endif
