# PerlCore

Evaluate Perl programs from within an app, and support Perl scripting of your app.

## Overview

The goal of the PerlCore framework is to provide the ability to evaluate Perl programs from within Swift-based apps. You should also be able to use PerlCore to insert custom objects into the Perl environment.

Ideally, it should run on all Apple platforms, making executing Perl code as easy as:

```swift
let interpreter = PerlInterpreter()
interpreter.evaluateScript("…")
```

## Acknowledgements

Based on [swift-perl](https://github.com/dankogai/swift-perl) by Dan Kogai.
