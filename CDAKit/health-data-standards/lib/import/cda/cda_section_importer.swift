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

class HDSImport_CDA_SectionImporter {
  
  var entry_finder: HDSImport_CDA_EntryFinder
  var code_xpath = "./cda:code"
  var id_xpath = "./cda:id"
  var status_xpath: String?
  var priority_xpath: String?
  var description_xpath = "./cda:code/cda:originalText/cda:reference[@value] | ./cda:text/cda:reference[@value]"
  var check_for_usable: Bool = false
  var entry_class = HDSEntry.self
  var value_xpath: String? = "cda:value"
  
  init(entry_finder: HDSImport_CDA_EntryFinder) {
    self.entry_finder = entry_finder
    check_for_usable = true
  }
  

  //# Traverses an HL7 CDA document passed in and creates an Array of HDSEntry
  //# objects based on what it finds
  //# @param [Nokogiri::XML::Document] doc It is expected that the root node of this document
  //#        will have the "cda" namespace registered to "urn:hl7-org:v3"
  //#        measure definition
  //# @return [Array] will be a list of HDSEntry objects
  func create_entries(doc: XMLDocument, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> [HDSEntry] {

    var entry_list: [HDSEntry] = []
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

  
  func create_entry(entry_element: XMLElement, nrh: HDSImport_CDA_NarrativeReferenceHandler = HDSImport_CDA_NarrativeReferenceHandler()) -> HDSEntry? {
    
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

  

  

  func extract_description(parent_element: XMLElement, entry: HDSEntry, nrh: HDSImport_CDA_NarrativeReferenceHandler) {
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

  func extract_status(parent_element: XMLElement, entry: HDSEntry) {
    if let status_xpath = status_xpath, status_element = parent_element.xpath(status_xpath).first {
      if let code_system_oid = status_element["codeSystem"], code = status_element["code"]{
        if let codeSystemName = status_element["codeSystemName"] {
          HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
        }
        let codeSystem = HDSCodeSystemHelper.code_system_for(code_system_oid)
        entry.status_code = HDSCodedEntries(entries: [codeSystem:[code]])
      }
    }
  }

  func extract_id(parent_element: XMLElement, entry: HDSEntry) {
    if let id_element = parent_element.xpath(id_xpath).first {
      let identifier = HDSCDAIdentifier()
      identifier.root = id_element["root"]
      identifier.extension_id = id_element["extension"]
      entry.cda_identifier = identifier
    }
  }

  func extract_reason_description(parent_element: XMLElement, entry: HDSEntry, nrh: HDSImport_CDA_NarrativeReferenceHandler) {
    let code_elements = parent_element.xpath(description_xpath)
    for code_element in code_elements {
      if let tag = code_element["value"] {
        entry.item_description = nrh.lookup_tag(tag)
      }
    }
  }

  func extract_codes(parent_element: XMLElement, entry: HDSThingWithCodes) {
    let code_elements = parent_element.xpath(code_xpath)
    for code_element in code_elements {
      add_code_if_present(code_element, entry: entry)
      let translations = code_element.xpath("cda:translation")
      for translation in translations {
        add_code_if_present(translation, entry: entry)
      }
    }
  }

  func add_code_if_present(code_element: XMLElement, entry: HDSThingWithCodes) {
    if let code_system_oid = code_element["codeSystem"], code = code_element["code"] {
      let display_name = code_element["displayName"]
      if let codeSystemName = code_element["codeSystemName"] {
        HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
      }
      entry.add_code(code, code_system: HDSCodeSystemHelper.code_system_for(code_system_oid), code_system_oid: code_system_oid, display_name: display_name)
    }
  }

  func extract_dates(parent_element: XMLElement, entry: HDSThingWithTimes, element_name: String = "effectiveTime") {
    if let elem = parent_element.xpath("cda:\(element_name)/@value").first {
      entry.time = HL7Helper.timestamp_to_integer(elem.stringValue)
    }
    if let elem = parent_element.xpath("cda:\(element_name)/cda:low").first {
      entry.start_time = HL7Helper.timestamp_to_integer(elem["value"])
    }
    if let elem = parent_element.xpath("cda:\(element_name)/cda:high").first {
      entry.end_time = HL7Helper.timestamp_to_integer(elem["value"])
    }
    if let elem = parent_element.xpath("cda:\(element_name)/cda:center").first {
      entry.time = HL7Helper.timestamp_to_integer(elem["value"])
    }
  }

  func extract_values(parent_element: XMLElement, entry: HDSEntry) {
    if let value_xpath = value_xpath {
      for elem in parent_element.xpath(value_xpath) {
        extract_value(parent_element, value_element: elem, entry: entry)
      }
    }
  }

  //MARK: FIXME - I had to comment some of this out...
  // not the type I was expecting
  func extract_value(parent_element: XMLElement, value_element: XMLElement?, entry: HDSEntry) {
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
        let crv = HDSCodedResultValue()
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

  func import_actor(actor_element: XMLElement) -> HDSProvider {
    return HDSImport_ProviderImportUtils.extract_provider(actor_element)
  }

  func import_organization(organization_element: XMLElement) -> HDSOrganization? {
    return HDSImport_CDA_OrganizationImporter.extract_organization(organization_element)
  }

  
  func import_person(person_element: XMLElement?) -> HDSPerson? {
    
    guard let person_element = person_element else {
      return nil
    }
    let person = HDSPerson()
    if let name_element = person_element.xpath("./cda:name").first {
      person.title = name_element.xpath("./cda:title").first?.stringValue
      person.given_name = name_element.xpath("./cda:given").first?.stringValue
      person.family_name = name_element.xpath("./cda:family").first?.stringValue
    }
    person.addresses = person_element.xpath("./cda:addr").map { addr in HDSImport_CDA_LocatableImportUtils.import_address(addr) }
    person.telecoms = person_element.xpath("./cda:telecom").map { tele in HDSImport_CDA_LocatableImportUtils.import_telecom(tele) }
    return person
  }

  //NOTE: does not appear to pull translations
  func extract_negation(parent_element: XMLElement, entry: HDSEntry) {
    if let negation_indicator = parent_element["negationInd"] {
      entry.negation_ind = negation_indicator.lowercaseString == "true"
      if entry.negation_ind == true {
        if let negation_reason_element = parent_element.xpath("./cda:entryRelationship[@typeCode='RSON']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.24.3.88']/cda:value | ./cda:entryRelationship[@typeCode='RSON']/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:code").first {
          //so apparently we're not pulling the translations, etc.?
          if let code_system_oid = negation_reason_element["codeSystem"], let code = negation_reason_element["code"] {
            if let codeSystemName = negation_reason_element["codeSystemName"] {
              HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
            }

            let code_system = HDSCodeSystemHelper.code_system_for(code_system_oid)
            //entry.negation_reason = ["code" : code, "code_system" : code_system]
            entry.negation_reason = HDSCodedEntries(entries: [code_system:[code]])
          }
        }
      }
    }
  }
  
  //modified version - changing this to return a coded entry directly
  func extract_code(parent_element: XMLElement, code_xpath: String, code_system: String? = nil) -> HDSCodedEntry? {
    let code_element = parent_element.xpath(code_xpath).first
    var coded_entry: HDSCodedEntry?
    
    if let code_element = code_element, code = code_element["code"] {
      let display_name = code_element["displayName"]
      if let code_system = code_system {
        coded_entry = HDSCodedEntry(codeSystem: code_system, codes: code, displayName: display_name)
      } else if let code_system_oid = code_element["codeSystem"] {
        //apparently in this case we get an OID instead of a codesystem name/key
        if let codeSystemName = code_element["codeSystemName"] {
          HDSCodeSystemHelper.addCodeSystem(codeSystemName, oid: code_system_oid)
        }

        coded_entry = HDSCodedEntry(codeSystem: HDSCodeSystemHelper.code_system_for(code_system_oid), codes: code, codeSystemOid: code_system_oid, displayName: display_name)
      }
    }
    
    return coded_entry
  }
  
  //Revised - with fixed HDSValueAndUnit type
  func extract_scalar(parent_element: XMLElement, scalar_xpath: String) -> HDSValueAndUnit? {
    if let scalar_element = parent_element.xpath(scalar_xpath).first {
      //had to change htis from the original version a bit
      // we can have doseQuantity, for example, that only has a value and NOT a unit
      // EX: <doseQuantity value="2"/>
      let unit = scalar_element["unit"]
      let value = scalar_element["value"]
      if value != nil || unit != nil {
        var scalar: HDSValueAndUnit = HDSValueAndUnit()
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

