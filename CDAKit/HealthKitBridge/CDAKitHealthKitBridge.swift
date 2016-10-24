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


/**
Provides HealthKit bridging with CDA structures.
 
 You can create HealthKit samples and convert them to CDA or take CDA objects and convert them to HealthKit samples.

 Right now HealthKit exposes samples for things that are "like" some vitals and laboratory results.  These can be inferred by reviewing the associated CDA vocabulary code entries and the individual result values.
 
 NOTE: some common HealthKit samples do not yet universally accepted vocabulary concepts.  These includes concepts `HKQuantityTypeIdentifierStepCount`, which do not yet have LOINC (or SNOMED CT) codes.
 
 We have provided default curated mappings for some codes.  These can be found in the `CDAKitDefaultHealthKitTermMap` plist file.
 
 
 Possible future Concepts and codes:
 ---
 **Fitness Identifiers**

 LOINC has begun to track some of this, but it's in "trial" mode
 
 * [http://r.details.loinc.org/LOINC/62812-3.html?sections=Comprehensive](http://r.details.loinc.org/LOINC/62812-3.html?sections=Comprehensive)
 
 There is also a more generalized "Exercise tracking panel" that includes distances and durations
 
 * [http://r.details.loinc.org/LOINC/55409-7.html?sections=Comprehensive](http://r.details.loinc.org/LOINC/55409-7.html?sections=Comprehensive)

 
*/
open class CDAKHealthKitBridge {
  
  //MARK: Primary Singleton accessor
  /**
   Singleton for all shared properties and methods.
  */
  open static let sharedInstance = CDAKHealthKitBridge()
  
  /**
   Primary class initializer - PRIVATE
  */
  fileprivate init() {
    loadDefaultHealthKitTermMap()
    loadDefaultHKQuantityTypeInfo()
  }
  
  let kUnknownString = "Unknown"

  //https://developer.apple.com/library/watchos/documentation/HealthKit/Reference/HealthKit_Constants/index.html#//apple_ref/doc/constant_group/Results_Identifiers
  var CDAKHKTypeConceptsImport: [String:CDAKCodedEntries] = [:]
  var CDAKHKTypeConceptsExport: [String:CDAKCodedEntries] = [:]
  
  //MARK: Primary configuration collections
  
  /**
  Placeholder for non-localized HealthKit quantity identifier descriptions.
  
  Example: ["HKQuantityTypeIdentifierBasalBodyTemperature", "Basal Body Temperature"]
  
  This is initially loaded from the local `CDAKitDefaultSampleTypeIdentifierSettings` resource file in CDAKit.

   The plist uses the `displayName` key and associated `string` value

   ```
   <key>HKQuantityTypeIdentifierBasalBodyTemperature</key>
   <dict>
   <key>displayName</key>
   <string>Basal Body Temperature</string>
   ```

  */
  open var CDAKHKQuantityTypeDescriptions: [String:String] = [:]
  // placeholder for preferredUnitsForQuantityTypes from user's HealthKitStore
  // https://developer.apple.com/library/prerelease/ios/documentation/HealthKit/Reference/HKHealthStore_Class/index.html#//apple_ref/occ/instm/HKHealthStore/preferredUnitsForQuantityTypes:completion:
  /**
  Default preferred units for a given set of quantity types.
  
  Example: ["HKQuantityTypeIdentifierBasalBodyTemperature", "degF"]
  
  This is initially loaded from the local `CDAKitDefaultSampleTypeIdentifierSettings` resource file in CDAKit.
  
  The plist uses the `unit` key and associated `string` value

  ```
  <key>HKQuantityTypeIdentifierBasalBodyTemperature</key>
  <dict>
  <key>unit</key>
  <string>degF</string>
  ```
  
  You can, instead, use the individual user's preferred unit settings from their Health App settings. If you wish to do so, use the `setCDAKUnitTypesWithUserSettings` method
  
  [preferredUnitsForQuantityTypes](https://developer.apple.com/library/prerelease/ios/documentation/HealthKit/Reference/HKHealthStore_Class/index.html#//apple_ref/occ/instm/HKHealthStore/preferredUnitsForQuantityTypes:completion:)
  */
  open var CDAKHKQuantityTypeDefaultUnits: [CDAKHKQuantityIdentifiers:String] = [:]
  /**
   Default classification for a specified quantity type identifier.
   
   Two primary groups as of version 1.0:
   
   * vital
   * result
   
   These attempt to tie the HealthKit concepts to a given CDA section for convenience (vitals or lab results).
   
   Example: ["HKQuantityTypeIdentifierBasalBodyTemperature", "vital"]
   
   This is initially loaded from the local `CDAKitDefaultSampleTypeIdentifierSettings` resource file in CDAKit.
   
   The plist uses the `type` key and associated `string` value
   
   ```
   <key>HKQuantityTypeIdentifierBasalBodyTemperature</key>
   <dict>
   <key>type</key>
   <string>vital</string>
   ```
   
   */
  open var CDAKHKQuantityTypeDefaultTypes: [String:String] = [:]

  //MARK: Convenience Enumerations

  /**
   Convenience enumeration of all HealthKit quantity identifiers
  */
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
  

  
  func dateFromEvent(_ eventDate: Double) -> Date
  {
    return Date(timeIntervalSince1970: TimeInterval(eventDate))
  }

  func dateFromEvent(_ eventDate: Date) -> Double
  {
    return eventDate.timeIntervalSince1970
  }
  
  //MARK: HealthKit : CDA Gender Converters

  /**
   For a given HealthKit biologicalSex, returns a tuple of the CDA code and displayName.
   
   - parameter biologicalSex: HKBiologicalSex
   - returns: tuple of the CDA code and displayName EX: ("F", "Female)
   
   Reference: [https://www.hl7.org/fhir/v3/AdministrativeGender/index.html](https://www.hl7.org/fhir/v3/AdministrativeGender/index.html)
   
   Example CDA element:
   
   ```
   <administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="Male"/>
   ```
  */
  open func administrativeGender(_ biologicalSex:HKBiologicalSex?)-> (code:String, displayName:String)
  {
    

    var genderCode = "UN" //Undifferentiated
    var genderDisplayName = "Undifferentiated"
    
    if  biologicalSex != nil {
      switch( biologicalSex! )
      {
      case .female:
        genderCode = "F"
        genderDisplayName = "Female"
      case .male:
        genderCode = "M"
        genderDisplayName = "Male"
      default:
        break;
      }
      
    }
    return (genderCode, genderDisplayName);
  }

  
  /**
   For a given CDA HL7 gender code, returns an HKBiologicalSex.
   
   - parameter genderCode: (String) HL7 gender code
   - returns: HKBiologicalSex if match found for HL7 code
   
   Reference: [https://www.hl7.org/fhir/v3/AdministrativeGender/index.html](https://www.hl7.org/fhir/v3/AdministrativeGender/index.html)
   
   Example CDA element:
   
   ```
   <administrativeGenderCode code="M" codeSystem="2.16.840.1.113883.5.1" codeSystemName="AdministrativeGenderCode" displayName="Male"/>
   ```
   */  open func administrativeGender(_ genderCode:String?)-> HKBiologicalSex
  {
    if let genderCode = genderCode {
      switch genderCode {
      case "M":
        return HKBiologicalSex.male
      case "F":
        return HKBiologicalSex.female
      case "UN":
        if #available(iOS 8.2, *) {
            return HKBiologicalSex.other
        } else {
          print("Gender for code: \(genderCode) not supported on this version of iOS")
        }
      default:
        print("Indeterminate biological gender for code: \(genderCode)")
        if #available(iOS 8.2, *) {
            return HKBiologicalSex.other
        } else {
            // Fallback on earlier versions
        }
      }
    }
    return HKBiologicalSex.notSet
  }

  
  func getDatesForResult(_ entry: CDAKEntry, value: CDAKResultValue) -> (start_date: Date?, end_date: Date?) {
    
    var start_date: Date?
    var end_date: Date?
    
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

  //MARK: HealthKit Sample Generation
  /**
   Attempts to converts a CDA entry to a HealthKit quantity sample.

  This method relies *completely* on both the concept and unit mapping functions.
  
  Concepts are matched/found based on coded entries bound to HealthKit sample identifier types. These can be found in the `CDAKitDefaultHealthKitTermMap` plist file.  You can inject your own input/output concept mappings through the `loadHealthKitTermMap` method.

  Units are matched based on a function that reviews units against known formats. If you wish to change it (you probably will), you can do so by supplying your own closure.  Just update `cdaStringUnitFinder` and all unit matching logic will be changed at runtime.
  
   - parameter entry: CDAKEntry - the CDA entry you wish to convert to a HealthKit sample.
   - parameter forSampleType: Optional (ENUM) CDAKHKQuantityIdentifiers - The type of HealthKit sample you'd like to create.  If you do not specify a sample type, the function will attempt to choose a compatible sample type for you
   - parameter withHKMetadata: [String:AnyObject] - Custom metadata you may wish to apply to HealthKit samples
  
   */
  open func sampleForEntry(_ entry: CDAKEntry, forSampleType sampleType: CDAKHKQuantityIdentifiers? = nil, withHKMetadata meta: [String:AnyObject] = [:]) -> HKQuantitySample? {

    print("evaluating entry \(type(of: entry)) with codes \(entry.codes) and value \(entry.values.first)")

    if let sampleType = sampleType {
      return sampleForEntryValue(entry, allowedCodeList:
        CDAKHealthKitBridge.sharedInstance.CDAKHKTypeConceptsImport[sampleType.rawValue], quantityTypeIdentifier: sampleType.rawValue, withHKMetadata: meta)
    } else {
      for sampleType in CDAKHealthKitBridge.CDAKHKQuantityIdentifiers.allValues {
        if let sample = sampleForEntryValue(entry, allowedCodeList:
          CDAKHealthKitBridge.sharedInstance.CDAKHKTypeConceptsImport[sampleType.rawValue], quantityTypeIdentifier: sampleType.rawValue, withHKMetadata: meta) {
            print("generated sample \(sample)")
            return sample
        }
      }
    }
    return nil

  }

  func sampleForEntryValue(_ entry: CDAKEntry, allowedCodeList: CDAKCodedEntries?, quantityTypeIdentifier: String, withHKMetadata meta: [String:AnyObject] = [:]) -> HKQuantitySample? {
    var meta = meta
    if let allowedCodeList = allowedCodeList {
      if let matching_codes = entry.codes.findIntersectingCodedEntries(forCodedEntries: allowedCodeList) , matching_codes.count > 0 {
        //we have a matching code reference, so let's go ahead and try to return this entry
        if let r_val = entry.values.first as? CDAKPhysicalQuantityResultValue {
          let times = getDatesForResult(entry, value: r_val)
          if let scalar = r_val.scalar, let hr = Double(scalar), let start_date = times.start_date, let end_date = times.end_date, let unit = unitForCDAString(r_val.units, forQuantityTypeIdentifier: quantityTypeIdentifier) {
            if let qtyType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: quantityTypeIdentifier)) {
              if qtyType.is(compatibleWith: unit) {
                meta[CDAKHKMetadataKeys.CDAKMetadataEntryHash.rawValue] = entry.hashValue as AnyObject?
                let qty: HKQuantity = HKQuantity(unit: unit, doubleValue: hr)
                let qtySample: HKQuantitySample = HKQuantitySample(type: qtyType
                  , quantity: qty, start: start_date, end: end_date, metadata: meta)
                return qtySample
              } else {
                print("sampleForEntryValue() - Cannot create sample of type '\(quantityTypeIdentifier)' using unit type '\(unit)'.  Unit is not compatible.")
              }
            }
          }
        }
      }
    }
    
    return nil
  }
  
  
  /**
   Closure that allows you to specify how unit strings from CDA templates are transformed into HealthKit units (if possible)
   
   Refer to unitForCDAString for information on arguments
   
   ```swift
   var cdaStringUnitFinder : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?) = {
   (unit_string: String?, typeIdentifier: String?) -> HKUnit? in
   
    //example
    if unit_string == "beats" || aTypeIdentifier == HKQuantityTypeIdentifierBodyMassIndex {
      return HKUnit(fromString: "count/min")
    }
   
   return nil
   }
   
   */
  open var cdaStringUnitFinder : ((_ unit_string: String?, _ typeIdentifier: String? ) -> HKUnit?)?

  
  /**
   There are a fixed number of HKUnit code strings we can use to initialize an HKUnit.  EX: "cm" "dL" etc.  CDA does not, however, entirely fix that list like HKUnit. We've seen inches units which should be represented by "in" be formatted with unit strings like "inch" or "inches." 
   
   Additionally, the UCUM units CDA uses may be somewhat broader than HKUnit SI units.  EX: inch may be represented as "in_us"

   There may also be formatting conventions in CDA that make it difficult to utilize the identifier strings with HealthKit.  EX: "[in_us]" or "hh[Mg]"
   
   We need to attend to all of these scenarios to see if we can "clean up" the CDA unit codes so they're viable for HKUnit's fromString initializer.

   - parameter unit_string: The CDA unit identifier you are attempting to use to create an HKUnit.

   - parameter forQuantityTypeIdentifier: The HK Quantity Type identifier you are trying to tie to the unit. There are certain quantity types (BMI) that use units like "count" which would be in direct conflict with the typical units like "kg/m^2" used by many medical record systems. The quantity type is then used to completely override the unit codes and force them (for better or for worse) to conform to HealhtKit's preferred unit.
   
   - returns: Optional HKUnit. If one can be created, it will be populated.
   */
  public func unitForCDAString(_ unit_string: String?, forQuantityTypeIdentifier typeIdentifier: String? = nil) -> HKUnit? {
    var unit_string = unit_string

    
    if let cdaStringUnitFinder = cdaStringUnitFinder {
      return cdaStringUnitFinder(unit_string, typeIdentifier)
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
        
        
        switch a_unit_string.lowercased() {
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
            a_unit = HKUnit(from: a_unit_string)
          }
        } catch let error as NSError {
          print("unitForCDAString failure for unit '\(unit_string)' - \(error.description) ")
          return nil
        }
      }

      return a_unit
    }
  }
  
  
  
  /**
   If you want to export HealthKit objects, you may want to let the user's personal unit settings drive the HKUnit selection (where possible).  For example, we may import a "body temperature" in Fahrenheit, but a user may prefer to see that information rendered in Celsius.  If their personal unit settings for a quantity type are set, this will overwrite the global defaults with the user's preferred setting.
  
   This feature uses HKHealthStore.  It is assumed all authorizations will be managed by your application.
   
   NOTE: This functionality modifies the HealthKit samples - NOT the native CDA data stored in the CDAKRecord.  You must set the unit preferences BEFORE you export a HKRecord (exportAsCDAKRecord).  Once exported to a CDAKRecord, any changes to the bridge's unit types will not be reflected.  CDA unit types are fixed strings.
   
   NOTE: HealthKit does this on a background thread, so be careful how you handle things on the UI
   
   - parameter store: HKHealthStore that that will allow access to preferredUnitsForQuantityTypes

   - Version: iOS 8.2 and above
   
   [preferredUnitsForQuantityTypes](https://developer.apple.com/library/prerelease/ios/documentation/HealthKit/Reference/HKHealthStore_Class/index.html#//apple_ref/occ/instm/HKHealthStore/preferredUnitsForQuantityTypes:completion:)

   */
  open func setCDAKUnitTypesWithUserSettings(_ store: HKHealthStore) {
      for sampleType in supportedHKQuantityTypes {
        //doing this one by one as I don't know what happens if we request all identifiers at once and don't have access to a subset
        if #available(iOS 8.2, *) {
            store.preferredUnits(for: Set([sampleType]), completion: { (preferredUnits, error) in
                if error == nil {
                    if let unit: HKUnit = preferredUnits[sampleType] {
                        if let id = CDAKHKQuantityIdentifiers(rawValue: sampleType.identifier) {
                            self.CDAKHKQuantityTypeDefaultUnits[id] = unit.unitString
                            print("Set default sample unit type for '\(sampleType.identifier)' to '\(unit.unitString)'")
                        }
                    }
                } else {
                    if let _error = error as? NSError {
                        switch _error.code {
                        case 5:
                            if let id = CDAKHKQuantityIdentifiers(rawValue: sampleType.identifier) {
                                print("Access to sample \(sampleType.identifier) denied - using default unit \(self.CDAKHKQuantityTypeDefaultUnits[id])")
                            }
                        default:
                            print("Error accessing user sample types. \(error?.localizedDescription)")
                        }
                    }

                }
            })
/*
            store.preferredUnits(for: Set([sampleType])) { (preferredUnits: [HKQuantityType : HKUnit], error: NSError?) -> Void in
              if error == nil {
                if let unit: HKUnit = preferredUnits[sampleType] {
                  if let id = CDAKHKQuantityIdentifiers(rawValue: sampleType.identifier) {
                    self.CDAKHKQuantityTypeDefaultUnits[id] = unit.unitString
                    print("Set default sample unit type for '\(sampleType.identifier)' to '\(unit.unitString)'")
                  }
                }
              } else {
                switch error!.code {
                case 5:
                  if let id = CDAKHKQuantityIdentifiers(rawValue: sampleType.identifier) {
                    print("Access to sample \(sampleType.identifier) denied - using default unit \(self.CDAKHKQuantityTypeDefaultUnits[id])")
                  }
                default:
                  print("Error accessing user sample types. \(error?.localizedDescription)")
                }
              }
            } */
        } else {
            print("This version of iOS does not support preferredUnitsForQuantityTypes")
        }
      }
    
  }
  
  /**
   Allows you to specify the type of unit that should be preferred for a particular HealthKit quantity type identifier
   
   - parameter preferredUnitString: unit string (EX: "cm")
   - parameter forHKQuantityTypeIdentifier: the type identifier
  */
  open func setPreferedUnitForSampleType(preferredUnitString unit: String, forHKQuantityTypeIdentifier type: String) {
    if let id = CDAKHKQuantityIdentifiers(rawValue: type) {
      CDAKHKQuantityTypeDefaultUnits[id] = unit
    }
  }
  
  
  fileprivate var _supportedHKQuantityTypes: Set<HKQuantityType>?
  ///Supplies a list of all supported HealthKit quantity types
  open var supportedHKQuantityTypes: Set<HKQuantityType> {
    get {
      
      if _supportedHKQuantityTypes != nil {
        return _supportedHKQuantityTypes!
      }
      
      var supportedTypes = Set<HKQuantityType>()
      for identifier in supportedHKQuantityTypeIdentifiers {
        if let sampleType = HKQuantityType.quantityType(forIdentifier: identifier /* HKQuantityTypeIdentifier(rawValue: identifier) */) {
          supportedTypes.insert(sampleType)
        }
      }
      _supportedHKQuantityTypes = supportedTypes
      return _supportedHKQuantityTypes!
    }
  }
  
  fileprivate var _supportedHKQuantityTypeIdentifiers: Set<HKQuantityTypeIdentifier/*String*/>?
  ///Supplies a list of all supported HealthKit sample type identiifers
  open var supportedHKQuantityTypeIdentifiers: Set<HKQuantityTypeIdentifier/*String*/> {
    get {
      
      if _supportedHKQuantityTypeIdentifiers != nil {
        return _supportedHKQuantityTypeIdentifiers!
      }
      
      var supportedTypes = Set([
        HKQuantityTypeIdentifier.activeEnergyBurned, HKQuantityTypeIdentifier.basalEnergyBurned, HKQuantityTypeIdentifier.bloodAlcoholContent, HKQuantityTypeIdentifier.bloodGlucose, HKQuantityTypeIdentifier.bloodPressureDiastolic, HKQuantityTypeIdentifier.bloodPressureSystolic, HKQuantityTypeIdentifier.bodyFatPercentage, HKQuantityTypeIdentifier.bodyMass, HKQuantityTypeIdentifier.bodyMassIndex, HKQuantityTypeIdentifier.bodyTemperature, HKQuantityTypeIdentifier.distanceCycling, HKQuantityTypeIdentifier.distanceWalkingRunning, HKQuantityTypeIdentifier.electrodermalActivity, HKQuantityTypeIdentifier.flightsClimbed, HKQuantityTypeIdentifier.forcedExpiratoryVolume1, HKQuantityTypeIdentifier.forcedVitalCapacity, HKQuantityTypeIdentifier.heartRate, HKQuantityTypeIdentifier.height, HKQuantityTypeIdentifier.inhalerUsage, HKQuantityTypeIdentifier.leanBodyMass, HKQuantityTypeIdentifier.nikeFuel, HKQuantityTypeIdentifier.numberOfTimesFallen, HKQuantityTypeIdentifier.oxygenSaturation, HKQuantityTypeIdentifier.peakExpiratoryFlowRate, HKQuantityTypeIdentifier.peripheralPerfusionIndex, HKQuantityTypeIdentifier.respiratoryRate, HKQuantityTypeIdentifier.stepCount
        ])
      
      if #available(iOS 9.0, *) {
        supportedTypes.insert(HKQuantityTypeIdentifier.basalBodyTemperature)
      }
      
      _supportedHKQuantityTypeIdentifiers = supportedTypes
      return supportedTypes // as! Set<String>
    }
  }
  
  
  
  fileprivate func getPlistFromBundle(plistNamed name: String) -> NSDictionary? {
    if let filePath = CDAKCommonUtility.bundle.path(forResource: name, ofType: "plist"), let plistData = NSDictionary(contentsOfFile:filePath) {
      return plistData
    }
    return nil
  }
  
  fileprivate func loadDefaultHKQuantityTypeInfo() {
    if let plistData = getPlistFromBundle(plistNamed: "CDAKitDefaultSampleTypeIdentifierSettings") {
      loadHealthKitQuantityTypeMetadata(withPlist: plistData)
    } else {
      print("Failed to find HK quantity unit and description file (CDAKitDefaultSampleTypeIdentifierSettings).  This will make it impossible to import or generate CDA using HealthKit ")
    }
  }
  

  /**
   Allows you to tell the sample generator how it should classify a specificy type of sample and what it should use for default units (works in tandem with the unit match closure).
   
   * The primary key is HealthKit sample type identifier you wish to bind. (EX: "HKQuantityTypeIdentifierActiveEnergyBurned")
   * `unit` is the default unit (EX: "cal")
   * `displayName` is the display name you wish to use for the sample (EX: "Active Energy Burned")
   * `type` defines how you want to classify the sample.  These attempt to tie the HealthKit concepts to a given CDA section for convenience (vitals or lab results).

   Two primary `type` groups as of version 1.0:
   
   * vital
   * result
   
   
   ```
   <key>HKQuantityTypeIdentifierActiveEnergyBurned</key>
   <dict>
     <key>unit</key>
     <string>cal</string>
     <key>displayName</key>
     <string>Active Energy Burned</string>
     <key>type</key>
     <string>vital</string>
   </dict>
   ```
   
   */  open func loadHealthKitQuantityTypeMetadata(withPlist plist: NSDictionary) {
    for (identifierKey, entryData) in plist {
      if let identifierKey = identifierKey as? String, let entryData = entryData as? NSDictionary {
        let ident = HKQuantityTypeIdentifier(rawValue: identifierKey)
        if supportedHKQuantityTypeIdentifiers.contains(ident) {
          if let unit = entryData["unit"] as? String {
            if let id = CDAKHKQuantityIdentifiers(rawValue: identifierKey) {
              CDAKHKQuantityTypeDefaultUnits[id] = unit
            }
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
  
  
  fileprivate func loadDefaultHealthKitTermMap() {
    if let plistData = getPlistFromBundle(plistNamed: "CDAKitDefaultHealthKitTermMap") {
      loadHealthKitTermMap(withPlist: plistData)
    } else {
      print("Failed to find term map file (CDAKitDefaultHealthKitTermMap).  This will make it impossible to import or generate CDA using HealthKit ")
    }
  }

  /**
   Allows you to inject your own HealthKit sample type mappings to CDA vocabulary entries.  These mappings are the core of what drives the linkage between the two.
   
   The mappings must specify a direction:
   
   * `import` : used exclusively when importing values from CDA to HealthKit
   * `export` : used exclusively when exporting values from HealthKit to CDA
   * `both` : used for import and export
   
   * The primary key is HealthKit sample type identifier you wish to bind.
   * Within this, there is a child array bound to the key/tag CDAKit uses to map to a vocabulary.  EX: "LOINC" or "SNOMED-CT".  This declares that all following coded entries within the array will be of that specified vocabulary.
   * Details for `code`, `displayName`, and mapping restriction.  `code` is the vocabulary concept code (EX: 39156-5) for the associated `displayName` (EX: "Body mass index (BMI) [Ratio]").
   
   ```
   <key>HKQuantityTypeIdentifierBodyMassIndex</key>
   <dict>
			<key>LOINC</key>
			<array>
   <dict>
   <key>code</key>
   <string>39156-5</string>
   <key>displayName</key>
   <string>Body mass index (BMI) [Ratio]</string>
   <key>mapRestriction</key>
   <string>both</string>
   </dict>
			</array>
   ... (more vocabularies)
   </dict>
   ```
   
   */
  open func loadHealthKitTermMap(withPlist plist: NSDictionary) {
    for (identifierKey, entryData) in plist {
      //"identifierKey" will be something like  "HKQuantityTypeIdentifierBloodGlucose"
      if let identifierKey = identifierKey as? String, let entryData = entryData as? NSDictionary {
        CDAKHKTypeConceptsImport[identifierKey] = restoreCDAKCodedEntriesFromPList(usingPlist: entryData, forMapDirection: ["import", "both"])
        CDAKHKTypeConceptsExport[identifierKey] = restoreCDAKCodedEntriesFromPList(usingPlist: entryData, forMapDirection: ["export", "both"])
      }
    }
  }
  
  //TODO: complete exportHealthKitTermMap()
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
  fileprivate func restoreCDAKCodedEntriesFromPList(usingPlist dictEntry: NSDictionary, forMapDirection direction: [String]) -> CDAKCodedEntries {
    var codedEntries = CDAKCodedEntries()
    
    for (vocabulary, codes) in dictEntry {
      if let vocabulary = vocabulary as? String, let codes = codes as? [NSDictionary] {
        for a_code in codes {
          if let code = a_code["code"] as? String, let mapRestriction = a_code["mapRestriction"] as? String {
            if direction.contains(mapRestriction) {
              //we only want to load the codes for a specific import or export set
              var displayName: String?
              if let a_displayName = a_code["displayName"] as? String {
                displayName = a_displayName
              }
              codedEntries.addCodes(vocabulary, code: code, codeSystemOid: CDAKCodeSystemHelper.oid_for_code_system(vocabulary), displayName: displayName)
            }
          }
        }
      }
    }
    
    return codedEntries
  }

  
}

/**
 The HealthKit metadata keys used by CDAKits metadata injection during HealthKit sample creation.
*/
public enum CDAKHKMetadataKeys: String {
  ///The "root" ID from the parent CDA item (if found)
  case CDAKMetadataRecordIDRoot
  //The calculated record entry hash value.  You can use this to look up or compare entries you create in the HealthKit store later
  //case CDAKMetadataRecordHash
  ///The calculated CDA entry hash value.  You can use this to look up or compare entries you create in the HealthKit store later
  case CDAKMetadataEntryHash
}

/**
 Primary bridging record to connect our CDA models with HealthKit
*/
open class CDAKHKRecord: CustomStringConvertible {
  
  //Mark: Basic profile and demographics
  ///Person's prefix (was Title)
  open var prefix: String?
  ///Person's first / given name
  open var first: String?
  ///Person's last / family name
  open var last: String?
  ///Person's name suffix
  open var suffix: String?
  ///Person's biological sex / gender
  open var gender: HKBiologicalSex?

  ///Birth date
  open var birthdate: Date?
  ///Deceased date
  open var deathdate: Date? //probably not interested in this one...
  ///Effective time of record
  open var effective_time: Date?

  //Mark: HealthKit samples
  ///All HealthKit samples
  open var samples: [HKQuantitySample] = []

  ///Any metadata you may wish to inject into HealthKit when it samples are created
  open var metadata: [String:AnyObject] = [:]
  
  /**
   Export this HealthKit-based record to a CDA-based representation
   
   This can then be used to add more information or export to CDA XML.
  */
  open func exportAsCDAKRecord() -> CDAKRecord {
    
    let aRecord = CDAKRecord()
    aRecord.prefix = prefix
    aRecord.first = first
    aRecord.last = last
    aRecord.suffix = suffix
    aRecord.gender = CDAKHealthKitBridge.sharedInstance.administrativeGender(gender).code
    if let bDate = birthdate {
      aRecord.birthdate = bDate.timeIntervalSince1970
    }
    if let dDate = deathdate {
      aRecord.deathdate = dDate.timeIntervalSince1970
    }
    
    
    for sample in samples {
      
      //we want to figure out what CDAK type this is and how / where to store it
      // for now, that's really just vitals and lab results

      if let type = CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultTypes[sample.sampleType.identifier] {
        switch type {
          case "vital":
          let entry = CDAKVitalSign()
          setCDAKDataFromSample(sample, forEntry: entry)
          aRecord.vital_signs.append(entry)
        case "result":
          let entry = CDAKLabResult()
          setCDAKDataFromSample(sample, forEntry: entry)
          aRecord.results.append(entry)
        default:
          break
          }
      }
    }
    
    return aRecord
    
  }
  
  fileprivate func setCDAKDataFromSample(_ sample: HKQuantitySample, forEntry entry: CDAKEntry) {
    entry.start_time = sample.startDate.timeIntervalSince1970
    entry.end_time = sample.endDate.timeIntervalSince1970
    if let codes = CDAKHealthKitBridge.sharedInstance.CDAKHKTypeConceptsExport[sample.sampleType.identifier] {
      entry.codes = codes
    }
    if let aValue = getCDAKValueFromSample(sample) {
      entry.values.append(aValue)
      entry.item_description = CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDescriptions[sample.sampleType.identifier]
    }
  }
  
  fileprivate func getCDAKValueFromSample(_ sample: HKQuantitySample) -> CDAKPhysicalQuantityResultValue? {
    
    let sampleType = sample.sampleType.identifier
    
    if let id = CDAKHealthKitBridge.CDAKHKQuantityIdentifiers(rawValue: sampleType), let unitString = CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[id] {
      
      let defaultUnit = HKUnit(from: unitString)
      
      if sample.quantity.is(compatibleWith: defaultUnit) {
        return CDAKPhysicalQuantityResultValue(scalar: sample.quantity.doubleValue(for: defaultUnit), units: defaultUnit.unitString)
      } else {
        print("exportAsCDAKRecord() - Cannot sample values for sample of type '\(HKQuantityTypeIdentifier.bodyMassIndex)' using unit type '\(defaultUnit)'")
      }
      
    }

    return nil
  }
  
  //MARK: Initializers
  /**
   For a given CDA-based record (and associated metadata), attempts to inspect that supplied record and convert the contents to HealthKit samples.
  
  - parameter fromCDAKRecord: The primary CDAKRecord from which you wish to create the patient demographics and samples
  - parameter withHKMetadata: [String:AnyObject] Any custom metadata you might wish to inject into the HealthKit samples
   */
  public init(fromCDAKRecord patient: CDAKRecord, withHKMetadata metadata: [String:AnyObject] = [:]) {
    
    
    first = patient.first
    last = patient.last
    prefix = patient.prefix
    suffix = patient.suffix
    gender = CDAKHealthKitBridge.sharedInstance.administrativeGender(patient.gender)
    
    self.metadata = metadata
    
    if let root = patient.header?.identifier?.root {
      self.metadata[CDAKHKMetadataKeys.CDAKMetadataRecordIDRoot.rawValue] = root as AnyObject?
    }

    //For now we're just going to manually choose which entries we add
    samples.append( contentsOf: patient.vital_signs.flatMap( { CDAKHealthKitBridge.sharedInstance.sampleForEntry($0, withHKMetadata: self.metadata)} ) )
    samples.append( contentsOf: patient.results.flatMap( { CDAKHealthKitBridge.sharedInstance.sampleForEntry($0, withHKMetadata: self.metadata)} ) )
    samples.append( contentsOf: patient.procedures.flatMap( { CDAKHealthKitBridge.sharedInstance.sampleForEntry($0, withHKMetadata: self.metadata)} ) )

    
    
    if let birthdate = patient.birthdate {
      self.birthdate = CDAKHealthKitBridge.sharedInstance.dateFromEvent(birthdate)
    }
    if let deathdate = patient.deathdate {
      self.deathdate = CDAKHealthKitBridge.sharedInstance.dateFromEvent(deathdate)
    }
    
  }
  
  /**
   Basic empty initializer
  */
  init() {
    
  }
  
  // MARK: Standard properties
  ///Quick description of the included HealthKit samples
  open var samplesDescription : String {
    return samples.map({"\($0.sampleType) \($0.description)"}).joined(separator: ", ")
  }
  
  ///Debugging description
  open var description: String {
    return "CDAKHKRecord => prefix: \(prefix), first: \(first), last: \(last), suffix: \(suffix), gender: \(gender), birthdate: \(birthdate), deathdate: \(deathdate), samples: \(samplesDescription) "
  }
  
}

