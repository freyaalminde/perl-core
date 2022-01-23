// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "perl-core",
  platforms: [
    .macOS(.v10_10),
//    .iOS(.v8),
//    .tvOS(.v9),
  ],
  products: [
    .library(
      name: "PerlCore",
      targets: ["PerlCore"]
    ),
  ],
  targets: [
    .target(
      name: "PerlCore",
    ),
    .testTarget(
      name: "PerlCoreTests",
      dependencies: ["PerlCore"]
    ),
  ]
)
