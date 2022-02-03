// swift-tools-version:5.5
import PackageDescription

let package = Package(
  name: "perl-core",
  platforms: [
    // TODO: actually test on macOS <12
    .macOS(.v10_10),
    // TODO: add support for oter OSes
    //.iOS(.v9),
    //.tvOS(.v9),
    //.watchOS(.v7),
  ],
  products: [
    .library(name: "PerlCore", targets: ["PerlCore"]),
  ],
  targets: [
    .target(
      name: "CPerlCore",
      cSettings: [
        .unsafeFlags(["-w"]),
      ],
      linkerSettings: [
        .unsafeFlags(["-L/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE"]),
        .linkedLibrary("perl")
      ]
    ),
    .target(name: "PerlCore", dependencies: ["CPerlCore"]),
    .testTarget(name: "PerlCoreTests", dependencies: ["PerlCore"]),
  ]
)
