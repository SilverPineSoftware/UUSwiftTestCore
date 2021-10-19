// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "UUSwiftTestCore",
	platforms: [
		.iOS(.v10),
		.macOS(.v10_15)
	],

	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "UUSwiftTestCore",
			targets: ["UUSwiftTestCore"]),
	],
    
    dependencies: [
        .package(
            url: "https://github.com/SilverPineSoftware/UUSwiftCore.git",
            from: "1.1.3"
        )
    ],
    
	targets: [
		.target(
			name: "UUSwiftTestCore",
			dependencies: ["UUSwiftCore"],
			path: "Source"),
        .testTarget(
            name: "UUSwiftTestCoreTests",
            dependencies: ["UUSwiftCore","UUSwiftTestCore"],
            path: "Test"),
	],
	swiftLanguageVersions: [
		.v4_2,
		.v5
	]
)
