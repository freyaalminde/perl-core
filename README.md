# PerlCore

Evaluate Perl code from within an app, and support Perl scripting of your app.


## Installation

```swift
.package(url: "https://github.com/freyaalminde/perl-core.git", from: "0.1.0")
```

```swift
import PerlCore
```


## Documentation

Online documentation is available at [freyaalminde.github.io/documentation/perlcore](https://freyaalminde.github.io/documentation/perlcore/).


## Overview

The PerlCore framework provides the ability to evaluate Perl code from within Swift-based apps. You can also use PerlCore to insert custom objects into the Perl environment.

```swift
let interpreter = PerlInterpreter.shared
interpreter["prefix"]!.asString = "Just "
let script = "$prefix . reverse q(rekcaH lreP rehtonA)"
let result = interpreter.evaluateScript(script)
assert(result.asString == "Just Another Perl Hacker")
```

PerlCore 0.1.0 includes Perl 5.30.3.


## Roadmap

The ability to create multiple interpreters may be added, and `PerlInterpreter.shared` removed. (This requires building Perl with `-Dusemultiplicity`.)

To better support the App Store guidelines, all modules should ideally be embedded in the binary. In this case, to avoid bloat, a script for customizing the Perl distribution may be added. 

A complete build script for building `libperl.xcframework` for every platform is currently under development.


## Acknowledgements

Based on [Dan Kogai’s blog post about Perl in Swift](https://qiita.com/dankogai/items/d63dfda25088165deed5).

Uses [`perl-cross` by Alex Suykov](https://github.com/arsv/perl-cross) for cross-compiling Perl.

