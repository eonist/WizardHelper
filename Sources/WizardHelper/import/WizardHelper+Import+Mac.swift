#if os(macOS)
import Cocoa
import AppKit
import UniformTypeIdentifiers

public final class WizardHelper {}

extension WizardHelper {
   /**
    * Prompts the user to select a file to open using an `NSOpenPanel`.
    * - Returns: The path to the selected file, or `nil` if the user cancelled the operation.
    * - Note: This method is only available on macOS.
    * - Description: This method uses an `NSOpenPanel` to present a file selection dialog to the user. The user can navigate through the file system and select a file. If a file is selected, the method returns the file path as a string. If the user cancels the operation, the method returns `nil`.
    * - Important: Ensure that the application has the necessary permissions to access the file system, as this method interacts with the user's file system.
    * - Remark: You have an extension for `NSSavePanel` in `WinExtension`: See `NSSavePanel.initialize...`.
    * ## Examples:
    * if let filePath = WizardHelper.promptOpenFile() {
    *     print(FileParser.content(filePath: filePath))
    * }
    */
   public static func promptOpenFile() -> String? {
      let myFileDialog: NSOpenPanel = .init() // Create a new NSOpenPanel instance
      myFileDialog.runModal() // Open the modal panel
      let thePath: String? = myFileDialog.url?.path // Get the path to the selected file
      return thePath // Return the path, or nil if the user cancelled the operation
   }
}
#endif
