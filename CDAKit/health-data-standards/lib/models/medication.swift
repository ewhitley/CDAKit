//
//  medication.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation

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
  
  public struct CDAKMedicationRestriction {
    var numerator: CDAKValueAndUnit = CDAKValueAndUnit()
    var denominator: CDAKValueAndUnit = CDAKValueAndUnit()
  }
  
  public struct CDAKMedicationAdministrationTiming {
    var institution_specified: Bool = false
    var period: CDAKValueAndUnit = CDAKValueAndUnit()
    //var period: Int? // only example I have shows this as an Int - probably need to check spec
  }
  
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