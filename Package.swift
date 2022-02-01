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
      exclude: ["Documentation.docc"],
      linkerSettings: [
        .unsafeFlags([
          // "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE",
          // "-I/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE",
          "-L/System/Library/Perl/5.30/darwin-thread-multi-2level/CORE",
          "-arch x86_64",
          "-arch i386",
          "-g",
          "-pipe",
          "-fno-common",
          "-DPERL_DARWIN",
          "-fno-strict-aliasing",
          "-fstack-protector",
        ]),
        .linkedLibrary("perl")
      ]
    ),
    .testTarget(name: "PerlCoreTests", dependencies: ["PerlCore"]),
  ]
)
