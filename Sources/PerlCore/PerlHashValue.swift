import CPerlCore

/// A Perl hash value.
@available(macOS 10.10, iOS 9, tvOS 9, watchOS 7, *)
public class PerlHashValue: CustomStringConvertible {
  let hv: UnsafeMutableRawPointer
  init (_ hv: UnsafeMutableRawPointer) { self.hv = hv }
  
  /// Converts the Perl hash value to a dictionary.
  /// - returns: The dictionary representation of the value.
  public func toDictionary() -> [String: PerlScalarValue?] {
    var result = [String: PerlScalarValue?]()
    perlcore_hv_iterinit(hv)
    while true {
      let he = perlcore_hv_iternext(hv)
      if he == nil { break }
      let key =
      String(validatingUTF8: perlcore_hv_iterkey(he))!
      result[key] = PerlScalarValue(perlcore_hv_iterval(he))
    }
    return result
  }
  
  public func get(_ k: String) -> PerlScalarValue? {
    let sv = perlcore_hv_fetchs(hv, k.withCString{$0}, 0)
    return sv == nil ? nil : PerlScalarValue(sv!)
  }
  
  public func delete(_ k: String) -> PerlScalarValue? {
    let sv = perlcore_hv_delete(hv, k.withCString{$0})
    return sv == nil ? nil : PerlScalarValue(sv!)
  }
  
  public subscript(_ k: String) -> PerlScalarValue {
    // it is NOT optional because it is always created
    return PerlScalarValue(
      perlcore_hv_fetchs(hv, k.withCString{$0}, 1)
    )
  }
  
  public var description: String { "\(self.toDictionary())" }
}
