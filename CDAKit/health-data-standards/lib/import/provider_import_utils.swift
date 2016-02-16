//
//  provider_import_utils.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/12/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

//putting this here - it's NOT here in the original Ruby - it's just its own module

class CDAKImport_ProviderImportUtils {
  
  class func extract_provider(performer: XMLElement, element_name:String = "assignedEntity") -> CDAKProvider {
    let provider_data = CDAKImport_CDA_ProviderImporter.extract_provider_data(performer, use_dates: false, entity_path: "./cda:\(element_name)")
    return find_or_create_provider(provider_data)
  }

  //
  class func find_or_create_provider(provider_hash: [String:Any], patient: CDAKPerson? = nil) -> CDAKProvider {

    //see if we can find our provider by NPI
    if let npi = provider_hash["npi"] as? String where npi != "" {
      if let a_provider = CDAKProvider.by_npi(npi) {
        
        return a_provider
      }
    } else {
      //if we have cda identifiers
      if let cda_identifiers = provider_hash["cda_identifiers"] as? [CDAKCDAIdentifier] where cda_identifiers.count > 0 {
        //try to find a Provider entry where the identifiers are common
        if let a_provider = CDAKGlobals.sharedInstance.CDAKProviders.filter({ p in p.cda_identifiers.filter({
          id in cda_identifiers.contains(id)
        }).count > 0 }).first {
          return a_provider //if we have one, return that CDAKProvider
        }
      }
      //no match found by cda identifier, so continue using other options
      //Swift is complaining that I have too many conditions in a single filter (timeout) so I'm splitting this up
      if let a_provider = CDAKGlobals.sharedInstance.CDAKProviders.filter({ p in
          p.title == provider_hash["title"] as? String
            && p.given_name == provider_hash["given_name"] as? String
            && p.family_name == provider_hash["family_name"] as? String
//          && p.specialty == provider.specialty
      }).filter({p in p.specialty == provider_hash["specialty"] as? String}).first {
        return a_provider
      }
      if let a_provider = CDAKProvider.resolve_provider(provider_hash) {
        return a_provider
      }
    }
  
    //we didn't find an existing provider, so create one now
    let provider = CDAKProvider()
    provider.title = provider_hash["title"] as? String
    provider.given_name = provider_hash["given_name"] as? String
    provider.family_name = provider_hash["family_name"] as? String
    provider.specialty = provider_hash["specialty"] as? String
    provider.phone = provider_hash["phone"] as? String

    //OK, this is... not ideal.
    // When the Ruby restores the original Provider hash, I think it does so alphabetically
    // EX: cda_identifiers _then_ NPI
    // If you look at the Provider NPI code, you'll see it's looking for a specific OID (2.16.840.1.113883.4.6)
    // in the case of C83, this will be (2.16.840.1.113883.3.72.5.2)
    // because the NPI variable really just looks at the CDA Identifer list, what happens is the NPI gets written into
    // the CDA identifier array, then written _over_ by the _real_ CDA Identifiers that the record pulls in from the XML
    // So - ordering (for the moment) matters - until I work around this in the provider NPI retrieval
    if let npi = provider_hash["npi"] {
      provider.npi = String(npi)
    }
    if let cda_identifiers = provider_hash["cda_identifiers"] as? [CDAKCDAIdentifier] {
      var filteredValues: [CDAKCDAIdentifier] = [CDAKCDAIdentifier]()
      for cda in cda_identifiers {
        if cda.root == CDAKProvider.NPI_OID || cda.root == CDAKProvider.NPI_OID_C83 {
          //we're going to just do this the "bad" way and filter these out
          // since the NPI setter should hanlde these
        } else {
          filteredValues.append(cda)
        }
      }
      //we're APPENDING since we don't want to remove the NPI CDA identifiers
      provider.cda_identifiers.appendContentsOf(filteredValues)
    }

    
    
    if let addresses = provider_hash["addresses"] as? [CDAKAddress] {
      provider.addresses = addresses
    }
    if let telecoms = provider_hash["telecoms"] as? [CDAKTelecom] {
      provider.telecoms = telecoms
    }
    if let organization = provider_hash["organization"] as? CDAKOrganization {
      provider.organization = organization
    }

    return provider
  }
  
  
  //# Returns nil if result is an empty string, block allows text munging of result if there is one
  class func extract_data(subject: XMLElement, query: String) -> String? {
    if let result = subject.xpath(query).first?.stringValue where result != "" {
      return result
    }
    return nil
  }

  
}

