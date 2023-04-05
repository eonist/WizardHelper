#if os(macOS)
import Cocoa
import AppKit
import UniformTypeIdentifiers

public final class WizardHelper {}

extension WizardHelper {
   /**
    * Open
    * - Remark: you have an extension for NSSavePanel in WinExtension: See NSSavePanel.initialize....
    * ## Examples:
    * if let filePath = WizardHelper.promptOpenFile() { print(FileParser.content(filePath: filePath)) }
    */
   public static func promptOpenFile() -> String? {
      let myFileDialog: NSOpenPanel = .init() // Open modal panel
      myFileDialog.runModal()
      let thePath = myFileDialog.url?.path // Get the path to the file chosen in the NSOpenPanel
      return thePath // Make sure that a path was chosen
   }
}
#endif
