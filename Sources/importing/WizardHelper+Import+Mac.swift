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
    * - Fixme: ⚠️️ Add more documentation for the `NSOpenPanel` instance and its methods.
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
