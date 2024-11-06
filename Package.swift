// swift-tools-version:5.6
import PackageDescription

let package = Package(
    // Set the name of the package
    name: "WizardHelper",
    // Set the minimum platform versions for iOS and macOS
    // This package requires at least iOS 15 and macOS 12
    platforms: [.iOS(.v15), .macOS(.v12)],
    // Define the products that this package provides
    products: [
        // Define a library product with the name "WizardHelper"
        .library(
            name: "WizardHelper",
            // Include the "WizardHelper" target in the library
            targets: ["WizardHelper"])
    ],
    // Define the dependencies that this package requires
    dependencies: [],
    // Define the "WizardHelper" target
    targets: [
           .target(
            name: "WizardHelper",
            // This target has no dependencies
         dependencies: []),
            .testTarget( // creates a new test target
                name: "WizardHelperTests",
                dependencies: ["WizardHelper"])
    ]
)
