import XCTest
import PerlCore

final class PerlCoreTests: XCTestCase {
  override class func setUp() { PerlInterpreter.initialize() }
  override class func tearDown() { PerlInterpreter.deinitialize() }

  func testEvaluation() {
    let interpreter = PerlInterpreter()
    interpreter.scalarValue("greeting", true)!.asString = "Hello, "
    let script = "$greeting . reverse q(rekcaH lreP rehtonA tsuJ)"
    let result = interpreter.evaluateScript(script)
    XCTAssertEqual(result.asString, "Hello, Just Another Perl Hacker")
  }

  func run(_ script: String) {
    let perl = PerlInterpreter()
    let result = perl.evaluateScript(script)
    print("eval \"\(script)\" = \(result)")
    if !perl.evaluationSucceeded {
      print(" err:   \(perl.exception)")
    } else {
      print("  !!:   \(result.asBool)")
      print("  int:  \(result.asInt)")
      print("  +0.0: \(result.asDouble)")
      print("  q{}.: \(result.asString)")
    }
  }

  func testMultipleEvaluations() throws {
    run("reverse q(rekcaH lreP rehtonA tsuJ)")
    run("atan2(0,-1)")
    run("q{0 but true}")
    run("my @a = (0,1,2,3)")
    run("my %h = (zero => 0, one => 1)")
    run("qr/\\A(.*)\\z/msx")
    run("phpinfo()")
    run("sub{ @_ }")

    let perl = PerlInterpreter()

    perl.evaluateScript("our $swift = q(0.0 but rocks)")
    print(perl.`$`("swift") as Any)
    print(perl.`$`("swift")?.asBool as Any)
    print(perl.`$`("swift")?.asDouble as Any)
    print(perl.`$`("objC") as Any)
    // scalar
    perl.evaluateScript("our $scalar")
    let scalar = perl.scalarValue("scalar")!
    print(scalar.isDefined)
    scalar.asBool = !scalar.asBool
    perl.evaluateScript("say $scalar")
    scalar.asInt *= 42
    perl.evaluateScript("say $scalar")
    scalar.asDouble += 0.195
    perl.evaluateScript("say $scalar")
    scalar.asString += "km"
    perl.evaluateScript("say $scalar")
    scalar.undefine()
    perl.evaluateScript("say $scalar")
    // array
    perl.evaluateScript("our @array")
    let array = perl.arrayValue("array")!
    array[0].asInt = 0
    array[3].asInt = 3
    print(perl.arrayValue("array") as Any)
    print(array.delete(0) as Any)
    print(perl.arrayValue("array") as Any)
    // hash
    perl.evaluateScript("our %hash")
    let hash = perl.hashValue("hash")!
    hash["zero"].asInt = 0
    hash["one"].asInt = 1
    print(perl.hashValue("hash") as Any)
    print(hash.delete("one") as Any)
    print(perl.hashValue("hash") as Any)
    /// reference
    perl.evaluateScript("our $ref = 0")
    print(perl.`$`("ref")!.refType)
    perl.evaluateScript("$ref = \\0")
    print(perl.`$`("ref")!.refType)
    print(perl.`$`("ref")!.derefScalar() as Any)
    perl.evaluateScript("$ref = [0]")
    print(perl.`$`("ref")!.refType)
    print(perl.`$`("ref")!.derefArray() as Any)
    perl.evaluateScript("$ref = {zero=>0}")
    print(perl.`$`("ref")!.refType)
    print(perl.`$`("ref")!.derefHash() as Any)
    /// use
    //pl.use("Scalar::Util", "dualvar")
    let dv = perl.evaluateScript("dualvar 42, q(The Answer)")
    print(dv.asInt)
    print(dv.asString)
  }
}
