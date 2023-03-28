// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "WizardHelper",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "WizardHelper",
            targets: ["WizardHelper"])
    ],
    dependencies: [
    ],
    targets: [
       .target(
            name: "WizardHelper",
            dependencies: [])
    ]
)
