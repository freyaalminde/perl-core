# ``PerlCore/PerlInterpreter``

### Example Usage

```swift
let interpreter = PerlInterpreter.shared
interpreter["prefix"]!.asString = "Just "
let script = "$prefix . reverse q(rekcaH lreP rehtonA)"
let result = interpreter.evaluateScript(script)
assert(result.asString == "Just Another Perl Hacker")
```

## Topics

### Accessing the Shared Perl Interpreter

- ``PerlInterpreter/shared``

### Evaluating Scripts

- ``PerlInterpreter/evaluateScript(_:)``
- ``PerlInterpreter/preamble``

### Working with Perl Global State

- ``PerlInterpreter/evaluationSucceeded``
- ``PerlInterpreter/exception``

### Accessing Values in Perl Global State

- ``PerlInterpreter/subscript(_:_:)``
- ``PerlInterpreter/subscript(array:_:)``
- ``PerlInterpreter/subscript(hash:_:)``

### Using Perl Modules

- ``PerlInterpreter/use(_:)``
- ``PerlInterpreter/use(_:_:)``

### Setting Up and Tearing Down the Perl Environment

- ``PerlInterpreter/initialize()``
- ``PerlInterpreter/deinitialize()``
