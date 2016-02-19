//
//  medication.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation


/**
Medication
*/
public class CDAKMedication: CDAKEntry {
  ///Timing of medication administration
  public var administration_timing: CDAKMedicationAdministrationTiming = CDAKMedicationAdministrationTiming()
  ///Free text signature or text
  public var free_text_sig: String?
  ///Dosage information
  public var dose = CDAKValueAndUnit()
  ///Type of medication
  public var type_of_medication: CDAKCodedEntries = CDAKCodedEntries()  // as: :type_of_medication  // type: Hash
  ///Status of medication
  public var status_of_medication: CDAKCodedEntries = CDAKCodedEntries()  // as: :status_of_medication  // type: Hash
  ///Fulfillment history (multiple possible)
  public var fulfillment_history = [CDAKFulfillmentHistory]()  // class_name: 'CDAKFulfillmentHistory'
  ///Order information (multiplepossible)
  public var order_information = [CDAKOrderInformation]()  // class_name: 'CDAKOrderInformation'
  
  ///Route of administration
  public var route: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Anatomical approach
  public var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  
  //go take a look at the CDA CDAKMedication importer - it appears this is a hash of numerator / denominator entries that then have futher scalar value entries inside
  // not entirely clear what we'd really do with these except for far more complex inpatient examples
  ///Dosage restriction
  public var dose_restriction: CDAKMedicationRestriction = CDAKMedicationRestriction()
  
  ///Fulfillment instructions (if supplied)
  public var fulfillment_instructions: String?  // as: :fulfillment_instructions  // type: String
  ///Indication
  public var indication: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Product form
  public var product_form: CDAKCodedEntries = CDAKCodedEntries()  // as: :product_form  // type: Hash
  ///Product vehicle
  public var vehicle: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Reaction to medication or administration
  public var reaction: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Delivery method
  public var delivery_method: CDAKCodedEntries = CDAKCodedEntries()  // as: :delivery_method  // type: Hash
  ///Patient instructions
  public var patient_instructions: String?  // as: :patient_instructions  // type: String
  ///Dose indicator
  public var dose_indicator: String?  // as: :dose_indicator  // type: String
  ///method
  public var method: CDAKCodedEntries = CDAKCodedEntries()   //   type: Hash
  ///Date as of which medication was active
  public var active_datetime: Double?   //  type: Integer
  ///Date medication signed
  public var signed_datetime: Double?   //  type: Integer
  

  /**
    There are currently no importers that support this field.
    It is expected to be a scalar and value   such as 7 days
  
    Refer to CMS guidelines on calculating cumulative duration. This can be complex if you are representing administration with multiple starts and stops over a long inpatient encounnter.
  
    "scalar": 3,
    "unit": "d"
  
    [Discussion](https://jira.oncprojectracking.org/browse/CQM-612)
  
  */
  public var cumulativeMedicationDuration: CDAKValueAndUnit? // = [String:String]()

  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    for fh in fulfillment_history {
      fh.shift_dates(date_diff)
    }

    for oi in order_information {
      oi.shift_dates(date_diff)
    }
    
  }  
}

// MARK: - JSON Generation
extension CDAKMedication {
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if fulfillment_history.count > 0 { dict["fulfillment_history"] = fulfillment_history.map({$0.jsonDict}) }
    if order_information.count > 0 { dict["order_information"] = order_information.map({$0.jsonDict}) }
    if let cumulativeMedicationDuration = cumulativeMedicationDuration {
      dict["cumulativeMedicationDuration"] = cumulativeMedicationDuration.jsonDict
    }
    
    if anatomical_approach.count > 0 { dict["anatomical_approach"] = anatomical_approach.codes.map({$0.jsonDict}) }
    if delivery_method.count > 0 { dict["delivery_method"] = delivery_method.codes.map({$0.jsonDict}) }
    if indication.count > 0 { dict["indication"] = indication.codes.map({$0.jsonDict}) }
    if method.count > 0 { dict["method"] = method.codes.map({$0.jsonDict}) }
    if product_form.count > 0 { dict["product_form"] = product_form.codes.map({$0.jsonDict}) }
    if reaction.count > 0 { dict["reaction"] = reaction.codes.map({$0.jsonDict}) }
    if route.count > 0 { dict["route"] = route.codes.map({$0.jsonDict}) }
    if status_of_medication.count > 0 { dict["status_of_medication"] = status_of_medication.codes.map({$0.jsonDict}) }
    if type_of_medication.count > 0 { dict["type_of_medication"] = type_of_medication.codes.map({$0.jsonDict}) }
    if vehicle.count > 0 { dict["vehicle"] = vehicle.codes.map({$0.jsonDict}) }

    if administration_timing.jsonDict.count > 0 { dict["administration_timing"] = administration_timing.jsonDict }
    if dose_restriction.jsonDict.count > 0 { dict["dose_restriction"] = dose_restriction.jsonDict }
    if dose.jsonDict.count > 0 { dict["dose"] = dose.jsonDict }
    
    if let active_datetime = active_datetime { dict["active_datetime"] = active_datetime }
    if let signed_datetime = signed_datetime { dict["signed_datetime"] = signed_datetime }
    if let dose_indicator = dose_indicator { dict["dose_indicator"] = dose_indicator }
    if let free_text_sig = free_text_sig { dict["free_text_sig"] = free_text_sig }
    if let fulfillment_instructions = fulfillment_instructions { dict["fulfillment_instructions"] = fulfillment_instructions }
    if let patient_instructions = patient_instructions { dict["patient_instructions"] = patient_instructions }
    
    return dict
  }
}

// MARK: - Supporting structs - medication restriction

///Medication restriction
public struct CDAKMedicationRestriction {
  ///numerator
  var numerator: CDAKValueAndUnit = CDAKValueAndUnit()
  ///denominator
  var denominator: CDAKValueAndUnit = CDAKValueAndUnit()
}

// MARK: - JSON Generation
extension CDAKMedicationRestriction: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if numerator.jsonDict.count > 0 {
      dict["numerator"] = numerator.jsonDict
    }
    if denominator.jsonDict.count > 0 {
      dict["denominator"] = denominator.jsonDict
    }
    
    return dict
  }
}

// MARK: - Supporting structs - medication administration timing
///Medication administration timing
public struct CDAKMedicationAdministrationTiming {
  ///Instition specified indicator
  var institution_specified: Bool = false
  ///Period
  var period: CDAKValueAndUnit = CDAKValueAndUnit()
  //var period: Int? // only example I have shows this as an Int - probably need to check spec
}

// MARK: - JSON Generation
extension CDAKMedicationAdministrationTiming: CDAKJSONExportable {
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    dict["institution_specified"] = institution_specified
    if period.jsonDict.count > 0 {
      dict["period"] = period.jsonDict
    }
    
    return dict
  }
}
