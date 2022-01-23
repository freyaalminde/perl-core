//
//  swiftperl.swift
//  swiftperl
//
//  Created by Dan Kogai on 7/12/14.
//  Copyright (c) 2014 Dan Kogai. All rights reserved.
//

class PerlString: CustomStringConvertible {
  let sv: UnsafeMutableRawPointer
  init (_ sv: UnsafeMutableRawPointer) { self.sv = sv }
  var defined: Bool { swiftperl_svok(sv) != 0 }
  func undef() { swiftperl_undef(sv) }
  var asBool: Bool {
    get { swiftperl_svtrue(sv) != 0 }
    set { swiftperl_setiv(sv, newValue ? 1 : 0 ) }
  }
  var asUInt: UInt {
    get { swiftperl_svuv(sv) }
    set { swiftperl_setuv(sv, newValue) }
  }
  var asInt: Int {
    get { swiftperl_sviv(sv) }
    set { swiftperl_setiv(sv, newValue) }
  }
  var asDouble: Double {
    get { swiftperl_svnv(sv) }
    set { swiftperl_setnv(sv, newValue) }
  }
  var asString: String {
    get { String(cString: swiftperl_svpv(sv)) }
    set { newValue.withCString { swiftperl_setpv(self.sv, $0) } }
  }
  var description: String { asString }
  // References
  var refType: String {
    String(validatingUTF8: swiftperl_reftype(sv))!
  }
  func derefScalar() -> PerlString? {
    refType == "SCALAR" ? PerlString(swiftperl_deref(sv)) : nil
  }
  func derefArray() -> PerlArray? {
    refType == "ARRAY" ? PerlArray(swiftperl_deref(sv)) : nil
  }
  func derefHash() -> PerlHash? {
    refType == "HASH" ? PerlHash(swiftperl_deref(sv)) : nil
  }
}

class PerlArray: CustomStringConvertible {
  let av: UnsafeMutableRawPointer
  init (_ sv: UnsafeMutableRawPointer){ self.av = sv }
  
  func toArray() -> [PerlString?] {
    var result = [PerlString?]()
    for i in 0...swiftperl_av_len(av) {
      let sv = swiftperl_av_fetch(av, i, 0)
      result.append(sv == nil ? nil : PerlString(sv!))
    }
    return result
  }
  
  func get(_ i: Int) -> PerlString? {
    // it is NOT optional because it is always created
    let sv = swiftperl_av_fetch(av, Int32(i), 0)
    return sv == nil ? nil : PerlString(sv!)
  }
  
  func delete(_ i: Int) -> PerlString? {
    // it is NOT optional because it is always created
    let sv = swiftperl_av_delete(av, Int32(i))
    return sv == nil ? nil : PerlString(sv!)
  }
  
  subscript(_ i: Int) -> PerlString {
    // it is NOT optional because it is always created
    return PerlString(swiftperl_av_fetch(av, Int32(i), 1))
  }
  
  var description: String { "\(self.toArray())" }
}

class PerlHash: CustomStringConvertible {
  let hv: UnsafeMutableRawPointer
  init (_ hv: UnsafeMutableRawPointer) { self.hv = hv }
  
  func toDictionary() -> [String: PerlString?] {
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
  
  func get(_ k: String) -> PerlString? {
    let sv = swiftperl_hv_fetchs(hv, k.withCString{$0}, 0)
    return sv == nil ? nil : PerlString(sv!)
  }
  
  func delete(_ k: String) -> PerlString? {
    let sv = swiftperl_hv_delete(hv, k.withCString{$0})
    return sv == nil ? nil : PerlString(sv!)
  }
  
  subscript(_ k: String) -> PerlString {
    // it is NOT optional because it is always created
    return PerlString(
      swiftperl_hv_fetchs(hv, k.withCString{$0}, 1)
    )
  }
  var description: String { "\(self.toDictionary())" }
}

class PerlInterpreter {
  var debug: Bool
  
  init(debug: Bool = false) {
    self.debug = debug
    swiftperl_init()
  }
  
  deinit {
    if debug { print("Perl: deinitializing interpreter") }
    swiftperl_deinit()
  }
  
  func reinit() {
    if debug { print("Perl: reinitializing interpreter") }
    swiftperl_deinit(); swiftperl_init()
  }
  
  class func initialize() { swiftperl_sys_init() }
  class func deinitialize() { swiftperl_sys_term() }
  
  var preamble = "use v5.30; no strict;"
  
  @discardableResult func eval(_ script: String) -> PerlString {
    (preamble+script).withCString {
      PerlString(swiftperl_eval_pv($0, 0))
    }
  }
  
  var evalok: Bool {
    swiftperl_err() == 0
  }
  
  var errstr: String {
    String(validatingUTF8: swiftperl_errstr())!
  }
  
  func use(_ name:String) -> PerlString {
    eval("use \(name);")
  }
  
  func use<T>(_ name:String, _ args:T...)->PerlString {
    use(name + " " + args.map{"'\($0)'"}.joined(separator: ","))
  }
  
  func sv(_ name: String, _ add: Bool = false) -> PerlString? {
    let sv = name.withCString {
      swiftperl_get_sv($0, add ? 1 : 0)
    }
    return sv == nil ? nil : PerlString(sv!)
  }
  
  func `$`(_ name: String, _ add: Bool = false) -> PerlString? {
    sv(name, add)
  }
  
  func av(_ name: String, _ add: Bool = false) -> PerlArray? {
    let av = name.withCString { swiftperl_get_av($0, add ? 1 : 0) }
    return av == nil ? nil : PerlArray(av!)
  }
  
  func hv(_ name: String, _ add: Bool = false) -> PerlHash? {
    let hv = name.withCString { swiftperl_get_hv($0, add ? 1 : 0) }
    return hv == nil ? nil : PerlHash(hv!)
  }
}
