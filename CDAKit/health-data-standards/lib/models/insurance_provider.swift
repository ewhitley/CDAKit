//
//  medication.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/2/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import Foundation
/**
Insurance Provider
*/
open class CDAKInsuranceProvider: CDAKEntry {

  // MARK: CDA properties

  ///Payer (insurance provider)
  open var payer: CDAKOrganization? //, class_name: "CDAKOrganization"
  ///Insurance guarantor
  open var guarantors = [CDAKGuarantor]()//, class_name: "CDAKGuarantor"
  ///Insurance subscriber
  open var subscriber: CDAKPerson? //, class_name: "CDAKPerson"
  
  ///Type
  open var type: String?
  ///Member ID
  open var member_id: String?
  ///Relationship
  open var relationship : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  ///Financial responsibility type
  open var financial_responsibility_type : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  ///Name
  open var name: String?
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(_ date_diff: Double) {
    super.shift_dates(date_diff)

    for g in guarantors {
      g.shift_dates(date_diff)
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override open var description: String {
    return super.description + ", name: \(name), type: \(type), member_id: \(member_id), relationship: \(relationship), financial_responsibility_type: \(financial_responsibility_type), financial_responsibility_type: \(financial_responsibility_type), payer: \(payer), guarantors: \(guarantors), subscriber: \(subscriber)"
  }

  
}

extension CDAKInsuranceProvider {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let payer = payer {
      dict["payer"] = payer.jsonDict as AnyObject?
    }
    if guarantors.count > 0 {
      dict["guarantors"] = guarantors.map({$0.jsonDict}) as AnyObject?
    }
    if let type = type {
      dict["type"] = type as AnyObject?
    }
    if let member_id = member_id {
      dict["member_id"] = member_id as AnyObject?
    }
    if relationship.count > 0 {
      dict["relationship"] = relationship.codes.map({$0.jsonDict}) as AnyObject?
    }
    if financial_responsibility_type.count > 0 {
      dict["financial_responsibility_type"] = financial_responsibility_type.codes.map({$0.jsonDict}) as AnyObject?
    }
    if let name = name {
      dict["name"] = name as AnyObject?
    }

    return dict
  }
}
