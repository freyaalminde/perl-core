# PerlCore

Evaluate Perl code from within an app, and support Perl scripting of your app.


## Installation

```swift
.package(url: "https://github.com/freyaariel/perl-core.git", branch: "main")
```

```swift
import PerlCore
```


## Documentation

Online documentation is available at [freyaariel.github.io/documentation/perlcore](https://freyaariel.github.io/documentation/perlcore/).


## Overview

The PerlCore framework provides the ability to evaluate Perl code from within Swift-based apps. You can also use PerlCore to insert custom objects into the Perl environment.

```swift
PerlInterpreter.initialize()
let interpreter = PerlInterpreter()
interpreter.`$`("prefix", true)!.asString = "Just "
let script = "$prefix . reverse q(rekcaH lreP rehtonA)"
let result = interpreter.evaluateScript(script)
assert(result.asString == "Just Another Perl Hacker")
```


## Roadmap

Support for iOS, watchOS, and tvOS is planned and will be added when a working cross-compilation method for Perl is found.

Additionally, the API will be cleaned up slightly more before first release, by adding subscripts to `PerlInterpreter`, automatically running `initialize()`, reworking the `add` parameter, etc.


## Acknowledgements

Based on [Dan Kogai’s blog post about Perl in Swift](https://qiita.com/dankogai/items/d63dfda25088165deed5).

