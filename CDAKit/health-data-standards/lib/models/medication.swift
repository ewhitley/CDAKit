//
//  medication.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

public struct CDAKMedicationRestriction {
  var numerator: CDAKValueAndUnit = CDAKValueAndUnit()
  var denominator: CDAKValueAndUnit = CDAKValueAndUnit()
}

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


public struct CDAKMedicationAdministrationTiming {
  var institution_specified: Bool = false
  var period: CDAKValueAndUnit = CDAKValueAndUnit()
  //var period: Int? // only example I have shows this as an Int - probably need to check spec
}

extension CDAKMedicationAdministrationTiming: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    dict["institution_specified"] = institution_specified
    if period.jsonDict.count > 0 {
      dict["period"] = period.jsonDict
    }
    
    return dict
  }
}


public class CDAKMedication: CDAKEntry {
  public var administration_timing: CDAKMedicationAdministrationTiming = CDAKMedicationAdministrationTiming()
  public var free_text_sig: String?
  public var dose = CDAKValueAndUnit()
  public var type_of_medication: CDAKCodedEntries = CDAKCodedEntries()  // as: :type_of_medication  // type: Hash
  public var status_of_medication: CDAKCodedEntries = CDAKCodedEntries()  // as: :status_of_medication  // type: Hash
  public var fulfillment_history = [CDAKFulfillmentHistory]()  // class_name: 'CDAKFulfillmentHistory'
  public var order_information = [CDAKOrderInformation]()  // class_name: 'CDAKOrderInformation'
  
  public var route: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  public var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  
  //go take a look at the CDA CDAKMedication importer - it appears this is a hash of numerator / denominator entries that then have futher scalar value entries inside
  // not entirely clear what we'd really do with these except for far more complex inpatient examples
  public var dose_restriction: CDAKMedicationRestriction = CDAKMedicationRestriction()
  
  public var fulfillment_instructions: String?  // as: :fulfillment_instructions  // type: String
  public var indication: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  public var product_form: CDAKCodedEntries = CDAKCodedEntries()  // as: :product_form  // type: Hash
  public var vehicle: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  public var reaction: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  public var delivery_method: CDAKCodedEntries = CDAKCodedEntries()  // as: :delivery_method  // type: Hash
  public var patient_instructions: String?  // as: :patient_instructions  // type: String
  public var dose_indicator: String?  // as: :dose_indicator  // type: String
  
  public var method: CDAKCodedEntries = CDAKCodedEntries()   //   type: Hash
  public var active_datetime: Double?   //  type: Integer
  public var signed_datetime: Double?   //  type: Integer
  
  /// There are currently no importers that support this field.
  /// It is expected to be a scalar and value  // such as 7 days
  public var cumulativeMedicationDuration = [String:String]()
  //      "scalar": 3,
  //      "unit": "d"
  
  
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


extension CDAKMedication {
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if fulfillment_history.count > 0 { dict["fulfillment_history"] = fulfillment_history.map({$0.jsonDict}) }
    if order_information.count > 0 { dict["order_information"] = order_information.map({$0.jsonDict}) }
    if cumulativeMedicationDuration.count > 0 { dict["cumulativeMedicationDuration"] = cumulativeMedicationDuration }
    
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