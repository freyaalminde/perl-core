import XCTest
@testable import PerlCore

final class PerlCoreTests: XCTestCase {
  func test() throws {
    PerlInterpreter.initialize()

    func run(_ script: String) {
      let pl = PerlInterpreter(debug: true)
      let sv = pl.eval(script)
      print("eval \"\(script)\"")
      if !pl.evalok {
        print(" err:   \(pl.errstr)")
      } else {
        print("  !!:   \(sv.asBool)")
        print("  int:  \(sv.asInt)")
        print("  +0.0: \(sv.asDouble)")
        print("  q{}.: \(sv.asString)")
      }
    }

    run("reverse q(rekcaH lreP rehtonA tsuJ)")
    run("atan2(0,-1)")
    run("q{0 but true}")
    run("my @a = (0,1,2,3)")
    run("my %h = (zero => 0, one => 1)")
    run("qr/\\A(.*)\\z/msx")
    run("sub{ @_ }")
    run("phpinfo()")

    let pl = PerlInterpreter()

    pl.eval("our $swift = q(0.0 but rocks)")
    print(pl.`$`("swift") as Any)
    print(pl.`$`("swift")?.asBool as Any)
    print(pl.`$`("swift")?.asDouble as Any)
    print(pl.`$`("objC") as Any)
    // scalar
    pl.eval("our $scalar")
    let scalar = pl.sv("scalar")!
    print(scalar.defined)
    scalar.asBool = !scalar.asBool
    pl.eval("say $scalar")
    scalar.asInt *= 42
    pl.eval("say $scalar")
    scalar.asDouble += 0.195
    pl.eval("say $scalar")
    scalar.asString += "km"
    pl.eval("say $scalar")
    scalar.undef()
    pl.eval("say $scalar")
    // array
    pl.eval("our @array")
    let array = pl.av("array")!
    array[0].asInt = 0
    array[3].asInt = 3
    print(pl.av("array") as Any)
    print(array.delete(0) as Any)
    print(pl.av("array") as Any)
    // hash
    pl.eval("our %hash")
    let hash = pl.hv("hash")!
    hash["zero"].asInt = 0
    hash["one"].asInt = 1
    print(pl.hv("hash") as Any)
    print(hash.delete("one") as Any)
    print(pl.hv("hash") as Any)
    /// reference
    pl.eval("our $ref = 0")
    print(pl.`$`("ref")!.refType)
    pl.eval("$ref = \\0")
    print(pl.`$`("ref")!.refType)
    print(pl.`$`("ref")!.derefScalar() as Any)
    pl.eval("$ref = [0]")
    print(pl.`$`("ref")!.refType)
    print(pl.`$`("ref")!.derefArray() as Any)
    pl.eval("$ref = {zero=>0}")
    print(pl.`$`("ref")!.refType)
    print(pl.`$`("ref")!.derefHash() as Any)
    /// use
    //pl.use("Scalar::Util", "dualvar")
    let dv = pl.eval("dualvar 42, q(The Answer)")
    print(dv.asInt)
    print(dv.asString)
  }
}
