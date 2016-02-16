//
//  provider.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

public class CDAKProvider: CDAKPersonable, CDAKJSONInstantiable, Hashable, Equatable, CustomStringConvertible {
  
  //  include CDAKPersonable
  public var title: String?
  public var given_name: String?
  public var family_name: String?
  
  public var addresses: [CDAKAddress] = [CDAKAddress]()
  public var telecoms: [CDAKTelecom] = [CDAKTelecom]()

  static let NPI_OID = "2.16.840.1.113883.4.6"
  static let NPI_OID_C83 = "2.16.840.1.113883.3.72.5.2"
  //NPI_OID_C83: Added this because there's a weird "ordering" condition that occurs in the XML import
  // it's possible to overwrite the NPI using the original Ruby code - check on find_or_create_provider()

  static let TAX_ID_OID = "2.16.840.1.113883.4.2"
  
  public var specialty: String?
  public var phone: String?
  
  public var organization: CDAKOrganization?
  
  public var cda_identifiers: [CDAKCDAIdentifier] = [CDAKCDAIdentifier]()
  
  public init() {
    CDAKGlobals.sharedInstance.CDAKProviders.append(self) //INSTANCE WORK-AROUND
  }
  
  required public init(event: [String:Any?]) {
    initFromEventList(event)
    CDAKGlobals.sharedInstance.CDAKProviders.append(self) //INSTANCE WORK-AROUND
  }
  
  deinit {
    CDAKProvider.removeProvider(self)
  }
  
  //scope :by_npi, ->(an_npi){ where("cda_identifiers.root" => NPI_OID, "cda_identifiers.extension" => an_npi)}
  class func by_npi(an_npi: String?) -> CDAKProvider? {
    //MARK: FIXME - so foul
    for prov in CDAKGlobals.sharedInstance.CDAKProviders {
      for cda in prov.cda_identifiers {
        if (cda.root == CDAKProvider.NPI_OID) && cda.extension_id == an_npi {
          return prov
        }
      }
    }
    
    return nil
  }
  
  // Update the CDA identifier references for NPI
  // NOTE there are actually two ways to refer to NPI (two OIDs)
  // please refer to the provider importer and tests for examples where this occurs
  public var npi : String? {
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
  
  public var tin: String? {
    get {
      let cda_id_tin = cda_identifiers.filter({ $0.root == CDAKProvider.TAX_ID_OID }).first
      return cda_id_tin != nil ? cda_id_tin?.extension_id : nil
    }
    set(a_tin) {
      cda_identifiers.append(CDAKCDAIdentifier(root: CDAKProvider.TAX_ID_OID, extension_id: a_tin))
    }
  }
  
  func records(effective_date: String? = nil) {
    //TODO: need to do this, but doesn't have a purpose given our needs right now
    //CDAKRecord.by_provider(self, effective_date)
  }
  
  /**
   Validate the NPI, should be 10 or 15 digits total with the final digit being a checksum using the Luhn algorithm with additional special handling as described in
  
  [NPI Check Digit](https://www.cms.gov/NationalProvIdentStand/Downloads/NPIcheckdigit.pdf)
  */
  public class func valid_npi(npi: String?) -> Bool {
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
    return luhn_checksum(npi[0...13]) == npi[14...14]    
  }
  
  class func luhn_checksum(num: String) -> String {
    let double: [Character:Int] = ["0":0, "1":2, "2":4, "3":6, "4":8, "5":1, "6":3, "7":5, "8":7, "9":9]
    var sum = 0
    let reversed_num = String(num.characters.reverse())
    //num.split("").each_with_index do |char, i|
    for (i, char) in reversed_num.characters .enumerate() {
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
  class func resolve_provider(provider_hash: [String:Any], patient: CDAKPerson? = nil, resolve_function:((provider_hash: [String:Any], patient: CDAKPerson? ) -> CDAKProvider?)? = nil ) -> CDAKProvider? {
    //Provider.where(:npi => nil).first
    if let resolve_function = resolve_function {
      let p = resolve_function(provider_hash: provider_hash, patient: patient ?? nil)
      return p
    } else {
      let p = CDAKGlobals.sharedInstance.CDAKProviders.filter({ $0.npi == nil }).first
      return p
    }
  }
  
  public var description: String {
    return "Provider => title: \(title), given_name: \(given_name), family_name: \(family_name), npi: \(npi), specialty: \(specialty), phone: \(phone), organization: \(organization), cda_identifiers: \(cda_identifiers), addresses: \(addresses), telecoms: \(telecoms)"
  }

  
}

extension CDAKProvider {
  
  
  class func removeProvider(provider: CDAKProvider) {
    var matching_idx: Int?
    for (i, p) in CDAKGlobals.sharedInstance.CDAKProviders.enumerate() {
      if p == provider {
        matching_idx = i
      }
    }
    if let matching_idx = matching_idx {
      CDAKGlobals.sharedInstance.CDAKProviders.removeAtIndex(matching_idx)
    }
  }
}

extension CDAKProvider {
  //MARK: FIXME - not using the hash - just using native properties
  public var hashValue: Int {
    
    var hv: Int
    
    hv = "\(title)\(given_name)\(family_name)\(specialty)\(phone)".hashValue
    
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
  var boxedValues: [String:MustacheBox] {
    return [
      "title" :  Box(title),
      "given_name" :  Box(given_name),
      "family_name" :  Box(family_name),
      "addresses" :  Box(addresses),
      "telecoms" :  Box(telecoms),
      "specialty" :  Box(specialty),
      "phone" :  Box(phone),
      "organization" :  Box(organization),
      "cda_identifiers" :  Box(cda_identifiers)
    ]
  }
  
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}