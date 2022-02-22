// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "perl-core",
  platforms: [
    .macOS(.v10_10),
    .iOS(.v9),
    .tvOS(.v9),
    .watchOS(.v7),
  ],
  products: [
    .library(name: "PerlCore", targets: ["PerlCore"]),
  ],
  targets: [
    .binaryTarget(name: "libperl", path: "libperl.xcframework"),
    .target(
      name: "CPerlCore",
      dependencies: ["libperl"],
      resources: [.copy("modules")],
      cSettings: [.unsafeFlags(["-w"])]
//      linkerSettings: [
////         .unsafeFlags(["-L/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE"]),
//        .unsafeFlags(["-L/tmp/crossperl/perl-5.30.3"]),
//        .linkedLibrary("perl")
//      ]
    ),
    .target(name: "PerlCore", dependencies: ["CPerlCore"]),
    .testTarget(name: "PerlCoreTests", dependencies: ["PerlCore"]),
  ]
)
