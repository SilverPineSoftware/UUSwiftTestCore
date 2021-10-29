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
    
	targets: [
		.target(
			name: "UUSwiftTestCore",
			path: "Source"),
        .testTarget(
            name: "UUSwiftTestCoreTests",
            dependencies: ["UUSwiftTestCore"],
            path: "Test"),
	],
	swiftLanguageVersions: [
		.v4_2,
		.v5
	]
)
