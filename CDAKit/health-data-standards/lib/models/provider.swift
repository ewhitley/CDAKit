//
//  provider.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
Represents a care provider
*/

open class CDAKProvider: CDAKPersonable, CDAKJSONInstantiable, Hashable, Equatable, CustomStringConvertible {

  static let NPI_OID = "2.16.840.1.113883.4.6"
  static let NPI_OID_C83 = "2.16.840.1.113883.3.72.5.2"
  //NPI_OID_C83: Added this because there's a weird "ordering" condition that occurs in the XML import
  // it's possible to overwrite the NPI using the original Ruby code - check on find_or_create_provider()
  static let TAX_ID_OID = "2.16.840.1.113883.4.2"

  // MARK: CDA properties
  ///Prefix (was: Title)
  open var prefix: String?
  ///Suffix
  open var suffix: String?
  ///Given / First name
  open var given_name: String?
  ///Family / Last name
  open var family_name: String?
  ///addresses
  open var addresses: [CDAKAddress] = [CDAKAddress]()
  ///telecoms
  open var telecoms: [CDAKTelecom] = [CDAKTelecom]()
  ///provider specialty
  open var specialty: String?
  ///provider phone
  open var phone: String?
  ///provider organization
  open var organization: CDAKOrganization?
  ///CDA identifiers.  Contains NPI if supplied.
  open var cda_identifiers: [CDAKCDAIdentifier] = [CDAKCDAIdentifier]()
  

  /**
   
   From [Integrating the Healthcare Enterprise Wiki](http://wiki.ihe.net/index.php?title=1.3.6.1.4.1.19376.1.5.3.1.2.3#.3Ccode_code.3D.27_.27_displayName.3D.27_.27_codeSystem.3D.27_.27_codeSystemName.3D.27_.27.2F.3E):
   "The <code> element describes the type of provider and can be used to distinguish pharmacies from other providers."
   
   
   [Reference](http://www.cdapro.com/know/26953)

   Examples:
   
   ```
   <code 
    code="261QP2300X" 
    displayName="Primary Care [Ambulatory Health Care Facilities\Clinic/Center]"
    codeSystemName="NUCC Provider Codes" 
    codeSystem="2.16.840.1.113883.6.101"/>
   ```
   
   or
   
   ```
   <code 
    code="59058001"
    codeSystem="2.16.840.1.113883.6.96"
    codeSystemName="SNOMED CT" 
    displayName="General Physician"/>
   ```
   
  */
  open var code: CDAKCodedEntry?
  
  // Update the CDA identifier references for NPI
  // NOTE there are actually two ways to refer to NPI (two OIDs)
  // please refer to the provider importer and tests for examples where this occurs
  ///Allows you to quickly set or retrieve the NPI without specifying OID
  open var npi : String? {
    get {
      let cda_id_npi = cda_identifiers.filter({ $0.root == CDAKProvider.NPI_OID }).first
      return cda_id_npi != nil ? cda_id_npi?.extension_id : nil
    }
    set(an_npi) {
      if let cda_id_npi = cda_identifiers.filter({ $0.root == CDAKProvider.NPI_OID }).first {
        cda_id_npi.extension_id = an_npi
      } else {
        cda_identifiers.append(CDAKCDAIdentifier(root: CDAKProvider.NPI_OID, extension_id: an_npi))
      }
    }
  }
  ///Allows you to quickly set or retrive TIN (Tax ID Number) without specifying OID
  open var tin: String? {
    get {
      let cda_id_tin = cda_identifiers.filter({ $0.root == CDAKProvider.TAX_ID_OID }).first
      return cda_id_tin != nil ? cda_id_tin?.extension_id : nil
    }
    set(a_tin) {
      cda_identifiers.append(CDAKCDAIdentifier(root: CDAKProvider.TAX_ID_OID, extension_id: a_tin))
    }
  }
  
  // MARK: - Initializers
  public init() {
    CDAKGlobals.sharedInstance.CDAKProviders.append(self) //INSTANCE WORK-AROUND
  }

  deinit {
    CDAKProvider.removeProvider(self)
  }

  // MARK: - Deprecated - Do not use
  ///Do not use - will be removed. Was used in HDS Ruby.
  required public init(event: [String:Any?]) {
    initFromEventList(event)
    CDAKGlobals.sharedInstance.CDAKProviders.append(self) //INSTANCE WORK-AROUND
  }
  
  
  //scope :by_npi, ->(an_npi){ where("cda_identifiers.root" => NPI_OID, "cda_identifiers.extension" => an_npi)}
  ///searches for a provider by NPI. Queries the external provider collection.
  class func by_npi(_ an_npi: String?) -> CDAKProvider? {
    for prov in CDAKGlobals.sharedInstance.CDAKProviders {
      for cda in prov.cda_identifiers {
        if (cda.root == CDAKProvider.NPI_OID) && cda.extension_id == an_npi {
          return prov
        }
      }
    }
    
    return nil
  }
  

  // MARK: Health-Data-Standards Functions
  
//  func records(effective_date: String? = nil) {
//    //: need to do this, but doesn't have a purpose given our needs right now
//    //CDAKRecord.by_provider(self, effective_date)
//  }
  
  /**
   Validate the NPI, should be 10 or 15 digits total with the final digit being a checksum using the Luhn algorithm with additional special handling as described in
  
  [NPI Check Digit](https://www.cms.gov/NationalProvIdentStand/Downloads/NPIcheckdigit.pdf)
  */
  open class func valid_npi(_ npi: String?) -> Bool {
    guard var npi = npi else {
      return false
    }
    if npi.characters.count != 10 && npi.characters.count != 15 {
      return false
    }
    //return false if npi.gsub(/\d/, '').length > 0 # npi must be all digits
    guard let _ = Int(npi) else {
      return false
    }
    //return false if npi.length == 15 and (npi =~ /^80840/)==nil # 15 digit npi must start with 80840
    if npi.characters.count == 15 && !npi.hasPrefix("80840") {
      return false
    }
    
    //# checksum is always calculated as if 80840 prefix is present
    if npi.characters.count == 10 {
        npi = "80840" + npi
    }

    //NOTE: the original Ruby code was [0,14] - start at 0 with length of 14 - so end at _13_
    // the second Ruby was [14] - so just go to position 14
    // return luhn_checksum(npi[0,14]) == npi[14]
    //return luhn_checksum(npi[0...13]) == npi[14...14]

    _ = luhn_checksum(npi.substring(with: 0..<14)) == npi.substring(with: 14..<15)
    return luhn_checksum(npi.substring(with: 0..<14)) == npi.substring(with: 14..<15)
  }
  
  class func luhn_checksum(_ num: String) -> String {
    let double: [Character:Int] = ["0":0, "1":2, "2":4, "3":6, "4":8, "5":1, "6":3, "7":5, "8":7, "9":9]
    var sum = 0
    let reversed_num = String(num.characters.reversed())
    //num.split("").each_with_index do |char, i|
    for (i, char) in reversed_num.characters .enumerated() {
      if (i%2) == 0 {
        sum += double[char]!
      } else {
        let aString = String(char)
        if let anInt = Int(aString) {
          sum += anInt
        }
      }
    }
    
    sum = (9 * sum) % 10
    
    return String(sum)
  }
  
  /**
   When using the ProviderImporter class this method will be called if a parsed provider can not be found in the database if the parsed provider does not have an npi number associated with it.  This allows applications to handle this how they see fit by redefining this method.  The default implementation is to return an orphan parent (the singular provider without an NPI) if one exists.  If this method call return nil an attempt will be made to discover the Provider by name matching and if that fails a Provider will be created in the db based on the information in the parsed hash.
   
   NOTE: In Swift 2.1 we cannot provide default arguments for closures, so if you use the resolve_provider closure you'll need to send in nil for patient if there isn't one
   
  */
  class func resolve_provider(_ provider_hash: [String:Any], patient: CDAKPerson? = nil, resolve_function:((_ provider_hash: [String:Any], _ patient: CDAKPerson? ) -> CDAKProvider?)? = nil ) -> CDAKProvider? {
    //Provider.where(:npi => nil).first
    if let resolve_function = resolve_function {
      let p = resolve_function(provider_hash, patient ?? nil)
      return p
    } else {
      //let p = CDAKGlobals.sharedInstance.CDAKProviders.filter({ $0.npi == nil }).first
      //print("resolve_provider matched hash placeholder")
      //print("resolve_provider matched hash: {\(provider_hash)} to provider: {\(p)}")
      //return p
      return nil
    }
  }
  
  
  
  // MARK: Standard properties
  ///Debugging description
  open var description: String {
    return "Provider => prefix: \(prefix), given_name: \(given_name), family_name: \(family_name), suffix: \(suffix), npi: \(npi), specialty: \(specialty), phone: \(phone), organization: \(organization), cda_identifiers: \(cda_identifiers), addresses: \(addresses), telecoms: \(telecoms), code: \(code)"
  }

  
}

extension CDAKProvider {
  ///Removed a given provider from the global collection
  class func removeProvider(_ provider: CDAKProvider) {
    var matching_idx: Int?
    for (i, p) in CDAKGlobals.sharedInstance.CDAKProviders.enumerated() {
      if p == provider {
        matching_idx = i
      }
    }
    if let matching_idx = matching_idx {
      CDAKGlobals.sharedInstance.CDAKProviders.remove(at: matching_idx)
    }
  }
}

extension CDAKProvider {
  //NOTE: - not using the hash - just using native properties
  ///Generates a hash value for object comparisons
  public var hashValue: Int {
    
    var hv: Int
    
    hv = "\(prefix)\(given_name)\(family_name)\(specialty)\(phone)".hashValue
    
    if addresses.count > 0 {
      hv = hv ^ "\(addresses)".hashValue
    }
    if telecoms.count > 0 {
      hv = hv ^ "\(telecoms)".hashValue
    }
    if cda_identifiers.count > 0 {
      hv = hv ^ "\(cda_identifiers)".hashValue
    }
    if let organization = organization {
      hv = hv ^ organization.hashValue
    }
    
    return hv
  }
}

public func == (lhs: CDAKProvider, rhs: CDAKProvider) -> Bool {
  return lhs.hashValue == rhs.hashValue && CDAKCommonUtility.classNameAsString(lhs) == CDAKCommonUtility.classNameAsString(rhs)
}


extension CDAKProvider: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    
    var vals: [String:MustacheBox] = [:]
    vals = [
      "prefix" :  Box(prefix),
      "given_name" :  Box(given_name),
      "family_name" :  Box(family_name),
      "suffix" :  Box(suffix),
      "specialty" :  Box(specialty),
      "phone" :  Box(phone),
      "organization" :  Box(organization),
      "cda_identifiers" :  Box(cda_identifiers),
      "code": Box(code)
    ]
    
    if addresses.count > 0 {
      vals["addresses"] = Box(addresses)
    }
    if telecoms.count > 0 {
      vals["telecoms"] = Box(telecoms)
    }
    return vals

  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

extension CDAKProvider: CDAKJSONExportable {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if let prefix = prefix {
      dict["prefix"] = prefix as AnyObject?
    }
    if let given_name = given_name {
      dict["given_name"] = given_name as AnyObject?
    }
    if let family_name = family_name {
      dict["family_name"] = family_name as AnyObject?
    }
    if let suffix = suffix {
      dict["suffix"] = suffix as AnyObject?
    }
    
    if telecoms.count > 0 {
      dict["telecoms"] = telecoms.map({$0.jsonDict}) as AnyObject?
    }
    if addresses.count > 0 {
      dict["addresses"] = addresses.map({$0.jsonDict}) as AnyObject?
    }
    
    if let specialty = specialty {
      dict["specialty"] = specialty as AnyObject?
    }
    if let phone = phone {
      dict["phone"] = phone as AnyObject?
    }
    
    if let organization = organization {
      dict["organization"] = organization.jsonDict as AnyObject?
    }
    
    if cda_identifiers.count > 0 {
      dict["cda_identifiers"] = cda_identifiers.map({$0.jsonDict}) as AnyObject?
    }

    if let code = code {
      dict["code"] = code.jsonDict as AnyObject?
    }

    return dict
  }
}
