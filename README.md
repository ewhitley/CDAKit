
![CDAKit Logo](https://raw.githubusercontent.com/ewhitley/CDAKit/master/github_assets/CDAKitGithubLogo.png "CDAKit Logo")

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/CDAKit.svg)](https://cocoapods.org/pods/CDAKit)
[![License](https://img.shields.io/cocoapods/l/CDAKit.svg?style=flat&color=gray)](https://opensource.org/licenses/Apache-2.0)


# CDAKit

**CDAKit for iOS, the Open Source Clinical Document Architecture Library with HealthKit Connectivity.  Helping you quickly manage CDA-structured health data.** 

* CDAKit GitHub - [Source](https://github.com/ewhitley/CDAKit)
* Additional [documentation](https://ewhitley.github.io/CDAKit)
* Current Version: 1.0.1.  [Revision History](https://github.com/ewhitley/CDAKit/blob/master/release-notes.md)


CDAKit provides C32 and C-CDA import and export functionality as well as the ability to connect CDA concepts with HealthKit samples.  This allows for bridging between CDA and HealthKit so you can integrate with an Electronic Medical Records system.

CDAKit's models, importer, and exporter are based on the Ruby [Health-Data-Standards] project (HDS), which was funded by the US Office of the National Coordinator for Health Information Technology ([ONC]) and built primarily by MITRE Corporation ([MITRE]). 

You can read more about some of the rationale behind CDAKit here: [LinkedIn posts](https://www.linkedin.com/pulse/connecting-ios-your-emr-using-healthkit-cda-part-one-eric-whitley).  

* [Features](#features)
* [The Fast Track](#fast_track)
* [Installation](#installation)
* [Usage](#usage)
* [Basic Models](#basic_models)
  * [Coded Data](#coded_data)
* [Basic Methods](#basic_methods)
  * [Importing from CDA XML](#import_cda_xml)
  * [Exporting to CDA XML](#export_cda_xml)
  * [Importing: Enabling Support for "Indeterminate" CDA Formats](#import_cda_xml_unsupported)
* [HealthKit Bridge](#healthkit_bridge)
  * [CDA to HealthKit](#cda_to_healthkit)
  * [HealthKit to CDA](#healthkit_to_cda)
  * [Overriding CDA-Based Units Explicitly](#healthkit_change_single_unit)
  * [Overriding Units Based on User Preferences](#healthkit_change_preference_unit)
  * [Vocabulary and Unit Mappings](#healthkit_vocabs_and_units)
      * [Vocabulary Mapping](#healthkit_vocabs_and_units_vocabs)
      * [Unit Mapping](#healthkit_vocabs_and_units_units)
  * [Searching for HealthKit Samples Imported from CDA](#healthkit_sample_metadata)


### The CDAKit Team

* [Eric Whitley](http://linkedin.com/in/ericwhitley)
* [Dr. Sarita Keni](https://www.linkedin.com/in/saritakeni)


### Special Thanks

CDAKit wouldn't exist without the Ruby [Health-Data-Standards] library. In particular, the following individuals whose leadership, commitment, and hard work are helping drive healthcare interoperability:

* The ONC - [Dr. Kevin Larsen](https://www.linkedin.com/in/kevin-larsen-25a9a511) and [John Rancourt](https://www.linkedin.com/in/johnrancourt), who championed and managed so many key interoperability projects.
* MITRE Corporation - Simply too many to list. All the great people involved in [Health-Data-Standards], [Cypress], [popHealth], [Bonnie], and more.
* Northwestern - [Luke Rasmussen](https://www.linkedin.com/in/lukevrasmussen) and [Dr. Abel Kho](https://www.linkedin.com/in/abel-kho-8170477), the de facto leadership in medical informatics and analytics on campus.



# <a name="features"></a>Features

* Create CDA documents (C32 and CCDA)
* Import CDA documents (C32 and CCDA)
* Bridge to/from HealthKit (for CDA import and export)


# <a name="fast_track"></a>The Fast Track

```swift

let doc = ((supply your CDA XML string))

do {
  //let's try to import from CDA
  let record = try CDAKRecord(fromXML: doc)

  //let's create a new vital
  // use the coded values to govern "meaning" (height, weight, BMI, BP items, etc.)
  let aVital = CDAKVitalSign()
  aVital.codes.addCodes("LOINC", code: "3141-9") //weight
  aVital.values.append(CDAKPhysicalQuantityResultValue(scalar: 155.0, units: "lb"))
  aVital.start_time = NSDate().timeIntervalSince1970
  aVital.end_time = NSDate().timeIntervalSince1970

  //append our height to our record
  record.vital_signs.append(aVital)

  //OK, let's convert our CDAK record to HealthKit
  let hkRecord = CDAKHKRecord(fromCDAKRecord: record)

  //let's explicitly set our preferred units to metric for a few things
  CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[.HKQuantityTypeIdentifierHeight] = "cm"
  CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[.HKQuantityTypeIdentifierBodyMass] = "kg"

  //now let's convert back from HealthKit to our model
  let cdakRecord = hkRecord.exportAsCDAKRecord()

  //render from our model to CDA - format set to .ccda (could also do .c32)
  print(cdakRecord.export(inFormat: .ccda))
}
catch {
  //do something
}

```


# <a name="installation"></a>Installation


## Requirements

- iOS 8+
- Xcode 7
- Swift 2.1


## Using CocoaPods

CDAKit is currently distributed through [CocoaPods]. To install `CDAKit`, add it to your to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
pod 'CDAKit', '~> 1.0'
end
```

Then, run the following command from Terminal:

```bash
$ pod install
```


## Dependencies

CDAKit proudly uses the following projects:

* [Fuzi] - "A fast & lightweight XML & HTML parser in Swift with XPath & CSS support" Used for all XPath-based parsing of inbound CDA XML.
* [GRMustache] - "Flexible Mustache templates for Swift" Swift version of the Mustache templating engine.  Used for CDA XML generation.
* [Try] - "Handle Objective-C Exceptions with Swift's error handling system" There is one specific place (attempting to create an HKUnit from string) where we need to use the more traditional "try" (with failure) to handle exceptions that Swift can't yet address.



# <a name="usage"></a>Usage

Reference CDAKit in your app

```swift
import CDAKit
```



# <a name="basic_models"></a>Basic Models


![CDAKit Record Model](https://raw.githubusercontent.com/ewhitley/CDAKit/master/github_assets/CDAKRecordModels_Common.png "CDAKit Record Model")


CDAKit uses a "Record" object (`CDAKRecord`) that represents the core CDA document.  Within the record are individual entries (`CDAKEntry`) with various more precise types for elements like encounters, medications, allergies, etc.

* **CDAKRecord**: Central record
  * Record header metadata
  * Patient name, medical record numbers, demographics, gender, etc.
  * Specific typed arrays of child CDA Entries by type (allergies, encounters, etc.)

* **CDAKEntry**: Your detailed CDA content. These may either be `CDAKEntry` or more specific subclasses like `CDAKAllergy`, `CDAKMedication`, `CDAKEncounter`, etc. 

* **CDAKCodedEntries** and **CDAKCodedEntry**: These represent the pairing (or collections of pairings) or a medical terminology system and a concept code.

* **CDAKPhysicalQuantityResultValue**: A pairing of a unit of measure (lb, in, mm, etc.) and an associated value (1, 2.3, 75, etc). 

## <a name="coded_data"></a>Coded Data
Entries can contain `codes` which represent vocabulary-encoded concept codes.  A "BMI," for example, can be represented with LOINC:39156-5 (Body mass index (BMI) [Ratio]). In the absence of coded data, the concept is effectively "meaningless" for the purposes of interoperability.  While you and I may be able to read a textual "BMI" description, coded vocabulary entries are essential for machines to interpret the _intended_ meaning of a piece of information.

Adding coded data to an Entry

```swift
  let aVital = CDAKVitalSign()
  aVital.codes.addCodes("LOINC", code: "3141-9") //weight
```

The vocabulary keys are flexible, but there are some fixed keys to help ensure concepts that have "preferred" vocabularies are able to resolve the choice of preferred vs. translation entries.

The list of known, commonly-used keys is available through `CDAKVocabularyKeys`.

You could then use these constants as follows:

```swift
      let aVital = CDAKVitalSign()
      aVital.codes.addCodes(CDAKVocabularyKeys.LOINC, code: "3141-9") //weight
```

This is probably preferred just to ensure consistency and ensure any associated OID lookups succeed.

You can also supply an optional descriptive `displayName` which would appear in the finalized coded results.

```swift
      let aVital = CDAKVitalSign()
      aVital.codes.addCodes(CDAKVocabularyKeys.LOINC, code: "3141-9", displayName: "Body Weight") //weight
```



# <a name="basic_methods"></a>Basic Methods

## <a name="import_cda_xml"></a>Importing from CDA XML
Import your CDA XML from wherever it might be.  If you need some sample CDA files, Bostron Children's Hospital has set up [a great repository](https://github.com/chb/sample_ccdas/blob/master/HL7%20Samples/CCD.sample.xml).

Once you have your XML, you can `try` to create a `CDAKRecord` from it by parsing the `String`.  The XML is expected to be a well-formed XML document with a `ClinicalDocument` root element.

```swift
let myXML:String = ((Get some CDA XML))
do {
  //try to import some CDA XML
  let record = try CDAKRecord(fromXML: myXML)
}
catch {
}
```

CDA parsing-specific errors may be of a few types, all defined in `CDAKImportError`

```swift
public enum CDAKImportError : ErrorType {
  case NotImplemented
  case UnableToDetermineFormat
  case NoClinicalDocumentElement
  case InvalidXML
}
```

* **NotImplemented**: This is a known CDA document type, but the importer doesn't (yet) handle the format
* **UnableToDetermineFormat**: This appears to be a valid XML file and also a valid `ClinicalDocument`, but contains no known template OIDs.
* **NoClinicalDocumentElement**: Could not find a `ClinicalDocument` root element
* **InvalidXML**: No XML header

## <a name="export_cda_xml"></a>Exporting to CDA XML
Once your CDAKRecord is populated you can export it to one of the supported CDA XML formats.

The formats are enumerated

* .c32
* .ccda

```swift
let myOutboundCDAXML = cdakRecord.export(inFormat: .ccda)
print(myOutboundCDAXML)
```

## <a name="import_cda_xml_unsupported"></a>Importing: Enabling Support for "Indeterminate" CDA Formats
CDAKit uses the `templateId` OIDs within the XML file's `ClinicalDocument` header to determine format (found in `bulk_record_importer`).

* **C32**: 2.16.840.1.113883.3.88.11.32.1
* **CCDA**: 2.16.840.1.113883.10.20.22.1.2
* **QRDA1**: 2.16.840.1.113883.10.20.24.1.2 (_Not yet supported and will intentinoally throw an error_)

By default, failing to detect any of those OIDs will result in a document parsing exception.  Some document templates may contain valid CDA, but will not use one of those OIDs.  They might, instead, use only the "US General Realm" header.

* **"MAYBE"**: 2.16.840.1.113883.10.20.22.1.1 (US General Realm header)

You can attempt to find any "might be supported" files by specifying the `attemptNonStandardCDAImport` flag in the global CDAKit singleton before attempting import.

```swift
CDAKGlobals.sharedInstance.attemptNonStandardCDAImport = true
```

From there you can then attempt to import an unspecified CDA file

```swift

CDAKGlobals.sharedInstance.attemptNonStandardCDAImport = true //enable wider support

let myCDAXMLWithoutTheRightType:String = ((Get some non-standard CDA XML))
do {
  //try to import some CDA XML
  let record = try CDAKRecord(fromXML: myCDAXMLWithoutTheRightType:String)
}
catch {
}
```

# <a name="healthkit_bridge"></a>HealthKit Bridge

You can transform between the CDA models and HealthKit models in order to bridge the two different representations.  An extended discussion of the approach can be found [here](https://www.linkedin.com/pulse/connecting-ios-your-emr-using-healthkit-cda-part-one-eric-whitley).

This process uses an intermediate `CDAKHKRecord` model to house the HealthKit samples.  If you have existing HealthKit samples, just just need to add them to the `samples` collection.  Ideally, you're also able to provide some basic name and gender information.

You will likely experience two challenges:

* Concept / clinical code mappings: What is a "height"? How do heights in a CDA file reconcile with heights in HealthKit?
* Unit mappings: If I have a measurement of "98.6 degF" in CDA, how do I transform that into something HealthKit samples can use?

The HealthKit bridge provides default behaviors for both of these, but you will almost certainly wish to alter them to suit your specific needs.


## <a name="cda_to_healthkit"></a>CDA to HealthKit

Importing from CDA to HealthKit can be done fairly quickly by converting a CDA-oriented CDAKRecord into HealthKit-compatible record. To do so, you can just initialize a (HealthKit) `CDAKHKRecord` from a (CDA) `CDAKRecord`. 

```swift
let doc = ((my CDA XML))
do {
  //try to import some CDA XML
  let record = try CDAKRecord(fromXML: doc)
  
  //OK, let's convert our CDAK record to HealthKit
  let hkRecord = CDAKHKRecord(fromCDAKRecord: record)

  for sample in hkRecord.samples {
    print(sample)//these are all HKQuantitySamples
  }
}
catch {
}
```

## <a name="healthkit_to_cda"></a>HealthKit to CDA

You can quickly transform a HealthKit `CDAKHKRecord` into a CDA-oriented `CDAKHKRecord` using the `exportAsCDAKRecord` method. This reads all `samples` in the HealthKit bridging record and attempts to transform the clinical concept and associated unit representations into a CDA structure.

```swift
//our wrapping record for HealthKit stuff
let hkRecord = CDAKHKRecord()

//Let's create a HealthKit height
let aUnit = HKUnit(fromString: "in")
let aQty = HKQuantity(unit: aUnit, doubleValue: 72 )
let aQtyType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)
let hkHeight = HKQuantitySample(type: aQtyType!, quantity: aQty, startDate: NSDate(), endDate: NSDate())

//store the sample in our record
hkRecord.samples.append(hkHeight)

//convert the HealthKit record to CDAKRecord
let cdakRecord = hkRecord.exportAsCDAKRecord()
```

## <a name="healthkit_change_single_unit"></a>Overriding CDA-Based Units Explicitly

The HealthKit bridge defaults output units to settings managed through a preferences file.  

If you wish to default preferred units for a given set of quantity types you can do so per HealthKit sample type identifier.

```swift
CDAKHealthKitBridge.sharedInstance.CDAKHKQuantityTypeDefaultUnits[.HKQuantityTypeIdentifierHeight] = "cm"
```

You can modify large groups of default units by changing `CDAKHKQuantityTypeDefaultUnits`, which is the dictionary where unit maps are stored at runtime.

Example: 
```
["HKQuantityTypeIdentifierBasalBodyTemperature", "degF"]
```
  
  This is initially loaded from the local `CDAKitDefaultSampleTypeIdentifierSettings` resource file in CDAKit.
  
  The plist uses the `unit` key and associated `string` value

```XML
  <key>HKQuantityTypeIdentifierBasalBodyTemperature</key>
  <dict>
  <key>unit</key>
  <string>degF</string>
```



## <a name="healthkit_change_preference_unit"></a>Overriding Units Based on User Preferences

If you want to export HealthKit objects, you may want to let the user's personal unit settings drive the HKUnit selection (where possible).  For example, we may import a "body temperature" in Fahrenheit, but a user may prefer to see that information rendered in Celsius.  If their personal unit settings for a quantity type are set, this will overwrite the global defaults with the user's preferred setting.
  
This feature uses HKHealthStore.  It is assumed all authorizations will be managed by your application.
   
This functionality modifies the HealthKit samples - NOT the native CDA data stored in the CDAKRecord.  You must set the unit preferences BEFORE you export a HKRecord (exportAsCDAKRecord).  Once exported to a CDAKRecord, any changes to the bridge's unit types will not be reflected.  CDA unit types are fixed strings.
   
HealthKit does this on a background thread, so be careful how you handle things on the UI.

```swift
//create an instance of the HealthKit management service
let healthKitStore:HKHealthStore = HKHealthStore()
//NOTE: you'd need to handle authorizations for your specific sample types

//attempt to set the HealthKit bridge's desired target units to whatever the user's device preferences might be
CDAKHealthKitBridge.sharedInstance.setCDAKUnitTypesWithUserSettings(self.healthManager.healthKitStore)
```

## <a name="healthkit_vocabs_and_units"></a>Vocabulary and Unit Mappings

This is the most complex and "personal preference" aspect of mapping between HealthKit and CDA.  When, for example, you export a HealthKit glucose `HKQuantityTypeIdentifierBloodGlucose` sample to CDA, which clinical vocabulary and concept code would you like to use?  Which measurement units would be most appropriate? Likewise, when importing from CDA to HealthKit, how do you infer that "LOINC:2345-7" is a blood glucose measurement?  And how do you transform the variety of CDA-based UCUM units into Apple's expected "mg/dl"?

To help, CDAKit provides two key mechanisms:

* A vocabulary mapping system: This simply takes a HealthKit sample type identifier like `HKQuantityTypeIdentifierBloodGlucose` and asserts a specific set of vocabulary types and coded values
* A unit mapping closure: This attempts to interpret the variety of inbound CDA units and transform them into a HealthKit-compatible representation. This is defaulted, but the `cdaStringUnitFinder` closure variable may (and should) be used by developers to change this behavior to suit their particular needs.

### <a name="healthkit_vocabs_and_units_vocabs"></a>Vocabulary Mapping

Vocabulary mapping simply tries to tie a HealthKit quantity sample type identifier to a set of known vocabulary types and associated codes.

In CDA, you might receive a lab result with the following coded entry XML:

```XML
<code 
  codeSystem="2.16.840.1.113883.6.1"
  codeSystemName="LOINC" 
  code="2345-7" 
  displayName="Glucose, Serum" />
```

How do we transform that into a `HKQuantityTypeIdentifierBloodGlucose`?

We simply provide a map from "LOINC:2345-7" to `HKQuantityTypeIdentifierBloodGlucose`.

CDAKit provides two maps to help with this:

   * `import` : used exclusively when importing values from CDA to HealthKit
   * `export` : used exclusively when exporting values from HealthKit to CDA

CDAKit provides default curated "starter" maps, but you can override all values via the `loadHealthKitTermMap` method.  This method accepts a Swift dictionary [String:AnyObject] based on a structure defined below: 
   
   * The primary key is HealthKit sample type identifier you wish to bind.
   * Within this, there is a child array bound to the key/tag CDAKit uses to map to a vocabulary.  EX: "LOINC" or "SNOMED-CT".  This declares that all following coded entries within the array will be of that specified vocabulary.
   * Details for `code`, `displayName`, and mapping restriction.  `code` is the vocabulary concept code (EX: 39156-5) for the associated `displayName` (EX: "Body mass index (BMI) [Ratio]").
   
```XML
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

### <a name="healthkit_vocabs_and_units_units"></a>Unit Mapping

The default unit mapping is a prototype and very brittle.  It simply uses a combination of regular expressions and "best guesses" to attempt to transform a set of UCUM-like unit strings into something HealthKit can utilize.

If developers have known CDA structures they would like to handle, it is suggested that they override the default unit matching algorithm.

To do so, simply provide your own custom closure via the `cdaStringUnitFinder` variable.

```swift
  public var cdaStringUnitFinder : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?)?
```

This mock example would simply look for anything like "beats" and transform it into the HealthKit-compatible "count/min".

```swift
var cdaStringUnitFinder : ((unit_string: String?, typeIdentifier: String? ) -> HKUnit?) = {
   (unit_string: String?, typeIdentifier: String?) -> HKUnit? in
      
   if unit_string == "beats" {
     return HKUnit(fromString: "count/min")
   }
      
   return nil
}

    //Tell CDAKit to use your custom unit finder
    CDAKHealthKitBridge.sharedInstance.cdaStringUnitFinder = cdaStringUnitFinder
```

## <a name="healthkit_sample_metadata"></a>Searching for HealthKit Samples Imported from CDA

HKQuantitySample created by CDAKit's record import process will include a few custom metadata keys. These are intended to help you identify and manage CDA-based samples (merging, deletion, etc.).

```swift
public enum CDAKHKMetadataKeys: String {
  case CDAKMetadataRecordIDRoot
  case CDAKMetadataEntryHash
}
```

* CDAKMetadataRecordIDRoot: the root (if found) from the source CDA XML file
* CDAKMetadataEntryHash: the hash value from the CDA entry

You can also supply your own Swift `[String:AnyObject]` dictionary to add additional custom metadata.




License
-------

This work is [Apache 2](./LICENSE.txt) licensed.

- [GRMustache](./LICENSE)
- [Fuzi](./LICENSE)
- [Swift](./LICENSE.txt)

[CDAKit]: https://github.com/ewhitley/CDAKit
[Health-Data-Standards]: https://github.com/projectcypress/health-data-standards
[GRMustache]: https://github.com/groue/GRMustache.swift
[Fuzi]: https://github.com/cezheng/Fuzi
[Apache 2]: http://www.apache.org/licenses/LICENSE-2.0
[Swift]: https://github.com/apple/swift
[Try]: https://github.com/Weebly/Try
[ONC]: https://www.healthit.gov
[MITRE]: http://mitre.org
[Cypress]: https://github.com/projectcypress
[popHealth]: https://www.osehra.org/popHealth
[Bonnie]: https://bonnie.healthit.gov
[CocoaPods]: http://cocoapods.org/
