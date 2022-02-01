import CPerlCore

public class PerlArray: CustomStringConvertible {
  let av: UnsafeMutableRawPointer
  init (_ sv: UnsafeMutableRawPointer){ self.av = sv }
  
  public func toArray() -> [PerlString?] {
    var result = [PerlString?]()
    for i in 0...swiftperl_av_len(av) {
      let sv = swiftperl_av_fetch(av, i, 0)
      result.append(sv == nil ? nil : PerlString(sv!))
    }
    return result
  }
  
  public func get(_ i: Int) -> PerlString? {
    // it is NOT optional because it is always created
    let sv = swiftperl_av_fetch(av, Int32(i), 0)
    return sv == nil ? nil : PerlString(sv!)
  }
  
  public func delete(_ i: Int) -> PerlString? {
    // it is NOT optional because it is always created
    let sv = swiftperl_av_delete(av, Int32(i))
    return sv == nil ? nil : PerlString(sv!)
  }
  
  public subscript(_ i: Int) -> PerlString {
    // it is NOT optional because it is always created
    return PerlString(swiftperl_av_fetch(av, Int32(i), 1))
  }
  
  public var description: String { "\(self.toArray())" }
}
