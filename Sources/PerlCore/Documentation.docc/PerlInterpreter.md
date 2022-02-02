# ``PerlCore/PerlInterpreter``

### Example Usage

```swift
PerlInterpreter.initialize()
let interpreter = PerlInterpreter()
interpreter.`$`("prefix", true)!.asString = "Just "
let script = "$prefix . reverse q(rekcaH lreP rehtonA)"
let result = interpreter.evaluateScript(script)
assert(result.asString == "Just Another Perl Hacker")
```

## Topics

### Setting Up and Tearing Down the Perl Environment

- ``PerlInterpreter/initialize()``
- ``PerlInterpreter/deinitialize()``

### Creating Perl Interpreters

- ``PerlInterpreter/init()``

### Evaluating Scripts

- ``PerlInterpreter/evaluateScript(_:)``

### Working with Perl Global State

- ``PerlInterpreter/evaluationSucceeded``
- ``PerlInterpreter/exception``

### Accessing Values in Perl Global State

- ``PerlInterpreter/$(_:_:)``
- ``PerlInterpreter/scalarValue(_:_:)``
- ``PerlInterpreter/arrayValue(_:_:)``
- ``PerlInterpreter/hashValue(_:_:)``

### Using Perl Modules

- ``PerlInterpreter/use(_:)``
- ``PerlInterpreter/use(_:_:)``
