[![Tests](https://github.com/sentryco/WizardHelper/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/WizardHelper/actions/workflows/Tests.yml)
[![codebeat badge](https://codebeat.co/badges/9f71bf1b-cdba-4fb5-97f7-fa603fde7555)](https://codebeat.co/projects/github-com-eonist-wizardhelper-master)

# WizardHelper

> Open / save prompts for macOS and iOS

### Examples:
```swift
WizardHelper.promptSaveFile(fromURL: url, fileName: fileInfo.fileName, view: self)
WizardHelper.promptOpenFile(view: self)
```

### Gotcha (iOS): 
- Might require setting infoplist = "Supports opening documents in place" : yes
- Might require setting infoplist = "Application supports iTunes file sharing" : yes
- Might require setting infoplist = "Supports Document Browser" : yes
- See this link for more infoplist gotchas: https://stackoverflow.com/questions/70370908/showing-ios-app-files-within-in-the-files-app
- Remember to set app-sandbox - user selected files - read / write to true

### Todo:
- Add github action
- Add tests
