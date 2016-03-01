//
//  section_importer.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/12/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

import Foundation
import Fuzi

struct CodePair {
  var code: String?
  var codeSystem: String
  var codeSystemOid: String?
  init(codeSystem: String, code: String?, codeSystemOid: String? = nil) {
    self.code = code
    self.codeSystem = codeSystem
    self.codeSystemOid = codeSystemOid
  }
}

class CDAKImport_CDA_SectionImporter {
  
  var entry_finder: CDAKImport_CDA_EntryFinder
  var code_xpath = "./cda:code"
  var id_xpath = "./cda:id"
  var status_xpath: String?
  var priority_xpath: String?
  var description_xpath = "./cda:code/cda:originalText/cda:reference[@value] | ./cda:text/cda:reference[@value]"
  var check_for_usable: Bool = false
  var entry_class = CDAKEntry.self
  var value_xpath: String? = "cda:value"
  
  init(entry_finder: CDAKImport_CDA_EntryFinder) {
    self.entry_finder = entry_finder
    check_for_usable = true
  }
  

  /**
  Traverses an HL7 CDA document passed in and creates an Array of CDAKEntry objects based on what it finds

  - parameter doc: It is expected that the root node of this document will have the "cda" namespace registered to "urn:hl7-org:v3" measure definition
  - returns: will be a list of CDAKEntry objects
  */
  func create_entries(doc: XMLDocument, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> [CDAKEntry] {

    var entry_list: [CDAKEntry] = []
    let entry_elements = entry_finder.entries(doc)
    
    for entry_element in entry_elements {
      if let entry = create_entry(entry_element, nrh: nrh) {
        if check_for_usable == true {
          if entry.usable() {
            entry_list.append(entry)
          }
        } else {
          entry_list.append(entry)
        }
      }
    }

    return entry_list
  }

  
  func create_entry(entry_element: XMLElement, nrh: CDAKImport_CDA_NarrativeReferenceHandler = CDAKImport_CDA_NarrativeReferenceHandler()) -> CDAKEntry? {
    
    let entry = entry_class.init()
    extract_id(entry_element, entry: entry)
    extract_codes(entry_element, entry: entry)
    extract_dates(entry_element, entry: entry)
    
    if let _ = value_xpath {
      extract_values(entry_element, entry: entry)
    }
    extract_description(entry_element, entry: entry, nrh: nrh)
    if let _ = status_xpath {
      extract_status(entry_element, entry: entry)
    }
    return entry
    
  }

  
  func extract_indication(entry_element: XMLElement, entry: CDAKEntry, indication_xpath: String) -> CDAKEntry? {
    if let indication_element = entry_element.xpath(indication_xpath).first {
      //NOTE: we're not capturing xsi:type="CD" / "CE" etc.
      // we're goign to flag everything as CE ("Coded with Equivalents")
      let indication = CDAKEntry()
      extract_codes(indication_element, entry: indication, codes_xpath: "cda:value")
      extract_dates(indication_element, entry: indication)
      extract_id(indication_element, entry: indication)
      indication.explicit_preferred_code_sets = ["SNOMED-CT"]
      
      return indication
    }
    return nil

  }

  func extract_description(parent_element: XMLElement, entry: CDAKEntry, nrh: CDAKImport_CDA_NarrativeReferenceHandler) {
    let orig_text_ref_element = parent_element.xpath(description_xpath).first
    let desc_ref_element = parent_element.xpath("./cda:text/cda:reference").first
    if let orig_text_ref_element = orig_text_ref_element, val = orig_text_ref_element["value"] {
      entry.item_description = nrh.lookup_tag(val)
    } else if let desc_ref_element = desc_ref_element, val = desc_ref_element["value"] {
      entry.item_description = nrh.lookup_tag(val)
    } else if let elem = parent_element.xpath("./cda:text").first {
      entry.item_description = elem.stringValue
    }
  }

  func extract_status(parent_element: XMLElement, entry: CDAKEntry) {
    if let status_xpath = status_xpath, status_element = parent_element.xpath(status_xpath).first {
      entry.status_code.addCodes(CDAKImport_CDA_SectionImporter.extract_code(status_element, code_xpath: "."))
    }
  }

  func extract_id(parent_element: XMLElement, entry: CDAKEntry) {
    if let id_element = parent_element.xpath(id_xpath).first {
      let identifier = CDAKCDAIdentifier()
      identifier.root = id_element["root"]
      identifier.extension_id = id_element["extension"]
      entry.cda_identifier = identifier
    }
  }

  func extract_reason_description(parent_element: XMLElement, entry: CDAKEntry, nrh: CDAKImport_CDA_NarrativeReferenceHandler) {
    let code_elements = parent_element.xpath(description_xpath)
    for code_element in code_elements {
      if let tag = code_element["value"] {
        entry.item_description = nrh.lookup_tag(tag)
      }
    }
  }

  func extract_codes(parent_element: XMLElement, entry: CDAKThingWithCodes, codes_xpath: String? = nil) {
    let xpath = codes_xpath ?? code_xpath
    let code_elements = parent_element.xpath(xpath)
    for code_element in code_elements {
      add_code_if_present(code_element, entry: entry)
      let translations = code_element.xpath("cda:translation")
      for translation in translations {
        add_code_if_present(translation, entry: entry)
      }
    }
  }

  func add_code_if_present(code_element: XMLElement, entry: CDAKThingWithCodes) {
    entry.codes.addCodes(CDAKImport_CDA_SectionImporter.extract_code(code_element, code_xpath: "."))
  }

  func extract_dates(parent_element: XMLElement, entry: CDAKThingWithTimes, element_name: String = "effectiveTime") {
    if let elem = parent_element.xpath("cda:\(element_name)/@value").first {
      entry.time = CDAKHL7Helper.timestamp_to_integer(elem.stringValue)
    }
    if let elem = parent_element.xpath("cda:\(element_name)/cda:low").first {
      entry.start_time = CDAKHL7Helper.timestamp_to_integer(elem["value"])
    }
    if let elem = parent_element.xpath("cda:\(element_name)/cda:high").first {
      entry.end_time = CDAKHL7Helper.timestamp_to_integer(elem["value"])
    }
    if let elem = parent_element.xpath("cda:\(element_name)/cda:center").first {
      entry.time = CDAKHL7Helper.timestamp_to_integer(elem["value"])
    }
  }

  func extract_values(parent_element: XMLElement, entry: CDAKEntry) {
    if let value_xpath = value_xpath {
      for elem in parent_element.xpath(value_xpath) {
        extract_value(parent_element, value_element: elem, entry: entry)
      }
    }
  }

  func extract_value(parent_element: XMLElement, value_element: XMLElement?, entry: CDAKEntry) {
    //FIX_ME: - I had to comment some of this out... not the type I was expecting
    if let value_element = value_element {
      if let value = value_element["value"] {
        let unit = value_element["unit"]
        entry.set_value(value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), units: unit)
      } else if let _ = value_element["code"] {
        // there is one example I found where this is being called:
        // bundle exec rake test TEST=test/unit/import/cat1/tobacco_use_importer_test.rb
        // that example blows up if you attempt to access time, start_time, or end_time
        // Ruby is using dynamic properties for times here - so we're side-stepping this 
        // by using the ThingWithTimes protocol
        let crv = CDAKCodedResultValue()
        add_code_if_present(value_element, entry: crv)
        extract_dates(parent_element, entry: crv)
        entry.values.append(crv)
      } else {
        let value = value_element.stringValue
        let unit = value_element["unit"]
        entry.set_value(value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), units: unit)
      }
    }
  }

  func import_actor(actor_element: XMLElement) -> CDAKProvider {
    return CDAKImport_ProviderImportUtils.extract_provider(actor_element)
  }

  func import_organization(organization_element: XMLElement) -> CDAKOrganization? {
    return CDAKImport_CDA_OrganizationImporter.extract_organization(organization_element)
  }

  
  func import_person(person_element: XMLElement?) -> CDAKPerson? {
    
    guard let person_element = person_element else {
      return nil
    }
    let person = CDAKPerson()
    if let name_element = person_element.xpath("./cda:name").first {
      person.prefix = name_element.xpath("./cda:prefix").first?.stringValue
      person.given_name = name_element.xpath("./cda:given").first?.stringValue
      person.family_name = name_element.xpath("./cda:family").first?.stringValue
      person.suffix = name_element.xpath("./cda:suffix").first?.stringValue
    }
    person.addresses = person_element.xpath("./cda:addr").flatMap { addr in CDAKImport_CDA_LocatableImportUtils.import_address(addr) }
    person.telecoms = person_element.xpath("./cda:telecom").flatMap { tele in CDAKImport_CDA_LocatableImportUtils.import_telecom(tele) }
    return person
  }

  func extract_negation(parent_element: XMLElement, entry: CDAKEntry) {
    //FIX_ME: does not appear to pull translations
    if let negation_indicator = parent_element["negationInd"] {
      entry.negation_ind = negation_indicator.lowercaseString == "true"
      if entry.negation_ind == true {
        if let negation_reason_element = parent_element.xpath("./cda:entryRelationship[@typeCode='RSON']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.24.3.88']/cda:value | ./cda:entryRelationship[@typeCode='RSON']/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:code").first {
          entry.negation_reason.addCodes(CDAKImport_CDA_SectionImporter.extract_code(negation_reason_element, code_xpath: "."))
        }
      }
    }
  }
  
  /**
   Primary method responsible for extracting a code/codeSystem/displayName from a given code entry
   
   - parameter parent_element: the XML element containing the code(s)
   - parameter code_xpath: XPath query to your coded element within the parent.  Could even be "."
   - parameter code_system: optional string to override (or just directly supply) a given code system for this entry.  Certain entries (EX: language, race, ethnicity) do not supply a code system directly, but instead rely on an "implied" code system like "CDC Race" which aren't defined in the XML. In this case, the code system tag/name can be supplied directly and then looked up internally (if possible) to obtain the OID, etc.
  */
  class func extract_code(parent_element: XMLElement, code_xpath: String, code_system: String? = nil) -> CDAKCodedEntry? {
    if let code_element = parent_element.xpath(code_xpath).first {
      if let code = code_element["code"] {
        let display_name = code_element["displayName"]
        if let code_system = code_system {
          return CDAKCodedEntry(codeSystem: code_system, code: code, displayName: display_name)
        } else if let code_system_oid = code_element["codeSystem"] {
          if let codeSystemName = code_element["codeSystemName"] {
            CDAKCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
          }
          return CDAKCodedEntry(codeSystem: CDAKCodeSystemHelper.code_system_for(code_system_oid), code: code, codeSystemOid: code_system_oid, displayName: display_name)
        }
      }
    }
    return nil
  }
  
  class func extract_codes(parent_element: XMLElement, code_xpath: String) -> CDAKCodedEntries? {
    let code_elements = parent_element.xpath(code_xpath)
    if code_elements.count > 0 {
      var codes = CDAKCodedEntries()
      let code_elements = parent_element.xpath(code_xpath)
      for code_element in code_elements {
        codes.addCodes(extract_code(code_element, code_xpath: "."))
        let translations = code_element.xpath("cda:translation")
        for translation in translations {
          extract_code(translation, code_xpath: ".")
        }
      }
      return codes
    }
    return nil
  }

  
  
  //Revised - with fixed CDAKValueAndUnit type
  func extract_scalar(parent_element: XMLElement, scalar_xpath: String) -> CDAKValueAndUnit? {
    if let scalar_element = parent_element.xpath(scalar_xpath).first {
      //had to change htis from the original version a bit
      // we can have doseQuantity, for example, that only has a value and NOT a unit
      // EX: <doseQuantity value="2"/>
      let unit = scalar_element["unit"]
      let value = scalar_element["value"]
      if value != nil || unit != nil {
        var scalar: CDAKValueAndUnit = CDAKValueAndUnit()
        if let unit = unit {
          scalar.unit = unit
        }
        if let value = value, value_as_float = Double(value) {
          scalar.value = value_as_float
        }
        return scalar
      }
    }
    return nil
  }
  
}

