#if os(macOS)
import Cocoa
import AppKit
import UniformTypeIdentifiers
/**
 * Util
 */
extension WizardHelper {
   /**
    * Save
    * - Fixme: ⚠️ Add support for more types
    * - Fixme: ⚠️️ Add support for custom folder etc
    * - Parameters:
    *   - fileName: The suggested destination file name
    *   - fromURL: the origin URL of the file to save
    */
   public static func promptSaveFile(fromURL: URL, fileName: String) {
      let dialog: NSSavePanel = .initialize(["txt", "pdf", "mp3", "json", "data"], "Save file…", true) // Prompt the file viewer
      dialog.isExtensionHidden = false // ⚠️️ Must be set or extension is stripped
      dialog.directoryURL = URL(fileURLWithPath: String(NSString(string: "~/Desktop/").expandingTildeInPath))
      //      Swift.print("fileName:  \(fileName)")
      dialog.nameFieldStringValue = fileName // "test.json etc"
      let respons = dialog.runModal()
      if let toURL: URL = dialog.url, respons == NSApplication.ModalResponse.OK { // Make sure that a path was chosen
         // Swift.print("write to url.path.tildePath: \(toURL.path)")
         move(from: fromURL, to: toURL)
      }
   }
}
/**
 * Util
 */
extension WizardHelper {
   /**
    * - Remark: Paths must be created with: `URL(fileURLWithPath: directory)` and then .path
    * - Remark: The toURL needs to have the name of the file as well.
    * - Parameters:
    *   - fromURL: "/path/to/old"
    *   - toURL: "/path/to/new"
    * - Fixme: ⚠️️ additional catch clauses:
    * catch NSCocoaError.FileNoSuchFileError { print("Error: no such file exists" )
    * catch NSCocoaError.FileReadUnsupportedSchemeError { print("Error: unsupported scheme (should be 'file://')") }
    */
   @discardableResult fileprivate static func move(from: URL, to: URL) -> Bool {
      let fileManager = FileManager.default
      do {
         if fileManager.fileExists(atPath: to.path) { // remove first if needed
            try fileManager.removeItem(at: to)
         }
         try fileManager.moveItem(at: from, to: to)
      } catch let error as NSError {
         Swift.print("WizardHelper - move from: \(from) to: \(to) - Error: \(error.localizedDescription)")
         return false
      }
      return true
   }
}
/**
 * Init
 */
extension NSSavePanel {
   /**
    * Creates An `NSSavePanel` instance
    * - Note: the initialize word is used instead of init, as init requires much more code to get working
    */
   static func initialize(_ allowedFileTypes: [String] = ["xml"], _ title: String = "Save As", _ canCreateDirectories: Bool = true) -> NSSavePanel {
      let panel = NSSavePanel()
      panel.canCreateDirectories = canCreateDirectories
      panel.allowedContentTypes = allowedFileTypes.compactMap { UTType(filenameExtension: $0) }
      //      panel.allowedFileTypes =  // ["css","html","pdf","png"]
      panel.title = title
      return panel
   }
}
#endif
