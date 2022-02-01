import CPerlCore

/// A Perl string.
public class PerlString: CustomStringConvertible {
  let sv: UnsafeMutableRawPointer
  init (_ sv: UnsafeMutableRawPointer) { self.sv = sv }
  public var defined: Bool { swiftperl_svok(sv) != 0 }
  public func undef() { swiftperl_undef(sv) }
  public var asBool: Bool {
    get { swiftperl_svtrue(sv) != 0 }
    set { swiftperl_setiv(sv, newValue ? 1 : 0 ) }
  }
  public var asUInt: UInt {
    get { swiftperl_svuv(sv) }
    set { swiftperl_setuv(sv, newValue) }
  }
  public var asInt: Int {
    get { swiftperl_sviv(sv) }
    set { swiftperl_setiv(sv, newValue) }
  }
  public var asDouble: Double {
    get { swiftperl_svnv(sv) }
    set { swiftperl_setnv(sv, newValue) }
  }
  public var asString: String {
    get { String(cString: swiftperl_svpv(sv)) }
    set { newValue.withCString { swiftperl_setpv(self.sv, $0) } }
  }
  public var description: String { asString }
  // References
  public var refType: String {
    String(validatingUTF8: swiftperl_reftype(sv))!
  }
  public func derefScalar() -> PerlString? {
    refType == "SCALAR" ? PerlString(swiftperl_deref(sv)) : nil
  }
  public func derefArray() -> PerlArray? {
    refType == "ARRAY" ? PerlArray(swiftperl_deref(sv)) : nil
  }
  public func derefHash() -> PerlHash? {
    refType == "HASH" ? PerlHash(swiftperl_deref(sv)) : nil
  }
}
