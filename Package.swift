// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FHKConfig",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FHKConfig",
            targets: ["FHKConfig"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "12.6.0")),
        
        .package(url: "https://github.com/leonodev/fintechKids-modulo-utils-ios.git",
            .upToNextMajor(from: "1.0.2")),
        
        .package(url: "https://github.com/leonodev/fintechKids-modulo-designsystem-ios.git",
            .upToNextMajor(from: "1.0.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FHKConfig",
            dependencies: [
                // Modules Firebase
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                
                // Modules Utils
                .product(name: "FHKUtils", package: "fintechKids-modulo-utils-ios"),
                .product(name: "FHKDesignSystem", package: "fintechKids-modulo-designsystem-ios")
            ]
        ),
        .testTarget(
            name: "FHKConfigTests",
            dependencies: ["FHKConfig"]
        ),
    ]
)
