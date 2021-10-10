// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "WizardHelper",
    platforms: [.iOS(.v13)],
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
