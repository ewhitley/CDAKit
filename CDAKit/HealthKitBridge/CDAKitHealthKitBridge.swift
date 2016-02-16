//
//  CDAKHealthKitBridge.swift
//  CDAKit
//
//  Created by Eric Whitley on 1/26/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//
//  Refer to some really nice helper methods from Ray Wenderlich's site
//    http://www.raywenderlich.com/86336/ios-8-healthkit-swift-getting-started
//    Article author:  Ernesto García

/*
// Body Measurements
//-------------------------------

// Fitness Identifiers
//-------------------------------
// LOINC has begun to track some of this, but it's in "trial" mode
//   http://r.details.loinc.org/LOINC/62812-3.html?sections=Comprehensive
// There's also a more generalized "Exercise tracking panel" that includes distances and durations
//   http://r.details.loinc.org/LOINC/55409-7.html?sections=Comprehensive

// Vital Signs Identifiers
//-------------------------------

// Results Identifiers
//-------------------------------
*/


import Foundation
import HealthKit
import Try


public class CDAKHealthKitBridge {
  
  public static let sharedInstance = CDAKHealthKitBridge()
  
  private init() {
    loadDefaultHealthKitTermMap()
    loadDefaultHKQuantityTypeInfo()
  }
  
  let kUnknownString = "Unknown"

  //https://developer.apple.com/library/watchos/documentation/HealthKit/Reference/HealthKit_Constants/index.html#//apple_ref/doc/constant_group/Results_Identifiers
  var CDAKHKTypeConceptsImport: [String:CDAKCodedEntries] = [:]
  var CDAKHKTypeConceptsExport: [String:CDAKCodedEntries] = [:]
  
  // placeholder for non-localized descriptions
  public var CDAKHKQuantityTypeDescriptions: [String:String] = [:]
  // placeholder for preferredUnitsForQuantityTypes from user's HealthKitStore
  // https://developer.apple.com/library/prerelease/ios/documentation/HealthKit/Reference/HKHealthStore_Class/index.html#//apple_ref/occ/instm/HKHealthStore/preferredUnitsForQuantityTypes:completion:
  public var CDAKHKQuantityTypeDefaultUnits: [String:String] = [:]
  public var CDAKHKQuantityTypeDefaultTypes: [String:String] = [:]

  
  public enum CDAKHKQuantityIdentifiers: String {
    
    //  enum BodyMeasurements : String {
    case HKQuantityTypeIdentifierBodyMassIndex
    case HKQuantityTypeIdentifierBodyFatPercentage
    case HKQuantityTypeIdentifierHeight
    case HKQuantityTypeIdentifierBodyMass
    case HKQuantityTypeIdentifierLeanBodyMass
    //  }
    
    //  enum FitnessIdentifiers: String {
    case HKQuantityTypeIdentifierStepCount
    case HKQuantityTypeIdentifierDistanceWalkingRunning
    case HKQuantityTypeIdentifierDistanceCycling
    case HKQuantityTypeIdentifierBasalEnergyBurned
    case HKQuantityTypeIdentifierActiveEnergyBurned
    case HKQuantityTypeIdentifierFlightsClimbed
    case HKQuantityTypeIdentifierNikeFuel
    //  }
    
    //  enum VitalSignsIdentifiers: String {
    case HKQuantityTypeIdentifierHeartRate
    case HKQuantityTypeIdentifierBodyTemperature
    case HKQuantityTypeIdentifierBasalBodyTemperature
    case HKQuantityTypeIdentifierBloodPressureSystolic
    case HKQuantityTypeIdentifierBloodPressureDiastolic
    case HKQuantityTypeIdentifierRespiratoryRate
    //  }
    
    //  enum ResultsIdentifiers: String {
    case HKQuantityTypeIdentifierOxygenSaturation
    case HKQuantityTypeIdentifierPeripheralPerfusionIndex
    case HKQuantityTypeIdentifierBloodGlucose
    case HKQuantityTypeIdentifierNumberOfTimesFallen
    case HKQuantityTypeIdentifierElectrodermalActivity
    case HKQuantityTypeIdentifierInhalerUsage
    case HKQuantityTypeIdentifierBloodAlcoholContent
    case HKQuantityTypeIdentifierForcedVitalCapacity
    case HKQuantityTypeIdentifierForcedExpiratoryVolume1
    case HKQuantityTypeIdentifierPeakExpiratoryFlowRate
    //  }
    
    //this is not my preferred approach, but for prototypeing it's fine for the moment
    public static let allValues = [HKQuantityTypeIdentifierBodyMassIndex, HKQuantityTypeIdentifierBodyFatPercentage, HKQuantityTypeIdentifierHeight, HKQuantityTypeIdentifierBodyMass, HKQuantityTypeIdentifierLeanBodyMass, HKQuantityTypeIdentifierStepCount, HKQuantityTypeIdentifierDistanceWalkingRunning, HKQuantityTypeIdentifierDistanceCycling, HKQuantityTypeIdentifierBasalEnergyBurned, HKQuantityTypeIdentifierActiveEnergyBurned, HKQuantityTypeIdentifierFlightsClimbed, HKQuantityTypeIdentifierNikeFuel, HKQuantityTypeIdentifierHeartRate, HKQuantityTypeIdentifierBodyTemperature, HKQuantityTypeIdentifierBasalBodyTemperature, HKQuantityTypeIdentifierBloodPressureSystolic, HKQuantityTypeIdentifierBloodPressureDiastolic, HKQuantityTypeIdentifierRespiratoryRate  , HKQuantityTypeIdentifierOxygenSaturation, HKQuantityTypeIdentifierPeripheralPerfusionIndex, HKQuantityTypeIdentifierBloodGlucose, HKQuantityTypeIdentifierNumberOfTimesFallen, HKQuantityTypeIdentifierElectrodermalActivity, HKQuantityTypeIdentifierInhalerUsage, HKQuantityTypeIdentifierBloodAlcoholContent, HKQuantityTypeIdentifierForcedVitalCapacity, HKQuantityTypeIdentifierForcedExpiratoryVolume1, HKQuantityTypeIdentifierPeakExpiratoryFlowRate]
  }
  

  
  func dateFromEvent(eventDate: Double) -> NSDate
  {
    return NSDate(timeIntervalSince1970: NSTimeInterval(eventDate))
  }

  func dateFromEvent(eventDate: NSDate) -> Double
  {
    return eventDate.timeIntervalSince1970
  }
  
  func administrativeGender(biologicalSex:HKBiologicalSex?)-> (code:String, displayName:String)
  {
    //gender -> M, F, UN
    //<administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="Male"/>
    //https://www.hl7.org/fhir/v3/AdministrativeGender/index.html

    var genderCode = "UN" //Undifferentiated
    var genderDisplayName = "Undifferentiated"
    
    if  biologicalSex != nil {
      switch( biologicalSex! )
      {
      case .Female:
        genderCode = "F"
        genderDisplayName = "Female"
      case .Male:
        genderCode = "M"
        genderDisplayName = "Male"
      default:
        break;
      }
      
    }
    return (genderCode, genderDisplayName);
  }

  func administrativeGender(genderCode:String?)-> HKBiologicalSex
  {
    if let genderCode = genderCode {
      switch genderCode {
      case "M":
        return HKBiologicalSex.Male
      case "F":
        return HKBiologicalSex.Female
      case "UN":
        if #available(iOS 8.2, *) {
            return HKBiologicalSex.Other
        } else {
          print("Gender for code: \(genderCode) not supported on this version of iOS")
        }
      default:
        print("Indeterminate biological gender for code: \(genderCode)")
        if #available(iOS 8.2, *) {
            return HKBiologicalSex.Other
        } else {
            // Fallback on earlier versions
        }
      }
    }
    return HKBiologicalSex.NotSet
  }

  
  func getDatesForResult(entry: CDAKEntry, value: CDAKResultValue) -> (start_date: NSDate?, end_date: NSDate?) {
    
    var start_date: NSDate?
    var end_date: NSDate?
    
    let start_date_dbl: Double? = value.start_time ?? value.time ?? entry.start_time ?? entry.time
    let end_date_dbl: Double? = value.end_time ?? value.time ?? entry.end_time ?? entry.time
    
    if let start_date_dbl = start_date_dbl {
      start_date = dateFromEvent(start_date_dbl)
    }
    if let end_date_dbl = end_date_dbl {
      end_date = dateFromEvent(end_date_dbl)
    }
    return (start_date, end_date)
    
  }

  func sampleForEntry(entry: CDAKEntry, forSampleType sampleType: CDAKHKQuantityIdentifiers) -> HKQuantitySample? {
    return sampleForEntryValue(entry, allowedCodeList:
      CDAKHealthKitBridge.sharedInstance.CDAKHKTypeConceptsImport[sampleType.rawValue], quantityTypeIdentifier: sampleType.rawValue)
  }

  func sampleForEntryValue(entry: CDAKEntry, allowedCodeList: CDAKCodedEntries?, quantityTypeIdentifier: String) -> HKQuantitySample? {
    if let allowedCodeList = allowedCodeList {
      for (codeSystem, codes) in allowedCodeList {
        if let matching_codes = entry.codes.findIntersectingCodes(forCodeSystem: codeSystem, matchingCodes: codes.codes) where matching_codes.count > 0 {
          //we have a matching code reference, so let's go ahead and try to return this entry
          if let r_val = entry.values.first as? CDAKPhysicalQuantityResultValue {
            let times = getDatesForResult(entry, value: r_val)
            if let scalar = r_val.scalar, hr = Double(scalar), start_date = times.start_date, end_date = times.end_date, unit = unitForCDAString(r_val.units, forQuantityTypeIdentifier: quantityTypeIdentifier) {
              if let qtyType = HKQuantityType.quantityTypeForIdentifier(quantityTypeIdentifier) {
                if qtyType.isCompatibleWithUnit(unit) {
                  let qty: HKQuantity = HKQuantity(unit: unit, doubleValue: hr)
                  let qtySample: HKQuantitySample = HKQuantitySample(type: qtyType
                    , quantity: qty, startDate: start_date, endDate: end_date)
                  return qtySample
                } else {
                  print("sampleForEntryValue() - Cannot create sample of type '\(quantityTypeIdentifier)' using unit type '\(unit)'")
                }
              }
            }
          }
        }
      }
    }
    
    return nil
  }
  
  
  /**
   There are a fixed number of HKUnit code strings we can use to initialize an HKUnit.  EX: "cm" "dL" etc.  CDA does not, however, entirely fix that list like HKUnit. We've seen inches units which should be represented by "in" be formatted with unit strings like "inch" or "inches." 
   
   Additionally, the UCUM units CDA uses may be somewhat broader than HKUnit SI units.  EX: inch may be represented as "in_us"

   There may also be formatting conventions in CDA that make it difficult to utilize the identifier strings with HealthKit.  EX: "[in_us]" or "hh[Mg]"
   
   We need to attend to all of these scenarios to see if we can "clean up" the CDA unit codes so they're viable for HKUnit's fromString initializer.

   - parameter unit_string: The CDA unit identifier you are attempting to use to create an HKUnit.

   - parameter forQuantityTypeIdentifier: The HK Quantity Type identifier you are trying to tie to the unit. There are certain quantity types (BMI) that use units like "count" which would be in direct conflict with the typical units like "kg/m^2" used by many medical record systems. The quantity type is then used to completely override the unit codes and force them (for better or for worse) to conform to HealhtKit's preferred unit.
   
   - returns: Optional HKUnit. If one can be created, it will be populated.
   */
  
  var cdaStringUnitFinder : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?)?
  
  //CDAKitUnitForCDAString
  //public var cdaStringUnitFinder : CDAKitUnitForCDAString?
  
  func unitForCDAString(var unit_string: String?, forQuantityTypeIdentifier typeIdentifier: String? = nil) -> HKUnit? {

    
    if let cdaStringUnitFinder = cdaStringUnitFinder {
      return cdaStringUnitFinder(unit_string: unit_string, typeIdentifier: typeIdentifier)
    } else {
    
      var a_unit: HKUnit?
      let aTypeIdentifier : String = typeIdentifier ?? ""
      
      //we're moving this up here for two reasons
      // 1) so it draws your attention
      // 2) some instances of CDA templates show BMI without a unit
      switch aTypeIdentifier {
      case "HKQuantityTypeIdentifierBodyMassIndex":
        unit_string = "count" //I have no idea why BMI wants "count" vs kg/m^2
      default:
        break
      }
      
      
      // remove brackets []
      // remove things that have (s) in them like - milliLiter(s)
      let unit_match_string = "([\\[,\\]])|(\\(s\\))"

      if let unit_string = unit_string, var a_unit_string = CDAKCommonUtility.Regex.replaceMatches(unit_match_string, inString: unit_string, withString: "") {
        //need some sort of more general reference / replacement thing here
        //we need to find other alternative identifiers to units and
        // format them to something HK recognizes
        
        
        //I realize this whole thing is foul, but it's a place-holder to test other functionality
        // these are just some of the different formats we've seen with exponents
        if ["10*3/ul", "10^3/ul", "10+3/ul"].contains(a_unit_string) {
          a_unit_string = "10^3/ul"
        } else if ["kg/m2",	"kg/m²", "kg/m^2"].contains(a_unit_string) {
          a_unit_string = "kg/m^2"
        }
        
        
        switch a_unit_string.lowercaseString {
        case "in_i", "in_us", "inch", "inches": a_unit_string = "in"
        case "lbs", "lb_av", "pound", "pounds": a_unit_string = "lb"
        case "F": a_unit_string = "degF"
        case "C": a_unit_string = "degC"
          
        case "/min": a_unit_string = "count/min"
          
        case "fl": a_unit_string = "l"
        case "gram", "grams": a_unit_string = "g"
        case "meter", "meters": a_unit_string = "m"
        case "feet", "foot": a_unit_string = "ft"
        case "kiloliter", "kiloliters": a_unit_string = "ml"
        case "milliliter", "milliliters": a_unit_string = "ml"
        case "millgram", "millgrams": a_unit_string = "mg"
        case "centimeter", "centimeters": a_unit_string = "mm"
        case "millilmeter", "millilmeters": a_unit_string = "mm"
          
        default: break
        }
        //because we can't do a try for the HKUnit initializer, we're going to just say "give it a shot"
        // and use SwiftyTryCatch here to let us just ... try.
        do {
          try trap {
            a_unit = HKUnit(fromString: a_unit_string)
          }
        } catch let error as NSError {
          print("unitForCDAString failure for unit '\(unit_string)' - \(error.description) ")
          return nil
        }
      }

      return a_unit
    }
  }
  
  
  
  
  //we're going to use this to set CDAKHKQuantityTypeDefaultUnits based on user setting if we're allowed to
  public func setHDSUnitTypesWithUserSettings(store: HKHealthStore) {
    //https://developer.apple.com/library/watchos/documentation/HealthKit/Reference/HKHealthStore_Class/index.html#//apple_ref/occ/instm/HKHealthStore/preferredUnitsForQuantityTypes:completion:
    //really nice example implementation at: http://ambracode.com/index/show/1610009
    for sampleType in supportedHKQuantityTypes {
      //doing this one by one as I don't know what happens if we request all identifiers at once and don't have
      // have access to a subset
      store.preferredUnitsForQuantityTypes(Set([sampleType])) { (preferredUnits: [HKQuantityType : HKUnit], error: NSError?) -> Void in
        if error == nil {
          if let unit: HKUnit = preferredUnits[sampleType] {
            self.CDAKHKQuantityTypeDefaultUnits[sampleType.identifier] = unit.unitString
          }
        } else {
          switch error!.code {
          case 5:
            print("Access to sample \(sampleType.identifier) denied - using default unit \(self.CDAKHKQuantityTypeDefaultUnits[sampleType.identifier])")
          default:
            print("Error accessing user sample types. \(error?.localizedDescription)")
          }
        }
      }
    }
    
  }
  
  public func setPreferedUnitForSampleType(preferredUnitString unit: String, forHKQuantityTypeIdentifier type: String) {
    CDAKHKQuantityTypeDefaultUnits[type] = unit
  }
  
  
  private var _supportedHKQuantityTypes: Set<HKQuantityType>?
  public var supportedHKQuantityTypes: Set<HKQuantityType> {
    get {
      
      if _supportedHKQuantityTypes != nil {
        return _supportedHKQuantityTypes!
      }
      
      var supportedTypes = Set<HKQuantityType>()
      for identifier in supportedHKQuantityTypeIdentifiers {
        if let sampleType = HKQuantityType.quantityTypeForIdentifier(identifier) {
          supportedTypes.insert(sampleType)
        }
      }
      _supportedHKQuantityTypes = supportedTypes
      return _supportedHKQuantityTypes!
    }
  }
  
  private var _supportedHKQuantityTypeIdentifiers: Set<String>?
  public var supportedHKQuantityTypeIdentifiers: Set<String> {
    get {
      
      if _supportedHKQuantityTypeIdentifiers != nil {
        return _supportedHKQuantityTypeIdentifiers!
      }
      
      var supportedTypes = Set([
        HKQuantityTypeIdentifierActiveEnergyBurned, HKQuantityTypeIdentifierBasalEnergyBurned, HKQuantityTypeIdentifierBloodAlcoholContent, HKQuantityTypeIdentifierBloodGlucose, HKQuantityTypeIdentifierBloodPressureDiastolic, HKQuantityTypeIdentifierBloodPressureSystolic, HKQuantityTypeIdentifierBodyFatPercentage, HKQuantityTypeIdentifierBodyMass, HKQuantityTypeIdentifierBodyMassIndex, HKQuantityTypeIdentifierBodyTemperature, HKQuantityTypeIdentifierDistanceCycling, HKQuantityTypeIdentifierDistanceWalkingRunning, HKQuantityTypeIdentifierElectrodermalActivity, HKQuantityTypeIdentifierFlightsClimbed, HKQuantityTypeIdentifierForcedExpiratoryVolume1, HKQuantityTypeIdentifierForcedVitalCapacity, HKQuantityTypeIdentifierHeartRate, HKQuantityTypeIdentifierHeight, HKQuantityTypeIdentifierInhalerUsage, HKQuantityTypeIdentifierLeanBodyMass, HKQuantityTypeIdentifierNikeFuel, HKQuantityTypeIdentifierNumberOfTimesFallen, HKQuantityTypeIdentifierOxygenSaturation, HKQuantityTypeIdentifierPeakExpiratoryFlowRate, HKQuantityTypeIdentifierPeripheralPerfusionIndex, HKQuantityTypeIdentifierRespiratoryRate, HKQuantityTypeIdentifierStepCount
        ])
      
      if #available(iOS 9.0, *) {
        supportedTypes.insert(HKQuantityTypeIdentifierBasalBodyTemperature)
      }
      
      _supportedHKQuantityTypeIdentifiers = supportedTypes
      return supportedTypes
    }
  }
  
  
  
  private func getPlistFromBundle(plistNamed name: String) -> NSDictionary? {
    if let filePath = CDAKCommonUtility.bundle.pathForResource(name, ofType: "plist"), plistData = NSDictionary(contentsOfFile:filePath) {
      return plistData
    }
    return nil
  }
  
  private func loadDefaultHKQuantityTypeInfo() {
    if let plistData = getPlistFromBundle(plistNamed: "CDAKitDefaultSampleTypeIdentifierSettings") {
      loadHealthKitQuantityTypeMetadata(withPlist: plistData)
    } else {
      print("Failed to find HK quantity unit and description file (CDAKitDefaultSampleTypeIdentifierSettings).  This will make it impossible to import or generate CDA using HealthKit ")
    }
  }
  
  public func loadHealthKitQuantityTypeMetadata(withPlist plist: NSDictionary) {
    for (identifierKey, entryData) in plist {
      if let identifierKey = identifierKey as? String, entryData = entryData as? NSDictionary {
        if supportedHKQuantityTypeIdentifiers.contains(identifierKey) {
          if let unit = entryData["unit"] as? String {
            CDAKHKQuantityTypeDefaultUnits[identifierKey] = unit
          }
          if let displayName = entryData["displayName"] as? String {
            CDAKHKQuantityTypeDescriptions[identifierKey] = displayName
          }
          if let type = entryData["type"] as? String {
            CDAKHKQuantityTypeDefaultTypes[identifierKey] = type
          }
        } else {
          print("Was not able to import metadata for sample type '\(identifierKey)'. Please check quantity info plist file for entry. ")
        }
      }
    }
  }
  
  
  private func loadDefaultHealthKitTermMap() {
    if let plistData = getPlistFromBundle(plistNamed: "CDAKitDefaultHealthKitTermMap") {
      loadHealthKitTermMap(withPlist: plistData)
    } else {
      print("Failed to find term map file (CDAKitDefaultHealthKitTermMap).  This will make it impossible to import or generate CDA using HealthKit ")
    }
  }
  
  public func loadHealthKitTermMap(withPlist plist: NSDictionary) {
    for (identifierKey, entryData) in plist {
      //"identifierKey" will be something like  "HKQuantityTypeIdentifierBloodGlucose"
      if let identifierKey = identifierKey as? String, entryData = entryData as? NSDictionary {
        CDAKHKTypeConceptsImport[identifierKey] = restoreHDSCodedEntriesFromPList(usingPlist: entryData, forMapDirection: ["import", "both"])
        CDAKHKTypeConceptsExport[identifierKey] = restoreHDSCodedEntriesFromPList(usingPlist: entryData, forMapDirection: ["export", "both"])
      }
    }
  }
  
  
  //  public func exportHealthKitTermMap() -> NSDictionary {
  //    let terms = NSMutableDictionary()
  //
  //    //[String:CDAKCodedEntries]
  //
  //    //sample type (HKQuantityTypeIdentifierLeanBodyMass) is the first key
  //    // then CDAKCodedEntries (VOCAB : [term info])
  //    //    term info:
  //    //        code: String -> 12345
  //    //        displayName: String -> "my awesome term"
  //    //        mapRestriction: String -> import, export, both
  //    for (identifierKey, concepts) in CDAKHKTypeConceptsImport {
  //      let mapRestriction = "import"
  //      //does the sample type already exist?
  //      if let existing_concepts = terms.objectForKey(identifierKey) as? NSMutableDictionary {
  //
  //      } else {
  //
  //      }
  //    }
  //
  //    return terms
  //  }
  
  //forMapDirection - >
  private func restoreHDSCodedEntriesFromPList(usingPlist dictEntry: NSDictionary, forMapDirection direction: [String]) -> CDAKCodedEntries {
    var codedEntries = CDAKCodedEntries()
    
    for (vocabulary, codes) in dictEntry {
      if let vocabulary = vocabulary as? String, codes = codes as? [NSDictionary] {
        for a_code in codes {
          if let code = a_code["code"] as? String, mapRestriction = a_code["mapRestriction"] as? String {
            if direction.contains(mapRestriction) {
              //we only want to load the codes for a specific import or export set
              var displayName: String?
              if let a_displayName = a_code["displayName"] as? String {
                displayName = a_displayName
              }
              codedEntries.addCodes(vocabulary, codes: code, codeSystemOid: CDAKCodeSystemHelper.oid_for_code_system(vocabulary), displayName: displayName)
            }
          }
        }
      }
    }
    
    return codedEntries
  }


  
}




//example of writing to health store
//http://stackoverflow.com/questions/27268665/ios-healthkit-how-to-save-heart-rate-bpm-values-swift

public class CDAKHKRecord: CustomStringConvertible {
  
  public var title: String?
  public var first: String?
  public var last: String?
  public var gender: HKBiologicalSex?

  public var birthdate: NSDate?
  public var deathdate: NSDate? //probably not interested in this one...
  
  public var effective_time: NSDate?
  public var healthKitSamples: [HKQuantitySample] = []

  
  public func exportAsHDSRecord() -> CDAKRecord {
    
    let aRecord = CDAKRecord()
    aRecord.title = title
    aRecord.first = first
    aRecord.last = last
    aRecord.gender = CDAKHealthKitBridge.sharedInstance.administrativeGender(gender).code
    if let bDate = birthdate {
      aRecord.birthdate = bDate.timeIntervalSince1970
    }
    if let dDate = deathdate {
      aRecord.deathdate = dDate.timeIntervalSince1970
    }
    
    
    for sample in healthKitSamples {
      
      //we want to figure out what CDAK type this is and how / where to store it
      // for now, that's really just vitals and lab results

      if let type = CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultTypes[sample.sampleType.identifier] {
        switch type {
          case "vital":
          let entry = CDAKVitalSign()
          setHDSDataFromSample(sample, forEntry: entry)
          aRecord.vital_signs.append(entry)
        case "result":
          let entry = CDAKLabResult()
          setHDSDataFromSample(sample, forEntry: entry)
          aRecord.results.append(entry)
        default:
          break
          }
      }
    }
    
    return aRecord
    
  }
  
  private func setHDSDataFromSample(sample: HKQuantitySample, forEntry entry: CDAKEntry) {
    entry.start_time = sample.startDate.timeIntervalSince1970
    entry.end_time = sample.endDate.timeIntervalSince1970
    if let codes = CDAKHealthKitBridge.sharedInstance.CDAKHKTypeConceptsExport[sample.sampleType.identifier] {
      entry.codes = codes
    }
    if let aValue = getHDSValueFromSample(sample) {
      entry.values.append(aValue)
      entry.item_description = CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDescriptions[sample.sampleType.identifier]
    }
  }
  
  private func getHDSValueFromSample(sample: HKQuantitySample) -> CDAKPhysicalQuantityResultValue? {
    
    let sampleType = sample.sampleType.identifier
    
    if let unitString = CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[sampleType] {
      
      let defaultUnit = HKUnit(fromString: unitString)
      
      if sample.quantity.isCompatibleWithUnit(defaultUnit) {
        return CDAKPhysicalQuantityResultValue(scalar: sample.quantity.doubleValueForUnit(defaultUnit), units: defaultUnit.unitString)
      } else {
        print("exportAsHDSRecord() - Cannot sample values for sample of type '\(HKQuantityTypeIdentifierBodyMassIndex)' using unit type '\(defaultUnit)'")
      }
      
    }

    return nil
  }
  
  public init(fromHDSRecord patient: CDAKRecord) {
    
    
    first = patient.first
    last = patient.last
    title = patient.title
    gender = CDAKHealthKitBridge.sharedInstance.administrativeGender(patient.gender)
    
    for sampleType in CDAKHealthKitBridge.CDAKHKQuantityIdentifiers.allValues {
      healthKitSamples.appendContentsOf( patient.vital_signs.flatMap( { CDAKHealthKitBridge.sharedInstance.sampleForEntry($0, forSampleType: sampleType)} ) )
      healthKitSamples.appendContentsOf( patient.results.flatMap( { CDAKHealthKitBridge.sharedInstance.sampleForEntry($0, forSampleType: sampleType)} ) )
      healthKitSamples.appendContentsOf( patient.procedures.flatMap( { CDAKHealthKitBridge.sharedInstance.sampleForEntry($0, forSampleType: sampleType)} ) )
    }
    
    
    if let birthdate = patient.birthdate {
      self.birthdate = CDAKHealthKitBridge.sharedInstance.dateFromEvent(birthdate)
    }
    if let deathdate = patient.deathdate {
      self.deathdate = CDAKHealthKitBridge.sharedInstance.dateFromEvent(deathdate)
    }
    
  }
  
  public var healthKitSamplesDescription : String {
    return healthKitSamples.map({"\($0.sampleType) \($0.description)"}).joinWithSeparator(", ")
  }
  
  public var description: String {
    return "CDAKHKRecord => title: \(title), first: \(first), last: \(last), gender: \(gender), birthdate: \(birthdate), deathdate: \(deathdate), healthKitSamples: \(healthKitSamplesDescription) "
  }
  
}

