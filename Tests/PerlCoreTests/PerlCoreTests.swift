import XCTest
import PerlCore

final class PerlCoreTests: XCTestCase {
  override class func setUp() { PerlInterpreter.initialize() }
//  override class func tearDown() { PerlInterpreter.deinitialize() }
  
  func run(_ script: String) {
    let perl = PerlInterpreter(debug: true)
    let result = perl.eval(script)
    print("eval \"\(script)\" = \(result)")
    if !perl.evalok {
      print(" err:   \(perl.errstr)")
    } else {
      print("  !!:   \(result.asBool)")
      print("  int:  \(result.asInt)")
      print("  +0.0: \(result.asDouble)")
      print("  q{}.: \(result.asString)")
    }
  }

  func test() throws {
    run("reverse q(rekcaH lreP rehtonA tsuJ)")
    run("atan2(0,-1)")
    run("q{0 but true}")
    run("my @a = (0,1,2,3)")
    run("my %h = (zero => 0, one => 1)")
    run("qr/\\A(.*)\\z/msx")
    run("phpinfo()")
    run("sub{ @_ }")

    let perl = PerlInterpreter()

    perl.eval("our $swift = q(0.0 but rocks)")
    print(perl.`$`("swift") as Any)
    print(perl.`$`("swift")?.asBool as Any)
    print(perl.`$`("swift")?.asDouble as Any)
    print(perl.`$`("objC") as Any)
    // scalar
    perl.eval("our $scalar")
    let scalar = perl.sv("scalar")!
    print(scalar.defined)
    scalar.asBool = !scalar.asBool
    perl.eval("say $scalar")
    scalar.asInt *= 42
    perl.eval("say $scalar")
    scalar.asDouble += 0.195
    perl.eval("say $scalar")
    scalar.asString += "km"
    perl.eval("say $scalar")
    scalar.undef()
    perl.eval("say $scalar")
    // array
    perl.eval("our @array")
    let array = perl.av("array")!
    array[0].asInt = 0
    array[3].asInt = 3
    print(perl.av("array") as Any)
    print(array.delete(0) as Any)
    print(perl.av("array") as Any)
    // hash
    perl.eval("our %hash")
    let hash = perl.hv("hash")!
    hash["zero"].asInt = 0
    hash["one"].asInt = 1
    print(perl.hv("hash") as Any)
    print(hash.delete("one") as Any)
    print(perl.hv("hash") as Any)
    /// reference
    perl.eval("our $ref = 0")
    print(perl.`$`("ref")!.refType)
    perl.eval("$ref = \\0")
    print(perl.`$`("ref")!.refType)
    print(perl.`$`("ref")!.derefScalar() as Any)
    perl.eval("$ref = [0]")
    print(perl.`$`("ref")!.refType)
    print(perl.`$`("ref")!.derefArray() as Any)
    perl.eval("$ref = {zero=>0}")
    print(perl.`$`("ref")!.refType)
    print(perl.`$`("ref")!.derefHash() as Any)
    /// use
    //pl.use("Scalar::Util", "dualvar")
    let dv = perl.eval("dualvar 42, q(The Answer)")
    print(dv.asInt)
    print(dv.asString)
  }
}
