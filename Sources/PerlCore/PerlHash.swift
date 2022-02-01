import CPerlCore

public class PerlHash: CustomStringConvertible {
  let hv: UnsafeMutableRawPointer
  init (_ hv: UnsafeMutableRawPointer) { self.hv = hv }
  
  public func toDictionary() -> [String: PerlString?] {
    var result = [String: PerlString?]()
    swiftperl_hv_iterinit(hv)
    while true {
      let he = swiftperl_hv_iternext(hv)
      if he == nil { break }
      let key =
      String(validatingUTF8: swiftperl_hv_iterkey(he))!
      result[key] = PerlString(swiftperl_hv_iterval(he))
    }
    return result
  }
  
  public func get(_ k: String) -> PerlString? {
    let sv = swiftperl_hv_fetchs(hv, k.withCString{$0}, 0)
    return sv == nil ? nil : PerlString(sv!)
  }
  
  public func delete(_ k: String) -> PerlString? {
    let sv = swiftperl_hv_delete(hv, k.withCString{$0})
    return sv == nil ? nil : PerlString(sv!)
  }
  
  public subscript(_ k: String) -> PerlString {
    // it is NOT optional because it is always created
    return PerlString(
      swiftperl_hv_fetchs(hv, k.withCString{$0}, 1)
    )
  }
  public var description: String { "\(self.toDictionary())" }
}
