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
public class CDAKInsuranceProvider: CDAKEntry {

  // MARK: CDA properties

  ///Payer (insurance provider)
  public var payer: CDAKOrganization? //, class_name: "CDAKOrganization"
  ///Insurance guarantor
  public var guarantors = [CDAKGuarantor]()//, class_name: "CDAKGuarantor"
  ///Insurance subscriber
  public var subscriber: CDAKPerson? //, class_name: "CDAKPerson"
  
  ///Type
  public var type: String?
  ///Member ID
  public var member_id: String?
  ///Relationship
  public var relationship : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  ///Financial responsibility type
  public var financial_responsibility_type : CDAKCodedEntries = CDAKCodedEntries() //, type: Hash
  ///Name
  public var name: String?
  
  // MARK: Health-Data-Standards Functions
  ///Offset all dates by specified double
  override func shift_dates(date_diff: Double) {
    super.shift_dates(date_diff)

    for g in guarantors {
      g.shift_dates(date_diff)
    }
  }
  
  // MARK: Standard properties
  ///Debugging description
  override public var description: String {
    return super.description + ", name: \(name), type: \(type), member_id: \(member_id), relationship: \(relationship), financial_responsibility_type: \(financial_responsibility_type), financial_responsibility_type: \(financial_responsibility_type), payer: \(payer), guarantors: \(guarantors), subscriber: \(subscriber)"
  }

  
}

extension CDAKInsuranceProvider {
  // MARK: - JSON Generation
  ///Dictionary for JSON data
  override public var jsonDict: [String: AnyObject] {
    var dict = super.jsonDict
    
    if let payer = payer {
      dict["payer"] = payer.jsonDict
    }
    if guarantors.count > 0 {
      dict["guarantors"] = guarantors.map({$0.jsonDict})
    }
    if let type = type {
      dict["type"] = type
    }
    if let member_id = member_id {
      dict["member_id"] = member_id
    }
    if relationship.count > 0 {
      dict["relationship"] = relationship.codes.map({$0.jsonDict})
    }
    if financial_responsibility_type.count > 0 {
      dict["financial_responsibility_type"] = financial_responsibility_type.codes.map({$0.jsonDict})
    }
    if let name = name {
      dict["name"] = name
    }

    return dict
  }
}