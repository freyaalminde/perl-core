import CPerlCore

/// A Perl execution environment.
@available(macOS 10.10, *)
public class PerlInterpreter {
  var debug: Bool
  
  /// Initializes a new Perl context.
  /// - returns: A new Perl context.
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
  
  /// Initialize the Perl environment.
  public class func initialize() { swiftperl_sys_init() }
  
  /// Deinitialize the Perl environment.
  public class func deinitialize() { swiftperl_sys_term() }
  
  var preamble = "use v5.30; no strict;"
  
  /// Executes the specified Perl code.
  @discardableResult
  public func evaluateScript(_ script: String) -> PerlString {
    (preamble+script).withCString {
      PerlString(swiftperl_eval_pv($0, 0))
    }
  }
  
  /// Whether the latest evaluation succeeded.
  public var evaluationSucceeded: Bool {
    swiftperl_err() == 0
  }
  
  /// A Perl exception thrown in evaluation of the script.
  ///
  /// PerlCore assigns any uncaught exception to this property, so you can check this property’s value to find uncaught exceptions arising from Perl function calls.
  public var exception: String {
    String(validatingUTF8: swiftperl_errstr())!
  }
  
  @discardableResult
  public func use(_ name:String) -> PerlString {
    evaluateScript("use \(name);")
  }
  
  @discardableResult
  public func use<T>(_ name:String, _ args: T...) -> PerlString {
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
