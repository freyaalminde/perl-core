import CPerlCore

/// A Perl scalar value.
///
/// You use the `PerlScalarValue` class to convert basic values, such as numbers and strings, between Perl and Swift representations to pass data between native code and Perl code.
@available(macOS 10.10, *)
public class PerlScalarValue: CustomStringConvertible {
  let sv: UnsafeMutableRawPointer
  init (_ sv: UnsafeMutableRawPointer) { self.sv = sv }

  /// Whether the value is defined.
  public var isDefined: Bool { perlcore_svok(sv) != 0 }
  /// Undefines the value.
  public func undefine() { perlcore_undef(sv) }

  /// Converts the Perl value to a Boolean value.
  public var asBool: Bool {
    get { perlcore_svtrue(sv) != 0 }
    set { perlcore_setiv(sv, newValue ? 1 : 0 ) }
  }
  /// Converts the Perl value to an unsigned integer value.
  public var asUInt: UInt {
    get { perlcore_svuv(sv) }
    set { perlcore_setuv(sv, newValue) }
  }
  /// Converts the Perl value to an integer value.
  public var asInt: Int {
    get { perlcore_sviv(sv) }
    set { perlcore_setiv(sv, newValue) }
  }
  /// Converts the Perl value to a floating-point value.
  public var asDouble: Double {
    get { perlcore_svnv(sv) }
    set { perlcore_setnv(sv, newValue) }
  }
  /// Converts the Perl value to a string.
  public var asString: String {
    get { String(cString: perlcore_svpv(sv)) }
    set { newValue.withCString { perlcore_setpv(self.sv, $0) } }
  }

  public var description: String { asString }

  // MARK: - References
  public var refType: String {
    String(validatingUTF8: perlcore_reftype(sv))!
  }
  public func derefScalar() -> PerlScalarValue? {
    refType == "SCALAR" ? PerlScalarValue(perlcore_deref(sv)) : nil
  }
  public func derefArray() -> PerlArrayValue? {
    refType == "ARRAY" ? PerlArrayValue(perlcore_deref(sv)) : nil
  }
  public func derefHash() -> PerlHashValue? {
    refType == "HASH" ? PerlHashValue(perlcore_deref(sv)) : nil
  }
}
