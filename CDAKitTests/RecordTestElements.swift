//
//  CDAKRecordTestElements.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/7/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
@testable import CDAKit


//var test_record_sequence:[String:Int] = [String:Int]()

class TestRecord {
  
  //  func sequence(a_class: AnyObject) -> Int {
  //    var a_class_name = a_class.dynamicType
  //
  //    test_record_sequence = test_record_sequence + 1
  //    return test_record_sequence
  //  }
  
  func allergy(sequence: Int = 1) -> CDAKAllergy {
    let _allergy = CDAKAllergy()
    _allergy.codes = CDAKCodedEntries(codeSystem: "RxNorm", code: "70618")
    _allergy.start_time = 1264529050
    _allergy.type = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "416098002")
    
    _allergy.reaction = CDAKEntryDetail()
    _allergy.reaction?.codes.addCodes("SNOMED-CT", code: "24484000")
    _allergy.severity?.codes.addCodes("SNOMED-CT", code: "39579001")
    
//    _allergy.reaction = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "24484000")
//    _allergy.severity = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "39579001")
    return _allergy
  }
  
  func condition(sequence: Int = 1) -> CDAKCondition {
    let _condition = CDAKCondition()
    _condition.codes = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "16356006")
    _condition.cause_of_death = false
    _condition.start_time = 1269776601
    _condition.end_time = 1270776601
    _condition.item_description = "Tobacco user"
    _condition.type = "404684003"
    _condition.oid = "1.2.3.\(sequence)"
    return _condition
  }
  
  func encounter(sequence: Int = 1) -> CDAKEncounter {
    let _encounter = CDAKEncounter()
    _encounter.codes = CDAKCodedEntries(codeSystem: "CPT", code: "16356006")
    _encounter.start_time = 1267322332
    _encounter.end_time = 1267323432
    _encounter.admit_type = CDAKCodedEntries(codeSystem: "NUBC", code: "12345678")
    _encounter.discharge_disposition = CDAKCodedEntries(codeSystem: "NUBC", code: "23456789")
    _encounter.item_description = "Sample Encounter"
    
    //MARK: FIXME - not sure if the test is bad or I did this incorrectly
    //f.facility { FactoryGirl.build(:organization) }
    //_encounter.facility = organization() //wait... this is an organization?
    _encounter.oid = "1.2.3.\(sequence)"
    return _encounter
  }
  
  func entry(sequence: Int = 1) -> CDAKEntry {
    let _entry = CDAKEntry()
    _entry.codes = CDAKCodedEntries(codeSystem: "CPT", code: "99201")
    _entry.start_time = 1267322332
    _entry.end_time = 1267323432
    return _entry
  }
  
  func medical_equipment(sequence: Int = 1) -> CDAKMedicalEquipment {
    let _medical_equipment = CDAKMedicalEquipment()
    _medical_equipment.codes = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "598721")
    _medical_equipment.start_time = 1267322332
    _medical_equipment.end_time = 1267323432
    _medical_equipment.values = [physical_quantity_result_value()]
    
    return _medical_equipment
  }
  
  func support(sequence: Int = 1) -> CDAKSupport {
    let _support = CDAKSupport()
    _support.given_name = "Bob"
    _support.family_name = "Loblaw"
    _support.relationship = "Brother"
    _support.type = "Guardian"
    _support.address = address()
    _support.telecom = telecom()
    return _support
  }
  
  func orderInformation(sequence: Int = 1) -> CDAKOrderInformation {
    let _orderInformation = CDAKOrderInformation()
    _orderInformation.order_number = "5"
    _orderInformation.fills = 4
//    _orderInformation.quantity_ordered = ["value" : "500", "unit" : "mg"]
    _orderInformation.quantity_ordered = CDAKValueAndUnit(value: 500, unit: "mg")
    _orderInformation.order_date_time = 1267332332
    _orderInformation.order_expiration_date_time = 1267432332
    return _orderInformation
  }
  
  func fulfillment_history(sequence: Int = 1) -> CDAKFulfillmentHistory {
    let _fulfillment_history = CDAKFulfillmentHistory()
    _fulfillment_history.prescription_number = "B324"
    _fulfillment_history.dispense_date = 1267332349
//    _fulfillment_history.quantity_dispensed = ["value" : "200", "unit" : "pills"]
    _fulfillment_history.quantity_dispensed = CDAKValueAndUnit(value: 200, unit: "pills")
    _fulfillment_history.fill_number = 1
    _fulfillment_history.fill_status = "aborted"
    return _fulfillment_history
  }
  
  func organization(sequence: Int = 1) -> CDAKOrganization {
    let _organization = CDAKOrganization()
    _organization.name = "Doctor Worm & Associates"
    return _organization
  }
  
  func address(sequence: Int = 1) -> CDAKAddress {
    let _address = CDAKAddress()
    _address.street = ["\(sequence) Sesame Street", "Apt \(sequence)"]
    _address.city = "Bedford"
    _address.state = "MA"
    _address.zip = "01730"
    return _address
  }
  
  func telecom(sequence: Int = 1) -> CDAKTelecom {
    let _telecom = CDAKTelecom()
    _telecom.value = String(18005555555 + sequence)
    _telecom.use = ["fax", "phone", "mobile"].randomItem()
    _telecom.preferred = [true, false].randomItem()!
    return _telecom
  }
  
  //is this not supposed to be of type "CDAKEntry" ?  Maybe "CDAKCondition" ?
  func social_history(sequence: Int = 1) -> CDAKEntry {
    let _social_history = CDAKEntry()
    //_social_history.type = ["SNOMED-CT": ["398705004"]] //ok, this doesn't appear to be anywhere
    //the code does seem to state pretty clearly that this is an "CDAKEntry"
    // I'm going to assume I've either botched CDAKEntry or this test case dat isn't valid
    // I can't find any refernce to this ever being utilized
    _social_history.codes = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "398705004")
    return _social_history
  }
  
  func advance_directive(sequence: Int = 1) -> CDAKEntry {
    let _advance_directive = CDAKEntry()
    _advance_directive.codes = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "4234322")
    
    let components: NSDateComponents = NSDateComponents()
    components.setValue(-1, forComponent: NSCalendarUnit.Month)
    let date: NSDate = NSDate()
    let newDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: date, options: NSCalendarOptions(rawValue: 0))
    let month_ago = NSNumber(double: (newDate!.timeIntervalSince1970)).doubleValue
    _advance_directive.start_time = month_ago
    
    _advance_directive.end_time = NSNumber(double: (NSDate().timeIntervalSince1970)).doubleValue
    
    _advance_directive.item_description = "Go insane"
    return _advance_directive
  }
  
  func immunization(sequence: Int = 1) -> CDAKImmunization {
    let _immunization = CDAKImmunization()
    _immunization.codes = CDAKCodedEntries(codeSystem: "RxNorm", code: "854931")
    _immunization.time = 1264529050
    _immunization.item_description = "Pneumonia Vaccine"
    _immunization.refusal_ind = true
    _immunization.refusal_reason = CDAKCodedEntries(codeSystem: "HL7 ActNoImmunicationReason", code: "RELIG")
    _immunization.series_number = 1
    
    return _immunization
  }
  
  func lab_result(sequence: Int = 1) -> CDAKLabResult {
    let _lab_result = CDAKLabResult()
    return _lab_result
  }
  
  
  func medication(sequence: Int = 1) -> CDAKMedication {
    let _medication = CDAKMedication()
    _medication.codes = CDAKCodedEntries(codeSystem: "RxNorm", code: "105075")
    _medication.item_description = "Tobacco Cessation Agent"
    _medication.start_time = 1267332332
    _medication.end_time = 1267333332
    
    //MARK: FIXME - not sure administrationTiming is correct here
    // either way this is going to be painful with the typing
//    _medication.administration_timing["institution_specified"] = true
//    _medication.administration_timing["period"] = ["value":"5.0", "unit":"hours"]
    _medication.administration_timing.institution_specified = true
    _medication.administration_timing.period.value = 5.0// = ["value":"5.0", "unit":"hours"]
    _medication.administration_timing.period.unit = "hours"// = ["value":"5.0", "unit":"hours"]
    
    
    //_medication.dose  = ["scalar":"5", "units":"Strips"]
    _medication.dose.value = 5
    _medication.dose.unit = "Strips"
    
    _medication.status = "complete"
    _medication.type_of_medication = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "12345")
    _medication.status_of_medication = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "12345")
    _medication.route = CDAKCodedEntries(codeSystem: "NCI Thesaurus", code: "12345")
    _medication.anatomical_approach = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "12345")
    
    //NOTE - I can't imagine how this would work - the restrictions appear to be in the form of high/low
    // refer back to the C32 example (only one I can find)
//    _medication.dose_restriction = CDAKCodedEntries(entries: ["RxNorm" : ["12345"]])
    _medication.fulfillment_instructions = "Fulfillment Instructions"
    _medication.indication = CDAKEntryDetail()
    _medication.indication?.codes.addCodes("SNOMED-CT", code: "12345")
//    _medication.indication = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "12345")
    _medication.vehicle = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "12345")
//    _medication.reaction = CDAKCodedEntries(codeSystem: "RxNorm", code: "12345")
    _medication.reaction = CDAKEntryDetail()
    _medication.reaction?.codes.addCodes("RxNorm", code: "12345")
    
    _medication.product_form = CDAKCodedEntries(codeSystem: "FDA", code: "12345")
    _medication.delivery_method = CDAKCodedEntries(codeSystem: "RxNorm", code: "12345")
    _medication.patient_instructions = "Take with Water"
    _medication.fulfillment_history = [fulfillment_history()]
    _medication.order_information = [orderInformation()]
    
    return _medication
  }
  
  func order_information(sequence: Int = 1) -> CDAKOrderInformation {
    let _order_information = CDAKOrderInformation()
    return _order_information
  }
  
  func physical_quantity_result_value() -> CDAKPhysicalQuantityResultValue {
    let _physical_quantity_result_value = CDAKPhysicalQuantityResultValue(scalar: "5", units: "Strips")
    return _physical_quantity_result_value
  }
  
  func procedure(sequence: Int = 1) -> CDAKProcedure {
    let _procedure = CDAKProcedure()
    _procedure.codes = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "171055003")
    _procedure.start_time = 1257901150
    _procedure.end_time  = 1258901150
    _procedure.anatomical_target = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "12341234")
    
    return _procedure
  }
  
  func record(sequence: Int = 1) -> CDAKRecord {
    let _record = CDAKRecord()
    _record.encounters = [encounter()]
    
    return _record
  }
  
  func bigger_record(sequence: Int = 1) -> CDAKRecord {
    let _bigger_record = CDAKRecord()
    for x in 1...3 {
      _bigger_record.encounters.append(encounter(x))
    }
    for x in 1...3 {
      _bigger_record.conditions.append(condition(x))
    }
    
    return _bigger_record
  }
  
  func vital_sign(sequence: Int = 1) -> CDAKVitalSign {
    let _vital_sign = CDAKVitalSign()
    _vital_sign.codes = CDAKCodedEntries(codeSystem: "SNOMED-CT", code: "225171007")
    _vital_sign.time = 1266664414
    _vital_sign.item_description = "BMI"
    
    return _vital_sign
  }
  
  //disabling these, but leaving them here for reference
  // these were the original Ruby HDS metadata tests for Record import
  // In reviewing the code, these weren't really used when handling XML generation, so I opted to remove them and instead replace them with the QRDA I headers.  They should be _identical_.
  /*
  func link_info(sequence: Int = 1) -> CDAKMetadataLinkInfo {
    let _link_info = CDAKMetadataLinkInfo()
    _link_info.href = "http://t1.x.y.com"
    _link_info.extension_id = "abc"
    
    return _link_info
  }
  
  
  func pedigree(sequence: Int = 1) -> CDAKMetadataPedigree {
    let _pedigree = CDAKMetadataPedigree()
    _pedigree.author = author()
    _pedigree.organization = "Health Care Inc"
    
    return _pedigree
  }
  
  func author(sequence: Int = 1) -> CDAKMetadataAuthor {
    let _author = CDAKMetadataAuthor()
    _author.name = "John Smith"
    
    return _author
  }
  
  func metadata(sequence: Int = 1) -> CDAKMetadataBase {
    let _metadata = CDAKMetadataBase()
    _metadata.original_creation_time = NSDate()//Int(NSNumber(double: (NSDate().timeIntervalSince1970)))
    _metadata.pedigrees = [pedigree()]
    _metadata.linked_documents = [link_info()]
    _metadata.confidentiality = "<hmd:a>text</hmd:a><hmd:c>embedded element</hmd:c>"
    
    return _metadata
  }
  */
  
}