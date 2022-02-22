import CPerlCore

/// A Perl array value.
@available(macOS 10.10, iOS 9, tvOS 9, watchOS 7, *)
public class PerlArrayValue: CustomStringConvertible {
  let av: UnsafeMutableRawPointer
  init (_ sv: UnsafeMutableRawPointer) { self.av = sv }
  
  /// Converts the Perl array value to an array.
  /// - returns: The array representation of the value.
  public func toArray() -> [PerlScalarValue?] {
    var result = [PerlScalarValue?]()
    for i in 0...perlcore_av_len(av) {
      let sv = perlcore_av_fetch(av, i, 0)
      result.append(sv == nil ? nil : PerlScalarValue(sv!))
    }
    return result
  }
  
  public func get(_ i: Int) -> PerlScalarValue? {
    // it is NOT optional because it is always created
    let sv = perlcore_av_fetch(av, Int32(i), 0)
    return sv == nil ? nil : PerlScalarValue(sv!)
  }
  
  public func delete(_ i: Int) -> PerlScalarValue? {
    // it is NOT optional because it is always created
    let sv = perlcore_av_delete(av, Int32(i))
    return sv == nil ? nil : PerlScalarValue(sv!)
  }
  
  public subscript(_ i: Int) -> PerlScalarValue {
    // it is NOT optional because it is always created
    return PerlScalarValue(perlcore_av_fetch(av, Int32(i), 1))
  }
  
  public var description: String { "\(self.toArray())" }
}
