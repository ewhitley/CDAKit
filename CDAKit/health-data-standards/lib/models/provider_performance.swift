//
//  provider_performance.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/3/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
import Mustache

//NOTE: changing type to CDAKEntry
/**
  Supplies a relationship between a patient and a provider for a particulary start/end date and function.

*/
open class CDAKProviderPerformance: CDAKEntry {


  // MARK: CDA properties

  ///start date for period
  open var start_date: Double?
  ///end date for period
  open var end_date: Double?
  ///provider
  open var provider: CDAKProvider?

  
  /**
   CDA function code
   
   This allows us to determine the clinical function like "Primary Care Physician" if not specifically associated with an entry as a performer.
   
   ```
   <functionCode code="PCP" displayName="Primary Care Physician"
   codeSystem="2.16.840.1.113883.5.88" codeSystemName="participationFunction">
   <originalText>Primary Care Provider</originalText>
   </functionCode>
   ```
   
   This is a complex element due to history and various use.
   
   You can read more about functionCode at the [CDAPro site](http://ushik.ahrq.gov/ViewItemDetails?system=mdr&itemKey=83329000)
   
   Historical C32 codes:
    ---
   
   Code System: "Provider Role" [2.16.840.1.113883.12.443](http://ushik.ahrq.gov/ViewItemDetails?system=mdr&itemKey=83329000)
   
   * PP (Primary Care Provider)
   * CP (Consulting Provider)
   * RP (Referring Provider)

   C-CDA codes:
   ---
   
   Code System: "ParticipationFunction" [2.16.840.1.113883.5.88](http://www.hl7.org/documentcenter/public_temp_29B6E6E3-1C23-BA17-0C7B234C1C2C5A05/standards/vocabulary/vocabulary_tables/infrastructure/vocabulary/ParticipationFunction.html)
   
   Subset of list:
   
   * ADMPHYS (admitting physician)
   * ANEST (anesthesist)
   * ANRS (anesthesia nurse)
   * ATTPHYS (attending physician)
   * DISPHYS (discharging physician)
   * FASST (first assistant surgeon)
   * MDWF (midwife)
   * NASST (nurse assistant)
   * PCP (primary care physician)
   * PRISURG (primary surgeon)
   * RNDPHYS (rounding physician)
   * SASST (second assistant surgeon)
   * SNRS (scrub nurse)
   * TASST (third assistant)

   */
  open var functionCode: CDAKCodedEntry?
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(_ date_diff: Double) {
    super.shift_dates(date_diff)

    if let start_date = start_date {
      self.start_date = start_date + date_diff
    }
    if let end_date = end_date {
      self.end_date = end_date + date_diff
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return "\(type(of: self)) => start_date:\(start_date), end_date:\(end_date), functionCode:\(functionCode), provider:\(provider)"
  }
  
}

extension CDAKProviderPerformance {
  // MARK: - Mustache marshalling
  override var boxedValues: [String:MustacheBox] {
    var vals = super.boxedValues
    
    vals["start_date"] = Box(self.start_date)
    vals["end_date"] = Box(self.end_date)
    vals["performer"] = Box(self.provider)
    vals["functionCode"] = Box(self.functionCode)
    
    return vals
  }
}

extension CDAKProviderPerformance {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let start_date = start_date {
      dict["start_date"] = start_date as AnyObject?
    }
    if let end_date = end_date {
      dict["end_date"] = end_date as AnyObject?
    }
    if let provider = provider {
      dict["provider"] = provider.jsonDict as AnyObject?
    }
    if let functionCode = functionCode {
      dict["functionCode"] = functionCode.jsonDict as AnyObject?
    }
    
    return dict
  }
}
