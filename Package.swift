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
        .unsafeFlags([
          //"-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE",
          //"-I/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE",
          "-L/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE",
//          "-arch x86_64",
//          "-arch i386",
//          "-g",
//          "-pipe",
//          "-fno-common",
//          "-DPERL_DARWIN",
//          "-fno-strict-aliasing",
//          "-fstack-protector",
        ]),
        .linkedLibrary("perl")
      ]
    ),
    .target(name: "PerlCore", dependencies: ["CPerlCore"]),
    .testTarget(name: "PerlCoreTests", dependencies: ["PerlCore"]),
  ]
)
