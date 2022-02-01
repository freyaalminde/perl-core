import CPerlCore

/// A Perl execution environment.
public class PerlInterpreter {
  var debug: Bool
  
  public init(debug: Bool = false) {
    self.debug = debug
    swiftperl_init()
  }
  
  deinit {
    if debug { print("Perl: deinitializing interpreter") }
    swiftperl_deinit()
  }
  
  public func reinit() {
    if debug { print("Perl: reinitializing interpreter") }
    swiftperl_deinit(); swiftperl_init()
  }
  
  public class func initialize() { swiftperl_sys_init() }
  public class func deinitialize() { swiftperl_sys_term() }
  
  var preamble = "use v5.30; no strict;"
  
  @discardableResult public func eval(_ script: String) -> PerlString {
    (preamble+script).withCString {
      PerlString(swiftperl_eval_pv($0, 0))
    }
  }
  
  public var evalok: Bool {
    swiftperl_err() == 0
  }
  
  public var errstr: String {
    String(validatingUTF8: swiftperl_errstr())!
  }
  
  public func use(_ name:String) -> PerlString {
    eval("use \(name);")
  }
  
  public func use<T>(_ name:String, _ args:T...)->PerlString {
    use(name + " " + args.map{"'\($0)'"}.joined(separator: ","))
  }
  
  public func sv(_ name: String, _ add: Bool = false) -> PerlString? {
    let sv = name.withCString {
      swiftperl_get_sv($0, add ? 1 : 0)
    }
    return sv == nil ? nil : PerlString(sv!)
  }
  
  public func `$`(_ name: String, _ add: Bool = false) -> PerlString? {
    sv(name, add)
  }
  
  public func av(_ name: String, _ add: Bool = false) -> PerlArray? {
    let av = name.withCString { swiftperl_get_av($0, add ? 1 : 0) }
    return av == nil ? nil : PerlArray(av!)
  }
  
  public func hv(_ name: String, _ add: Bool = false) -> PerlHash? {
    let hv = name.withCString { swiftperl_get_hv($0, add ? 1 : 0) }
    return hv == nil ? nil : PerlHash(hv!)
  }
}
