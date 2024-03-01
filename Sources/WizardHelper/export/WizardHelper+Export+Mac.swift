#if os(macOS)
/**
 * Import Cocoa for macOS-specific user interface elements.
 * Import AppKit for macOS-specific user interface elements.
 * Import UniformTypeIdentifiers for UTType instances.
 */
import Cocoa
import AppKit
import UniformTypeIdentifiers
/**
 * Util
 */
extension WizardHelper {
   /**
    * Presents a save dialog for a file located at a given URL using `NSSavePanel`.
    * This function should be called from the main thread.
    * - Note: Add support for more file types and custom folders.
    * - Parameters:
    *   - fromURL: The URL of the file to save.
    *   - fileName: The suggested destination file name.
    * - Important: This function requires access to a view controller, so it should be moved to `ViewController.swift` and used with an event to propagate, or a method to get the current view controller from the point of view of the view or current app state should be added.
    * - Fixme: ⚠️️ To add support for custom folders, `NSOpenPanel` should be used instead. See https://stackoverflow.com/a/24623638/5389500 for more information.
    * ## Examples:
    * StorageHelper.promptSaveFile(fromURL: url, fileName: "test.json")
    */
   public static func promptSaveFile(fromURL: URL, fileName: String) {
      // Initialize the save panel with the allowed file types and the suggested file name
      // fix: move the text, types outside of this method
      let types: [String] = ["txt", "pdf", "mp3", "json", "data"]
      let dialog: NSSavePanel = .initialize(types, "Save file…", true)
      // Show the extension in the file name
      dialog.isExtensionHidden = false
      // Set the default directory to the desktop
      // fix: add custom dir url outside this method
      dialog.directoryURL = URL(fileURLWithPath: String(NSString(string: "~/Desktop/").expandingTildeInPath))
      // Set the suggested file name
      dialog.nameFieldStringValue = fileName
      // Show the save dialog and get the response
      let respons: NSApplication.ModalResponse = dialog.runModal()
      // If a path was chosen, move the file to the chosen path
      if let toURL: URL = dialog.url, respons == NSApplication.ModalResponse.OK {
         move(from: fromURL, to: toURL)
      }
   }
}
/**
 * Util
 */
extension WizardHelper {
   /**
    * Moves a file from one URL to another.
    * - Remark: Paths must be created with: `URL(fileURLWithPath: directory)` and then .path
    * - Remark: The toURL needs to have the name of the file as well.
    * - Parameters:
    *   - from: The URL of the file to move.
    *   - to: The URL to move the file to.
    * - Returns: `true` if the file was moved successfully, `false` otherwise.
    * - Fixme: ⚠️️ Additional catch clauses should be added for more specific error handling:
    *   - `NSCocoaError.FileNoSuchFileError`: no such file exists
    *   - `NSCocoaError.FileReadUnsupportedSchemeError`: unsupported scheme (should be 'file://')
    */
   @discardableResult fileprivate static func move(from: URL, to: URL) -> Bool {
      // Get the default file manager
      let fileManager: FileManager = .default
      do {
         if fileManager.fileExists(atPath: to.path) { // remove first if needed
            try fileManager.removeItem(at: to)
         }
         try fileManager.moveItem(at: from, to: to) // move the file
      } catch let error as NSError {
         Swift.print("WizardHelper - move from: \(from) to: \(to) - Error: \(error.localizedDescription)") // log the error
         return false
      }
      return true
   }
}
/**
 * An extension to `NSSavePanel` that provides additional functionality for exporting data on macOS.
 */
extension NSSavePanel {
   /**
       * Creates an `NSSavePanel` instance with the specified parameters.
       * - Parameters:
       *   - allowedFileTypes: An array of file types that the user is allowed to save.
       *   - title: The title of the save panel.
       *   - canCreateDirectories: A Boolean value that indicates whether the user is allowed to create directories.
       * - Returns: An `NSSavePanel` instance.
       * - Note: The `initialize` method is used instead of `init`, as `init` requires much more code to get working.
       */
      static func initialize(_ allowedFileTypes: [String] = ["xml"], _ title: String = "Save As", _ canCreateDirectories: Bool = true) -> NSSavePanel {
         let panel: NSSavePanel = .init() // Create a new NSSavePanel instance
         panel.canCreateDirectories = canCreateDirectories // Set whether the user is allowed to create directories
         panel.allowedContentTypes = allowedFileTypes.compactMap { UTType(filenameExtension: $0) } // Set the allowed content types based on the file extensions
         // panel.allowedFileTypes =  // ["css","html","pdf","png"]
         panel.title = title // Set the title of the save panel
         return panel // Return the save panel instance
      }
}
#endif
