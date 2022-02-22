import XCTest
import PerlCore

final class PerlCoreTests: XCTestCase {
  func testEvaluation() {
    let interpreter = PerlInterpreter.shared
    interpreter["prefix"]!.asString = "Just "
    let script = "$prefix . reverse q(rekcaH lreP rehtonA)"
    let result = interpreter.evaluateScript(script)
    XCTAssertEqual(result.asString, "Just Another Perl Hacker")
  }

  func run(_ script: String) {
    let perl = PerlInterpreter.shared
    XCTAssertNoThrow(perl.evaluateScript(script))
    //let result = perl.evaluateScript(script)
    // print("eval \"\(script)\" = \(result)")
    // if !perl.evaluationSucceeded {
    //   print(" err:   \(perl.exception)")
    // } else {
    //   print("  !!:   \(result.asBool)")
    //   print("  int:  \(result.asInt)")
    //   print("  +0.0: \(result.asDouble)")
    //   print("  q{}.: \(result.asString)")
    // }
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

    let perl = PerlInterpreter.shared

    perl.evaluateScript("our $swift = q(0.0 but rocks)")
    // print(perl["swift"] as Any)
    // print(perl["swift"]?.asBool as Any)
    XCTAssertEqual(perl["swift"]!.asBool, true)
    // print(perl["swift"]?.asDouble as Any)
    XCTAssertEqual(perl["swift"]!.asDouble, 0.0)
    // print(perl["objC"] as Any)
  }
  
  func testScalarValues() {
    let perl = PerlInterpreter.shared

    perl.evaluateScript("our $scalar")
    let scalar = perl["scalar"]!
    // print(scalar.isDefined)
    // XCTAssertEqual(scalar.isDefined, false)
    scalar.asBool = !scalar.asBool
    // perl.evaluateScript("say $scalar")
    XCTAssertEqual(perl.evaluateScript("$scalar").asInt, 1)
    scalar.asInt *= 42
    // perl.evaluateScript("say $scalar")
    XCTAssertEqual(perl.evaluateScript("$scalar").asInt, 42)
    scalar.asDouble += 0.195
    // perl.evaluateScript("say $scalar")
    XCTAssertEqual(perl.evaluateScript("$scalar").asDouble, 42.195)
    scalar.asString += "km"
    // perl.evaluateScript("say $scalar")
    XCTAssertEqual(perl.evaluateScript("$scalar").asString, "42.195km")
    scalar.undefine()
    // perl.evaluateScript("say $scalar")
    XCTAssertEqual(scalar.isDefined, false)
  }

  func testArrayVaues() {
    let perl = PerlInterpreter.shared

    perl.evaluateScript("our @array")
    let array = perl[array: "array"]!
    array[0].asInt = 1
    array[3].asInt = 4
    XCTAssertEqual(perl[array: "array"]![0].asInt, 1)
    XCTAssertEqual(perl[array: "array"]![3].asInt, 4)
    _ = array.delete(0)
    XCTAssertEqual(perl[array: "array"]![0].asInt, 0)
    XCTAssertEqual(perl[array: "array"]![3].asInt, 4)
  }

  func testHashValues() {
    let perl = PerlInterpreter.shared

    perl.evaluateScript("our %hash")
    let hash = perl[hash: "hash"]!
    hash["zero"].asInt = 0
    hash["one"].asInt = 1
    XCTAssertEqual(perl[hash: "hash"]!.toDictionary().keys.count, 2)
    _ = hash.delete("one")
    XCTAssertEqual(perl[hash: "hash"]!.toDictionary().keys.count, 1)
  }
  
  func testReferences() {
    let perl = PerlInterpreter.shared

    perl.evaluateScript("our $ref = 0")
    // print(perl["ref"]!.refType)
    perl.evaluateScript("$ref = \\0")
    XCTAssertEqual(perl["ref"]!.refType, "SCALAR")
    // print(perl["ref"]!.refType)
    // print(perl["ref"]!.derefScalar() as Any)
    perl.evaluateScript("$ref = [0]")
    XCTAssertEqual(perl["ref"]!.refType, "ARRAY")
    // print(perl["ref"]!.refType)
    // print(perl["ref"]!.derefArray() as Any)
    perl.evaluateScript("$ref = {zero=>0}")
    XCTAssertEqual(perl["ref"]!.refType, "HASH")
    // print(perl["ref"]!.refType)
    // print(perl["ref"]!.derefHash() as Any)
  }
  
  func testUse() {
    let perl = PerlInterpreter.shared

    try! perl.use("strict")
    try! perl.use("warnings")
    try! perl.use("utf8")
    // try! perl.use("Encode")
    try! perl.use("Text::Wrap") 

//    try! perl.use("Scalar::Util", "dualvar")
//    let dualvar = perl.evaluateScript("dualvar 42, q(The Answer)")
//    // print(dualvar.asInt)
//    // print(dualvar.asString)
//    XCTAssertEqual(dualvar.asInt, 42)
//    XCTAssertEqual(dualvar.asString, "The Answer")
  }
}
