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
let interpreter = PerlInterpreter.shared
interpreter["prefix"]!.asString = "Just "
let script = "$prefix . reverse q(rekcaH lreP rehtonA)"
let result = interpreter.evaluateScript(script)
assert(result.asString == "Just Another Perl Hacker")
```


## Roadmap

The ability to create multiple interpreters may be added, and `PerlInterpreter.shared` removed. This requires building Perl with `-Dusemultiplicity`.

Unsafe flags should be removed so the package can be depended on by version tag.

To better support the App Store guidelines, all modules should ideally be embedded in the binary.

A full build script for building Perl for every platform should be added.

_TODO: Make it clear which versions of Perl is included._


## Acknowledgements

Based on [Dan Kogai’s blog post about Perl in Swift](https://qiita.com/dankogai/items/d63dfda25088165deed5).

Uses [`perl-cross` by Alex Suykov](https://github.com/arsv/perl-cross) for cross-compiling Perl.

