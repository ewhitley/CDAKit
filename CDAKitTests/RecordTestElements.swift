//
//  HDSRecordTestElements.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/7/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

//var test_record_sequence:[String:Int] = [String:Int]()

class TestRecord {
  
  //  func sequence(a_class: AnyObject) -> Int {
  //    var a_class_name = a_class.dynamicType
  //
  //    test_record_sequence = test_record_sequence + 1
  //    return test_record_sequence
  //  }
  
  func allergy(sequence: Int = 1) -> HDSAllergy {
    let _allergy = HDSAllergy()
    _allergy.codes = HDSCodedEntries(entries: ["RxNorm": ["70618"]])
    _allergy.start_time = 1264529050
    _allergy.type = HDSCodedEntries(entries: ["SNOMED-CT": ["416098002"]])
    _allergy.reaction = HDSCodedEntries(entries: ["SNOMED-CT": ["24484000"]])
    _allergy.severity = HDSCodedEntries(entries: ["SNOMED-CT": ["39579001"]])
    return _allergy
  }
  
  func condition(sequence: Int = 1) -> HDSCondition {
    let _condition = HDSCondition()
    _condition.codes = HDSCodedEntries(entries: ["SNOMED-CT": ["16356006"]])
    _condition.cause_of_death = false
    _condition.start_time = 1269776601
    _condition.end_time = 1270776601
    _condition.item_description = "Tobacco user"
    _condition.type = "404684003"
    _condition.oid = "1.2.3.\(sequence)"
    return _condition
  }
  
  func encounter(sequence: Int = 1) -> HDSEncounter {
    let _encounter = HDSEncounter()
    _encounter.codes = HDSCodedEntries(entries: ["CPT": ["16356006"]])
    _encounter.start_time = 1267322332
    _encounter.end_time = 1267323432
    _encounter.admit_type = HDSCodedEntries(entries: ["NUBC": ["12345678"]])
    _encounter.discharge_disposition = HDSCodedEntries(entries: ["NUBC": ["23456789"]])
    _encounter.item_description = "Sample Encounter"
    
    //MARK: FIXME - not sure if the test is bad or I did this incorrectly
    //f.facility { FactoryGirl.build(:organization) }
    //_encounter.facility = organization() //wait... this is an organization?
    _encounter.oid = "1.2.3.\(sequence)"
    return _encounter
  }
  
  func entry(sequence: Int = 1) -> HDSEntry {
    let _entry = HDSEntry()
    _entry.codes = HDSCodedEntries(entries: ["CPT": ["99201"]])
    _entry.start_time = 1267322332
    _entry.end_time = 1267323432
    return _entry
  }
  
  func medical_equipment(sequence: Int = 1) -> HDSMedicalEquipment {
    let _medical_equipment = HDSMedicalEquipment()
    _medical_equipment.codes = HDSCodedEntries(entries: ["SNOMED-CT": ["598721"]])
    _medical_equipment.start_time = 1267322332
    _medical_equipment.end_time = 1267323432
    _medical_equipment.values = [physical_quantity_result_value()]
    
    return _medical_equipment
  }
  
  func support(sequence: Int = 1) -> HDSSupport {
    let _support = HDSSupport()
    _support.given_name = "Bob"
    _support.family_name = "Loblaw"
    _support.relationship = "Brother"
    _support.type = "Guardian"
    _support.address = address()
    _support.telecom = telecom()
    return _support
  }
  
  func orderInformation(sequence: Int = 1) -> HDSOrderInformation {
    let _orderInformation = HDSOrderInformation()
    _orderInformation.order_number = "5"
    _orderInformation.fills = 4
//    _orderInformation.quantity_ordered = ["value" : "500", "unit" : "mg"]
    _orderInformation.quantity_ordered = HDSValueAndUnit(value: 500, unit: "mg")
    _orderInformation.order_date_time = 1267332332
    _orderInformation.order_expiration_date_time = 1267432332
    return _orderInformation
  }
  
  func fulfillment_history(sequence: Int = 1) -> HDSFulfillmentHistory {
    let _fulfillment_history = HDSFulfillmentHistory()
    _fulfillment_history.prescription_number = "B324"
    _fulfillment_history.dispense_date = 1267332349
//    _fulfillment_history.quantity_dispensed = ["value" : "200", "unit" : "pills"]
    _fulfillment_history.quantity_dispensed = HDSValueAndUnit(value: 200, unit: "pills")
    _fulfillment_history.fill_number = 1
    _fulfillment_history.fill_status = "aborted"
    return _fulfillment_history
  }
  
  func organization(sequence: Int = 1) -> HDSOrganization {
    let _organization = HDSOrganization()
    _organization.name = "Doctor Worm & Associates"
    return _organization
  }
  
  func address(sequence: Int = 1) -> HDSAddress {
    let _address = HDSAddress()
    _address.street = ["\(sequence) Sesame Street", "Apt \(sequence)"]
    _address.city = "Bedford"
    _address.state = "MA"
    _address.zip = "01730"
    return _address
  }
  
  func telecom(sequence: Int = 1) -> HDSTelecom {
    let _telecom = HDSTelecom()
    _telecom.value = String(18005555555 + sequence)
    _telecom.use = ["fax", "phone", "mobile"].randomItem()
    _telecom.preferred = [true, false].randomItem()!
    return _telecom
  }
  
  //is this not supposed to be of type "HDSEntry" ?  Maybe "HDSCondition" ?
  func social_history(sequence: Int = 1) -> HDSEntry {
    let _social_history = HDSEntry()
    //_social_history.type = ["SNOMED-CT": ["398705004"]] //ok, this doesn't appear to be anywhere
    //the code does seem to state pretty clearly that this is an "HDSEntry"
    // I'm going to assume I've either botched HDSEntry or this test case dat isn't valid
    // I can't find any refernce to this ever being utilized
    _social_history.codes = HDSCodedEntries(entries: ["SNOMED-CT": ["398705004"]])
    return _social_history
  }
  
  func advance_directive(sequence: Int = 1) -> HDSEntry {
    let _advance_directive = HDSEntry()
    _advance_directive.codes = HDSCodedEntries(entries: ["SNOMED-CT": ["4234322"]])
    
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
  
  func immunization(sequence: Int = 1) -> HDSImmunization {
    let _immunization = HDSImmunization()
    _immunization.codes = HDSCodedEntries(entries: ["RxNorm": ["854931"]])
    _immunization.time = 1264529050
    _immunization.item_description = "Pneumonia Vaccine"
    _immunization.refusal_ind = true
    _immunization.refusal_reason = HDSCodedEntries(entries: ["HL7 ActNoImmunicationReason": ["RELIG"]])
    _immunization.series_number = 1
    
    return _immunization
  }
  
  func lab_result(sequence: Int = 1) -> HDSLabResult {
    let _lab_result = HDSLabResult()
    return _lab_result
  }
  
  
  func medication(sequence: Int = 1) -> HDSMedication {
    let _medication = HDSMedication()
    _medication.codes = HDSCodedEntries(entries: ["RxNorm" : ["105075"]])
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
    _medication.type_of_medication = HDSCodedEntries(entries: ["SNOMED-CT" : ["12345"]])
    _medication.status_of_medication = HDSCodedEntries(entries: ["SNOMED-CT" : ["12345"]])
    _medication.route = HDSCodedEntries(entries: ["NCI Thesaurus" : ["12345"]])
    _medication.anatomical_approach = HDSCodedEntries(entries: ["SNOMED-CT" : ["12345"]])
    
    //NOTE - I can't imagine how this would work - the restrictions appear to be in the form of high/low
    // refer back to the C32 example (only one I can find)
//    _medication.dose_restriction = HDSCodedEntries(entries: ["RxNorm" : ["12345"]])
    _medication.fulfillment_instructions = "Fulfillment Instructions"
    _medication.indication = HDSCodedEntries(entries: ["SNOMED-CT" : ["12345"]])
    _medication.vehicle = HDSCodedEntries(entries: ["SNOMED-CT" : ["12345"]])
    _medication.reaction = HDSCodedEntries(entries: ["RxNorm" : ["12345"]])
    _medication.product_form = HDSCodedEntries(entries: ["FDA" : ["12345"]])
    _medication.delivery_method = HDSCodedEntries(entries: ["RxNorm" : ["12345"]])
    _medication.patient_instructions = "Take with Water"
    _medication.fulfillment_history = [fulfillment_history()]
    _medication.order_information = [orderInformation()]
    
    return _medication
  }
  
  func order_information(sequence: Int = 1) -> HDSOrderInformation {
    let _order_information = HDSOrderInformation()
    return _order_information
  }
  
  func physical_quantity_result_value() -> HDSPhysicalQuantityResultValue {
    let _physical_quantity_result_value = HDSPhysicalQuantityResultValue(scalar: "5", units: "Strips")
    return _physical_quantity_result_value
  }
  
  func procedure(sequence: Int = 1) -> HDSProcedure {
    let _procedure = HDSProcedure()
    _procedure.codes = HDSCodedEntries(entries: ["SNOMED-CT" : ["171055003"]])
    _procedure.start_time = 1257901150
    _procedure.end_time  = 1258901150
    _procedure.anatomical_target = HDSCodedEntries(entries: ["SNOMED-CT" : ["12341234"]])
    
    return _procedure
  }
  
  func record(sequence: Int = 1) -> HDSRecord {
    let _record = HDSRecord()
    _record.encounters = [encounter()]
    
    return _record
  }
  
  func bigger_record(sequence: Int = 1) -> HDSRecord {
    let _bigger_record = HDSRecord()
    for x in 1...3 {
      _bigger_record.encounters.append(encounter(x))
    }
    for x in 1...3 {
      _bigger_record.conditions.append(condition(x))
    }
    
    return _bigger_record
  }
  
  func vital_sign(sequence: Int = 1) -> HDSVitalSign {
    let _vital_sign = HDSVitalSign()
    _vital_sign.codes = HDSCodedEntries(entries: ["SNOMED-CT" : ["225171007"]])
    _vital_sign.time = 1266664414
    _vital_sign.item_description = "BMI"
    
    return _vital_sign
  }
  
  func link_info(sequence: Int = 1) -> HDSMetadataLinkInfo {
    let _link_info = HDSMetadataLinkInfo()
    _link_info.href = "http://t1.x.y.com"
    _link_info.extension_id = "abc"
    
    return _link_info
  }
  
  
  func pedigree(sequence: Int = 1) -> HDSMetadataPedigree {
    let _pedigree = HDSMetadataPedigree()
    _pedigree.author = author()
    _pedigree.organization = "Health Care Inc"
    
    return _pedigree
  }
  
  func author(sequence: Int = 1) -> HDSMetadataAuthor {
    let _author = HDSMetadataAuthor()
    _author.name = "John Smith"
    
    return _author
  }
  
  func metadata(sequence: Int = 1) -> HDSMetadataBase {
    let _metadata = HDSMetadataBase()
    _metadata.original_creation_time = NSDate()//Int(NSNumber(double: (NSDate().timeIntervalSince1970)))
    _metadata.pedigrees = [pedigree()]
    _metadata.linked_documents = [link_info()]
    _metadata.confidentiality = "<hmd:a>text</hmd:a><hmd:c>embedded element</hmd:c>"
    
    return _metadata
  }
  
}