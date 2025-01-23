[![Tests](https://github.com/sentryco/WizardHelper/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/WizardHelper/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/9f71bf1b-cdba-4fb5-97f7-fa603fde7555)](https://codebeat.co/projects/github-com-eonist-wizardhelper-master)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
![Platforms](https://img.shields.io/badge/platforms-iOS%2017%20|%20macOS%2014-blue.svg)

# WizardHelper

> Open / save prompts for macOS and iOS

WizardHelper is a Swift library that provides open and save prompts for macOS and iOS. It uses `NSOpenPanel` and `NSSavePanel` on macOS, and `UIDocumentPickerViewController` on iOS.

# Index
- [Installation](#installation)
- [Usage](#usage)
- [Gotchas](#gotchas)
    - [iOS](#ios)
- [Todo](#todo)
- [License](#license)


## Installation

You can install WizardHelper using Swift Package Manager. Add the following line to your `Package.swift` file:

```swift
.package(url: "https://github.com/eonist/WizardHelper.git", .branch: "master")
```

### Examples:
```swift
// macOS: Prompt the user to save a file
WizardHelper.promptSaveFile(fromURL: url, fileName: fileInfo.fileName, view: self)

// macOS: Prompt the user to open a file
WizardHelper.promptOpenFile(view: self)

// iOS: Prompt the user to open a file
WizardHelper.promptOpenFile(from: self) { result in
    switch result {
    case .success(let urls):
        // Do something with the selected URLs
    case .failure(let error):
        // Handle the error
    }
}

// iOS: Prompt the user to open a file with error handling
WizardHelper.promptOpenFile { result in
    switch result {
    case .success(let urls):
        // Do something with the selected URLs
        print("Selected files: \(urls)")
    case .failure(let error):
        // Handle the error
        print("Error: \(error.localizedDescription)")
    }
}
```

### Example (hybrid iOS / macOS)
```swift
// open
 WizardHelper.openFile { (url, error) in
     if let url = url {
         print("Opened file at \(url)")
     } else if let error = error {
         print("Failed to open file: \(error)")
     }
 }
 // save
 let url = URL(string: "https://example.com/myfile.txt")! 
 WizardHelper.saveFile(fromURL: url, fileName: "SavedFile.txt") { print("File saved") }
```

### Gotcha  iOS

To use WizardHelper on iOS, you need to update your app's `Info.plist` file with the following:

- **Supports opening documents in place**: Set to `YES`
- **Application supports iTunes file sharing**: Set to `YES`
- **Supports Document Browser**: Set to `YES`
- **App Sandbox** (if applicable): Enable `User Selected Files - Read/Write`

**Example `Info.plist` entries:**

```xml
<key>LSSupportsOpeningDocumentsInPlace</key>
<true/>
<key>UIFileSharingEnabled</key>
<true/>
<key>UISupportsDocumentBrowser</key>
<true/>
```

For more details, refer to [this StackOverflow answer](https://stackoverflow.com/questions/70370908/showing-ios-app-files-within-in-the-files-app).

### Todo:
- Add github action
- Add error handling when moving files
- Add tests (UITests) 👈
- Add SwiftUI support 👈
- Upgrade to swift 6.0 (This might be a bit tricky but doable)
- Use Result type for better error handling in asynchronous methods:

```swift
public typealias SaveFileResult = Result<Void, Error>
public typealias SaveFileCompletion = (SaveFileResult) -> Void

public static func saveFile(fromURL: URL, fileName: String? = nil, onComplete: @escaping SaveFileCompletion) {
    #if os(iOS)
    WizardHelper.promptSaveFile(fromURL: fromURL, view: rootController?.view) { result in
        onComplete(result)
    }
    #elseif os(macOS)
    do {
        try WizardHelper.promptSaveFile(fromURL: fromURL, fileName: fileName ?? fromURL.lastPathComponent)
        onComplete(.success(()))
    } catch {
        onComplete(.failure(error))
    }
    #endif
}
```

- Avoid force unwrapping and provide better error messages:
In WizardHelper+Import+IOS.swift, replace fatalError with proper error handling:
```swift
public static func promptOpenFile(view: UIView? = nil, types: [UTType] = defaultTypes, complete: @escaping OnOpenComplete) {
    guard let view = view ?? UIViewController.topMostController()?.view else {
        complete(.failure(NSError(domain: "ViewControllerNotFound", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to find a view controller to present from."])))
        return
    }
    // Rest of the method...
}
```
- Enhance the promptSaveFile method on iOS to allow setting a default file name:
Since UIActivityViewController doesn't support specifying a default file name, consider using UIDocumentPickerViewController for exporting files:

```swift
public static func promptSaveFile(fromURL: URL, suggestedFileName: String? = nil, view: UIView? = nil, onComplete: (() -> Void)?) {
    guard let view = view ?? UIViewController.topMostController()?.view else {
        onComplete?()
        return
    }
    
    let documentPicker = UIDocumentPickerViewController(forExporting: [fromURL], asCopy: true)
    documentPicker.delegate = ExportDelegate(onComplete: onComplete)
    documentPicker.directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    if let fileName = suggestedFileName {
        documentPicker.directoryURL = documentPicker.directoryURL?.appendingPathComponent(fileName)
    }
    
    UIViewController.topMostController()?.present(documentPicker, animated: true, completion: nil)
}

private class ExportDelegate: NSObject, UIDocumentPickerDelegate {
    let onComplete: (() -> Void)?
    
    init(onComplete: (() -> Void)?) {
        self.onComplete = onComplete
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        onComplete?()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        onComplete?()
    }
}
```


   Implement SwiftUI wrappers for your open and save dialogs to make the library more compatible with SwiftUI projects.

   ```swift:Sources/WizardHelper/SwiftUI/WizardHelper+SwiftUI.swift
   import SwiftUI
   import UniformTypeIdentifiers

   @available(iOS 13.0, macOS 10.15, *)
   public struct FileImporter: UIViewControllerRepresentable {
       @Binding var isPresented: Bool
       @Binding var importedURL: URL?
       var allowedContentTypes: [UTType] = [.data]

       public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
           let picker = UIDocumentPickerViewController(forOpeningContentTypes: allowedContentTypes)
           picker.delegate = context.coordinator
           return picker
       }

       public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
           uiViewController.allowsMultipleSelection = false
       }

       public func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       public class Coordinator: NSObject, UIDocumentPickerDelegate {
           var parent: FileImporter

           init(_ parent: FileImporter) {
               self.parent = parent
           }

           public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
               parent.importedURL = urls.first
               parent.isPresented = false
           }

           public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
               parent.isPresented = false
           }
       }
   }

   @available(iOS 13.0, macOS 10.15, *)
   public struct FileExporter: UIViewControllerRepresentable {
       @Binding var isPresented: Bool
       var document: URL

       public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
           let picker = UIDocumentPickerViewController(forExporting: [document], asCopy: true)
           picker.delegate = context.coordinator
           return picker
       }

       public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

       public func makeCoordinator() -> Coordinator {
           Coordinator(self)
       }

       public class Coordinator: NSObject, UIDocumentPickerDelegate {
           var parent: FileExporter

           init(_ parent: FileExporter) {
               self.parent = parent
           }

           public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
               parent.isPresented = false
           }
       }
   }
   ```

   **Usage Example:**

   ```swift
   import SwiftUI

   struct ContentView: View {
       @State private var isImporterPresented = false
       @State private var isExporterPresented = false
       @State private var importedURL: URL?

       var body: some View {
           VStack {
               Button("Import File") {
                   isImporterPresented = true
               }
               .fileImporter(isPresented: $isImporterPresented, allowedContentTypes: [.text]) { result in
                   switch result {
                   case .success(let url):
                       importedURL = url
                   case .failure(let error):
                       print("Import error: \(error.localizedDescription)")
                   }
               }

               Button("Export File") {
                   isExporterPresented = true
               }
               .fileExporter(isPresented: $isExporterPresented, document: URL(fileURLWithPath: "path/to/document.txt"), contentType: .plainText) { result in
                   switch result {
                   case .success:
                       print("Export successful")
                   case .failure(let error):
                       print("Export error: \(error.localizedDescription)")
                   }
               }
           }
       }
   }
   ```


   Implement unit tests to ensure your library functions correctly and to prevent regressions.

   ```swift:Tests/WizardHelperTests/WizardHelperUnitTests.swift
   import XCTest
   @testable import WizardHelper

   final class WizardHelperUnitTests: XCTestCase {
       func testOpenFile_macOS() throws {
           #if os(macOS)
           let expectation = self.expectation(description: "File open dialog should be presented")
           WizardHelper.openFile { url, error in
               XCTAssertNil(error)
               XCTAssertNotNil(url)
               expectation.fulfill()
           }
           waitForExpectations(timeout: 5, handler: nil)
           #endif
       }

       func testSaveFile_macOS() throws {
           #if os(macOS)
           let expectation = self.expectation(description: "File save dialog should be presented")
           let url = URL(fileURLWithPath: "/path/to/dummy.txt")
           WizardHelper.saveFile(fromURL: url, fileName: "Test.txt") {
               expectation.fulfill()
           }
           waitForExpectations(timeout: 5, handler: nil)
           #endif
       }
   }
   ```