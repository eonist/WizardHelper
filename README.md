[![Tests](https://github.com/sentryco/WizardHelper/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/WizardHelper/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/9f71bf1b-cdba-4fb5-97f7-fa603fde7555)](https://codebeat.co/projects/github-com-eonist-wizardhelper-master)

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

- You might need to set `Supports opening documents in place`, `Application supports iTunes file sharing`, and `Supports Document Browser` to `YES` in your app's Info.plist file.
- You might need to set `app-sandbox - user selected files - read / write` to `true`.
- See [this link](https://stackoverflow.com/questions/70370908/showing-ios-app-files-within-in-the-files-app) for more Info.plist gotchas.


### Todo:
- Add github action
- Add tests (UITests) 👈
- Add SwiftUI support 👈

## License
WizardHelper is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
