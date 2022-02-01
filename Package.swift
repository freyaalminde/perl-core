// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "perl-core",
  platforms: [
    .macOS(.v10_10),
//    .iOS(.v9),
//    .tvOS(.v9),
  ],
  products: [
    .library(name: "PerlCore", targets: ["PerlCore"]),
  ],
  targets: [
    .systemLibrary(name: "CPerlCore"),
    .target(
      name: "PerlCore",
      dependencies: ["CPerlCore"],
//      resources: [.process("Documentation.docc")],
      exclude: ["Documentation.docc"],
      linkerSettings: [
        .unsafeFlags(["-L/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE"]),
        .linkedLibrary("perl")
      ]
    ),
    .testTarget(name: "PerlCoreTests", dependencies: ["PerlCore"]),
  ]
)
