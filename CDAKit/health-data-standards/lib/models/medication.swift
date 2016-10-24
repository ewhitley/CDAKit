//
//  medication.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

/**
Medication
*/
open class CDAKMedication: CDAKEntry {
  
  // MARK: CDA properties

  ///Timing of medication administration
  open var administration_timing: CDAKMedicationAdministrationTiming = CDAKMedicationAdministrationTiming()
  ///Free text signature or text
  open var free_text_sig: String?
  ///Dosage information (doseQuantity)
  open var dose = CDAKValueAndUnit()
  ///Rate information (rateQuantity)
  open var rate = CDAKValueAndUnit()
  
  ///Type of medication
  open var type_of_medication: CDAKCodedEntries = CDAKCodedEntries()  // as: :type_of_medication  // type: Hash
  ///Status of medication
  open var status_of_medication: CDAKCodedEntries = CDAKCodedEntries()  // as: :status_of_medication  // type: Hash
  ///Fulfillment history (multiple possible)
  open var fulfillment_history = [CDAKFulfillmentHistory]()  // class_name: 'CDAKFulfillmentHistory'
  ///Order information (multiplepossible)
  open var order_information = [CDAKOrderInformation]()  // class_name: 'CDAKOrderInformation'
  
  ///Route of administration
  open var route: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Anatomical approach
  open var anatomical_approach: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  
  //go take a look at the CDA CDAKMedication importer - it appears this is a hash of numerator / denominator entries that then have futher scalar value entries inside
  // not entirely clear what we'd really do with these except for far more complex inpatient examples
  ///Dosage restriction
  open var dose_restriction: CDAKMedicationRestriction = CDAKMedicationRestriction()
  
  ///Fulfillment instructions (if supplied)
  open var fulfillment_instructions: String?  // as: :fulfillment_instructions  // type: String
  /**
  Indication
  This is the problem that was the reason for the medication
  
  - Version 1.0: This was a CDAKCodedEntries
  - Version 1.0.1: This is now a full Entry.  It contains a full problem, including dates, codes, etc.
  */
  open var indication: CDAKEntryDetail?  // type: Hash
  ///Precondition
  open var precondition: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Product form
  open var product_form: CDAKCodedEntries = CDAKCodedEntries()  // as: :product_form  // type: Hash
  ///Product vehicle
  open var vehicle: CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///Reaction to medication or administration
  open var reaction: CDAKEntryDetail?//CDAKCodedEntries = CDAKCodedEntries()  // type: Hash
  ///severity
  open var severity: CDAKEntryDetail?// = CDAKCodedEntries() //flat code list

  ///Delivery method
  open var delivery_method: CDAKCodedEntries = CDAKCodedEntries()  // as: :delivery_method  // type: Hash
  ///Patient instructions
  open var patient_instructions: String?  // as: :patient_instructions  // type: String
  ///Dose indicator
  open var dose_indicator: String?  // as: :dose_indicator  // type: String
  ///method
  open var method: CDAKCodedEntries = CDAKCodedEntries()   //   type: Hash
  ///Date as of which medication was active
  open var active_datetime: Double?   //  type: Integer
  ///Date medication signed
  open var signed_datetime: Double?   //  type: Integer
  
  
  

  /**
    There are currently no importers that support this field.
    It is expected to be a scalar and value   such as 7 days
  
    Refer to CMS guidelines on calculating cumulative duration. This can be complex if you are representing administration with multiple starts and stops over a long inpatient encounnter.
  
    "scalar": 3,
    "unit": "d"
  
    [Discussion](https://jira.oncprojectracking.org/browse/CQM-612)
  
  */
  open var cumulativeMedicationDuration: CDAKValueAndUnit? // = [String:String]()

  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(_ date_diff: Double) {
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
  // MARK: - Mustache marshalling
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
//    vals["type"] = Box(self.type)

    if fulfillment_history.count > 0 { vals["fulfillment_history"] = Box(fulfillment_history.map({Box($0)})) }
    if order_information.count > 0 { vals["order_information"] = Box(order_information.map({Box($0)})) }
    if let cumulativeMedicationDuration = cumulativeMedicationDuration {
      vals["cumulativeMedicationDuration"] = Box(cumulativeMedicationDuration)
    }
    
    if anatomical_approach.count > 0 { vals["anatomical_approach"] = Box(anatomical_approach.codes.map({Box($0)})) }
    if delivery_method.count > 0 { vals["delivery_method"] = Box(delivery_method.codes.map({Box($0)})) }
    if let indication = indication {
      vals["indication"] = Box(indication)
    }
    //if precondition.count > 0 { vals["precondition"] = Box(precondition.codes.map({Box($0)})) }
    
    if precondition.count > 0 {
      vals["precondition"] = Box(precondition.boxedPreferredAndTranslatedCodes)
    }
    
    if method.count > 0 { vals["method"] = Box(method.codes.map({Box($0)})) }
    if product_form.count > 0 { vals["product_form"] = Box(product_form.codes.map({Box($0)})) }
    //if reaction.count > 0 { vals["reaction"] = Box(reaction.codes.map({Box($0)})) }
    if let reaction = reaction {
      vals["reaction"] = Box(reaction)
    }
    if let severity = severity {
      vals["severity"] = Box(severity)
    }
    if route.count > 0 { vals["route"] = Box(route.codes.map({Box($0)})) }
    if status_of_medication.count > 0 { vals["status_of_medication"] = Box(status_of_medication.codes.map({Box($0)})) }
    if type_of_medication.count > 0 { vals["type_of_medication"] = Box(type_of_medication.codes.map({Box($0)})) }
    if vehicle.count > 0 { vals["vehicle"] = Box(vehicle.codes.map({Box($0)})) }
    
    if administration_timing.period.value != nil {
      vals["administration_timing"] = Box(administration_timing)
    }
    vals["dose_restriction"] = Box(dose_restriction)
    vals["dose"] = Box(dose)
    vals["rate"] = Box(rate)
    
    if let active_datetime = active_datetime { vals["active_datetime"] = Box(active_datetime) }
    if let signed_datetime = signed_datetime { vals["signed_datetime"] = Box(signed_datetime) }
    if let dose_indicator = dose_indicator { vals["dose_indicator"] = Box(dose_indicator) }
    if let free_text_sig = free_text_sig { vals["free_text_sig"] = Box(free_text_sig) }
    if let fulfillment_instructions = fulfillment_instructions { vals["fulfillment_instructions"] = Box(fulfillment_instructions) }
    if let patient_instructions = patient_instructions { vals["patient_instructions"] = Box(patient_instructions) }
    
    return vals
  }
}


extension CDAKMedication {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if fulfillment_history.count > 0 { dict["fulfillment_history"] = fulfillment_history.map({$0.jsonDict}) as AnyObject? }
    if order_information.count > 0 { dict["order_information"] = order_information.map({$0.jsonDict})  as AnyObject?}
    if let cumulativeMedicationDuration = cumulativeMedicationDuration {
      dict["cumulativeMedicationDuration"] = cumulativeMedicationDuration.jsonDict as AnyObject?
    }
    
    if anatomical_approach.count > 0 { dict["anatomical_approach"] = anatomical_approach.codes.map({$0.jsonDict})  as AnyObject?}
    if delivery_method.count > 0 { dict["delivery_method"] = delivery_method.codes.map({$0.jsonDict})  as AnyObject?}
    if let indication = indication {
      dict["indication"] = indication.jsonDict as AnyObject?
    }
    if precondition.count > 0 { dict["precondition"] = precondition.codes.map({$0.jsonDict}) as AnyObject? }
    if method.count > 0 { dict["method"] = method.codes.map({$0.jsonDict}) as AnyObject? }
    if product_form.count > 0 { dict["product_form"] = product_form.codes.map({$0.jsonDict}) as AnyObject? }
    //if reaction.count > 0 { dict["reaction"] = reaction.codes.map({$0.jsonDict}) }
    if let reaction = reaction {
      dict["reaction"] = reaction.jsonDict as AnyObject?
    }
    if let severity = severity {
      dict["severity"] = severity.jsonDict as AnyObject?
    }
    
    if route.count > 0 { dict["route"] = route.codes.map({$0.jsonDict}) as AnyObject? }
    if status_of_medication.count > 0 { dict["status_of_medication"] = status_of_medication.codes.map({$0.jsonDict}) as AnyObject? }
    if type_of_medication.count > 0 { dict["type_of_medication"] = type_of_medication.codes.map({$0.jsonDict}) as AnyObject? }
    if vehicle.count > 0 { dict["vehicle"] = vehicle.codes.map({$0.jsonDict}) as AnyObject? }

    if administration_timing.jsonDict.count > 0 { dict["administration_timing"] = administration_timing.jsonDict as AnyObject? }
    if dose_restriction.jsonDict.count > 0 { dict["dose_restriction"] = dose_restriction.jsonDict as AnyObject? }
    if dose.jsonDict.count > 0 { dict["dose"] = dose.jsonDict as AnyObject? }
    if rate.jsonDict.count > 0 { dict["rate"] = rate.jsonDict as AnyObject? }
    
    if let active_datetime = active_datetime { dict["active_datetime"] = active_datetime as AnyObject? }
    if let signed_datetime = signed_datetime { dict["signed_datetime"] = signed_datetime as AnyObject? }
    if let dose_indicator = dose_indicator { dict["dose_indicator"] = dose_indicator as AnyObject? }
    if let free_text_sig = free_text_sig { dict["free_text_sig"] = free_text_sig as AnyObject? }
    if let fulfillment_instructions = fulfillment_instructions { dict["fulfillment_instructions"] = fulfillment_instructions as AnyObject? }
    if let patient_instructions = patient_instructions { dict["patient_instructions"] = patient_instructions as AnyObject? }
    
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


extension CDAKMedicationRestriction: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    var vals : [String:MustacheBox] = [:]
    
    if numerator.value != nil {
      vals["numerator"] = Box(numerator)
    }
    if denominator.value != nil {
      vals["denominator"] = Box(denominator)
    }
    
    return vals
  }
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }

}


// MARK: - JSON Generation
extension CDAKMedicationRestriction: CDAKJSONExportable {
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    if numerator.jsonDict.count > 0 {
      dict["numerator"] = numerator.jsonDict as AnyObject?
    }
    if denominator.jsonDict.count > 0 {
      dict["denominator"] = denominator.jsonDict as AnyObject?
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


extension CDAKMedicationAdministrationTiming: MustacheBoxable {
  // MARK: - Mustache marshalling
  var boxedValues: [String:MustacheBox] {
    var vals : [String:MustacheBox] = [:]
    
    vals["institution_specified"] = Box(institution_specified == true ? "true" : "false")
    vals["period"] = Box(period)
    
    return vals
  }
  public var mustacheBox: MustacheBox {
    return Box(boxedValues)
  }
}

// MARK: - JSON Generation
extension CDAKMedicationAdministrationTiming: CDAKJSONExportable {
  ///Dictionary for JSON data
  public var jsonDict: [String: AnyObject] {
    var dict: [String: AnyObject] = [:]
    
    dict["institution_specified"] = institution_specified as AnyObject?
    if period.jsonDict.count > 0 {
      dict["period"] = period.jsonDict as AnyObject?
    }
    
    return dict
  }
}
