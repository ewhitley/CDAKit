<img src="./github_assets/cdakit.png" srcset="/github_assets/cdakit@2x.png 2x, /github_assets/cdakit@3x.png 3x" alt="CDAKit">

# CDAKit

**Helping you quickly manage CDA-structured health data** 

You can read more about some of the rationale behind CDAKit on my [LinkedIn posts](https://www.linkedin.com/pulse/connecting-ios-your-emr-using-healthkit-cda-part-one-eric-whitley).  

CDAKit's models, importer, and exporter are based on the Ruby [Health-Data-Standards] project, which was funded by the US Office of the National Coordinator for Health Information Technology([ONC]) and built primarily by MITRE Corporation([MITRE]). 

CDAKit provides the ability to bridge CDA content with HealthKit so you convert between HealthKit and CDA XML using HealthKit samples.

## Features

* Create CDA documents (C32 and CCDA)
* Import CDA documents (C32 and CCDA)
* Bridge to HealthKit (for CDA import and export)

## The Fast Track
```swift

let doc = ((supply your CDA XML string))

do {
  //let's try to import from CDA
  let record = try CDAKImport_BulkRecordImporter.importRecord(doc)

  //let's create a new vital
  // use the coded values to govern "meaning" (height, weight, BMI, BP items, etc.)
  let aVital = CDAKVitalSign()
  aVital.codes.addCodes("LOINC", codes: ["3141-9"]) //weight
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

## Installation

### Requirements
- iOS 8+
- Xcode 7
- Swift 2.1

### Using CocoaPods
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

### Dependencies

CDAKit proudly uses the following projects:
* [Fuzi] - "_A fast & lightweight XML & HTML parser in Swift with XPath & CSS support_" Used for all XPath-based parsing of inbound CDA XML.
* [GRMustache] - "_Flexible Mustache templates for Swift_" Swift version of the Mustache templating engine.  Used for CDA XML generation.
* [Try] - "_Handle Objective-C Exceptions with Swift's error handling system_" There is one specific place (attempting to create an HKUnit from string) where we need to use the more traditional "try" (with failure) to handle exceptions that Swift can't yet address.



## Usage

Reference CDAKit in your app
```swift
import CDAKit
```



### Basic Models

CDAKit uses a core "Record" object (`CDAKRecord`) that represents the core CDA document.  Within the record are individual entries (`CDAKEntry`) with various more precise types for elements like encounters, medications, allergies, etc.

* **CDAKRecord**: Central record
  * Record header metadata
  * Patient name, medical record numbers, demographics, gender, etc.
  * Specific typed arrays of child CDA Entries by type (allergies, encounters, etc.)

* **CDAKEntry**: Your detailed CDA content. These may either be `CDAKEntry` or more specific subclasses like `CDAKAllergy`, `CDAKMedication`, `CDAKEncounter`, etc. 

* **CDAKCodedEntries** and **CDAKCodedEntry**: These represent the pairing (or collections of pairings) or a medical terminology system and a concept code.

* **CDAKPhysicalQuantityResultValue**: A pairing of a unit of measure (lb, in, mm, etc.) and an associated value (1, 2.3, 75, etc). 

### Coded Data
Entries often contain `codes` which represent vocabulary-encoded concept codes.  A "BMI," for example, can be represented with LOINC:39156-5 (Body mass index (BMI) [Ratio]). In the absence of coded data, the concept is effectively "meaningless" for the purposes of interoperability.  While you and I may be able to read a textual "BMI" description, coded vocabulary entries are essential for machines to interpret the _intended_ meaning of a piece of information.

## Basic Methods

### Importing from CDA XML
Import your CDA XML from wherever it might be.  If you need some sample CDA files, Bostron Children's Hospital has set up [a great repository](https://github.com/chb/sample_ccdas/blob/master/HL7%20Samples/CCD.sample.xml).

Once you have your XML, you can `try` to creae a `CDAKRecord` from it by parsing the `String`.  The XML is expected to be a well-formed XML document with a `ClinicalDocument` root element.

```swift
let myXML:String = ((Get some CDA XML))
do {
  //try to import some CDA XML
  let record = try CDAKImport_BulkRecordImporter.importRecord(myXML)
}
catch {
}
```

### Exporting to CDA XML
Once your CDAKRecord is populated you can export it to one of the supported CDA XML formats.

The formats are enumerated
* .c32
* .ccda

```swift
let myOutboundCDAXML = cdakRecord.export(inFormat: .ccda)
print(myOutboundCDAXML)
```

### Enabling Support for "Indeterminate" CDA Formats
CDAKit uses the `templateId` OIDs within the XML file's `ClinicalDocument` header to determine format (found in `bulk_record_importer`).
* **C32**: 2.16.840.1.113883.3.88.11.32.1
* **CCDA**: 2.16.840.1.113883.10.20.22.1.2
* **QRDA1**: 2.16.840.1.113883.10.20.24.1.2 (_Not yet supported and will intentinoally throw an error_)

By default, failing to detect any of those OIDs will result in a document parsing exception.  Some document templates may contain valid CDA, but will not use one of those OIDs.  They might, instead, use the "US General Realm" header.

* **"MAYBE"**: 2.16.840.1.113883.10.20.22.1.1 (US General Realm header)

You can attempt to find any "might be supported" files by specifying the `attemptNonStandardCDAImport` flag in the global CDAKit singleton before attempting import.

```swift
CDAKGlobals.sharedInstance.attemptNonStandardCDAImport = true
```

From there you can then attempt to import an unspecified CDA file
```swift
let myCDAXMLWithoutTheRightType:String = ((Get some non-standard CDA XML))
CDAKGlobals.sharedInstance.attemptNonStandardCDAImport = true //enable wider support
do {
  //try to import some CDA XML
  let record = try CDAKImport_BulkRecordImporter.importRecord(myCDAXMLWithoutTheRightType:String)
}
catch {
}
```

## HealthKit Bridge

You can also communicate between the CDA models and HealthKit.  An extended discussion of the principles can be found (here](https://www.linkedin.com/pulse/connecting-ios-your-emr-using-healthkit-cda-part-one-eric-whitley).

### CDA to HealthKit

```swift
let doc = ((my CDA XML))
do {
  //try to import some CDA XML
  let record = try CDAKImport_BulkRecordImporter.importRecord(doc)

  //OK, let's convert our CDAK record to HealthKit
  let hkRecord = CDAKHKRecord(fromCDAKRecord: record)

  for sample in hkRecord.samples {
    print(sample)//these are all HKQuantitySamples
  }
}
catch {
}
```

### HealthKit to CDA
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

### Overriding CDA-Based Units Explicitly
```swift
```


### Overriding Unit Based on User Preference
```swift
```

### Vocabulary Mappings
stuff


### Searching for HealthKit Samples Imported from CDA
HKQuantitySample created by CDAKit's record import process will include a few custom metadata keys. These are intended to help you identify and manage CDA-based samples (mergine, deletion, etc.).

```swift
public enum CDAKHKMetadataKeys: String {
  case CDAKMetadataRecordIDRoot
  case CDAKMetadataEntryHash
}
```

* CDAKMetadataRecordIDRoot: the root (if found) from the source CDA XML file
* CDAKMetadataEntryHash: the hash value from the CDA entry






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
[CocoaPods]: http://cocoapods.org/
