//
//  GRMustacheTest.swift
//  CDAKit
//
//  Created by Eric Whitley on 12/17/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest
@testable import CDAKit

import Mustache

class GRMustacheTest: XCTestCase {

  let data = [
    "name": "Arthur",
    "date": Date(),
    "realDate": Date().addingTimeInterval(60*60*24*3),
    "late": true
  ] as [String : Any]
  
  override func setUp() {
      super.setUp()
  }
    
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func testRawSwiftString() {
    do {
      let template = try Template(string: "Hello {{name}}")
      let rendering = try template.render(Box(data))
      XCTAssertEqual("Hello Arthur", rendering)
    }
    catch let error as MustacheError {
      // Parse error at line 2 of template /path/to/template.mustache:
      // Unclosed Mustache tag.
      error.description
      
      // TemplateNotFound, ParseError, or RenderError
      error.kind
      
      // The eventual template at the source of the error. Can be a path, a URL,
      // a resource name, depending on the repository data source.
      error.templateID
      
      // The eventual faulty line.
      error.lineNumber
      
      // The eventual underlying error.
      error.underlyingError
    } catch {
      //ehhhh
    }
    
  }
  
  func testBundleResource() {
    do {
      let template = try Template(named: "document")
      let rendering = try template.render(Box(data))
      print(rendering)
//      XCTAssertEqual("Hello Arthur", rendering)
    } catch {
      print("testBundleResource failed")
    }
  }

  func testFileWithFile() {
    do {
      let bundle = Bundle(for: type(of: self))
      let path = bundle.path(forResource: "document", ofType: "mustache")
      let template = try Template(path: path!)
      
      // Let template format dates with `{{format(...)}}`
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .medium
      template.registerInBaseContext("format", Box(dateFormatter))
      
      let rendering = try template.render(Box(data))
      print(rendering)
      //      XCTAssertEqual("Hello Arthur", rendering)
    } catch {
      print("testFileWithFile failed")
    }
  }

  func testFileWithURL() {
    do {
      let templateURL = URL(fileURLWithPath: "document.mustache")
      let template = try Template(URL: templateURL)
      let rendering = try template.render(Box(data))
      print(rendering)
      //      XCTAssertEqual("Hello Arthur", rendering)
    } catch {
      print("testFileWithURL failed")
    }
  }

//  class UUIDGenerator: NSNumberFormatter {
//    required init?(coder aDecoder: NSCoder) {
//      super.init(coder: aDecoder)
//    }
//    
//    override init() {
//      super.init()
//      self.locale = NSLocale.currentLocale()
//      self.maximumFractionDigits = 2
//      self.minimumFractionDigits = 2
//      self.alwaysShowsDecimalSeparator = true
//      self.numberStyle = .CurrencyStyle
//    }
//    
//    static let sharedInstance = UUIDGenerator()
//  }

  open class UUIDGenerator: MustacheBoxable {
    
//    required init?(coder aDecoder: NSCoder) {
//      //super.init(value: aDecoder)
//    }
//    
//    init() {
//    }
    
//    var mustacheBox: MustacheBox {
//      return Box(NSUUID().UUIDString)
//    }
    
//    public var mustacheBox: MustacheBox {
//      return MustacheBox(
//        value: NSUUID().UUIDString
//      )
//    }

    open var mustacheBox: MustacheBox {
      return Box(NSUUID().uuidString)
    }

    static let sharedInstance = UUIDGenerator()
    
  }
  
  
  func testCustomNumberFormatter() {
    
    //let uuid = NSUUID().UUIDString
    
    let percentFormatter = NumberFormatter()
    percentFormatter.numberStyle = .percent
    
    do {
      let template = try Template(string: "{{ percent(x) }}")
      template.registerInBaseContext("percent", Box(percentFormatter))
      
      // Rendering: 50%
      let data = ["x": 0.5]
      let rendering = try template.render(Box(data))
      print(rendering)
      XCTAssertEqual(rendering, "50%")
    }
    catch {
      
    }
    
  }

  
//  func testCustomFunction() {
//    
//    let x = UUIDGenerator()
//    print("x = \(x)")
//    print("x.mustacheBox = \(x.mustacheBox)")
//    
//    do {
//      let template = try Template(string: "{{ uuid_generate() }}")
//      template.registerInBaseContext("uuid_generate", Box(UUIDGenerator()))
//      
//      // Rendering: 50%
//      let data = ["x": 0.5]
//      let rendering = try template.render(Box(data))
//      print("rendering!")
//      print(rendering)
//      //XCTAssertEqual(rendering, "50%")
//    }
//    catch let error as NSError {
//      print(error.localizedDescription)
//    }
//    
//  }

  
  func testFilter() {
    
    let reverse = Filter { (rendering: Rendering) in
      let reversedString = String(rendering.string.characters.reversed())
      return Rendering(reversedString, rendering.contentType)
    }

//    let UUID_generate = Filter { (value: Any? ) in
//      let uuid_string = NSUUID().UUIDString
//      return Box(uuid_string)
//    }

    
    do {
      // Register the reverse filter in our template:
//      let template = try Template(string: "{{reverse(value)}}")
//      template.registerInBaseContext("reverse", Box(reverse))

      
      let template = try Template(string: "{{ UUID_generate(nil) }}")
      template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))

      // Rendering: 50%
      let data = ["x": 0.5]
      let rendering = try template.render(Box(data))
      print("rendering!")
      print(rendering)
      //XCTAssertEqual(rendering, "50%")
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
    
  }
  
  func testDateFilter() {
    
    let DateAsNumber = Filter { (box: MustacheBox) in
      
      if box.value == nil {
        return Box(Date().stringFormattedAsHDSDateNumber)
      }
      
        switch box.value {
        case let int as Int:
          print("I'm an Int")
          let d = Date(timeIntervalSince1970: Double(int))
          return Box(d.stringFormattedAsHDSDateNumber)
        case let double as Double:
          print("I'm a double")
          let d = Date(timeIntervalSince1970: double)
          return Box(d.stringFormattedAsHDSDateNumber)
        case let date as Date:
          print("I'm a date")
          return Box(date.stringFormattedAsHDSDateNumber)
        default:
          // GRMustache does not support any other numeric types: give up.
          print("I'm of type \(type(of: box.value))")
          return Box()
        }
    }

    
    do {
      let template = try Template(string: "Date: {{ date_as_number(x) }}, Int: {{date_as_number(y)}} , Double: {{ date_as_number(z) }}, nil: {{ date_as_number(nil) }}")
      template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
      let data = ["x": Date(), "y":Int(Date().timeIntervalSince1970), "z":Date().timeIntervalSince1970] as [String : Any]
      let rendering = try template.render(Box(data))
      print(rendering)
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }

    
  }
  
  
  func testCodeDisplayFilter() {
    
    //code_display(entry, {'tag_name' => 'value', 'extra_content' => 'xsi:type="CD"', 'preferred_code_sets' => ['SNOMED-CT']})
    
//    let code_display = VariadicFilter { (boxes: [MustacheBox]) in
//      var result = ""
//      for box in boxes {
//        //sum += (box.value as? Int) ?? 0
//        //result += "\(box.value.dynamicType) = \(box.value)\n"
//        result += "\(box.value)\n"
//      }
//      return Box(result)
//    }
    
    func convertStringToDictionary(_ text: String) -> [String:Any] {
      if let data = text.data(using: String.Encoding.utf8) {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
          
          var otherJson: [String:Any] = [:]
          if let json = json {
            for(key, value) in json {
              otherJson[key] = (value as Any)
            }
          }
          return otherJson
          
        } catch let error as NSError {
          print(error.localizedDescription)
        }
      }
      return [:]
    }
    
    let code_display = Filter { (box: MustacheBox, info: RenderingInfo) in
      
      let args = info.tag.innerTemplateString
      var opts: [String:Any] = [:]
      
      opts = convertStringToDictionary(args)
      print("Got ops for ... \n \(opts) \n")

      var out = ""
      print("box = \(box)")

      if let entry = box.value as? CDAKEntry {
        out = ViewHelper.code_display(entry, options: opts)
      } else {
        print("couldn't cast entry")
        print("entry = '\(box.value)'")
      }
      
      
      return Rendering(out)
    }
    
    do {
      let template = try Template(string: "code_display = {{# code_display(x)}}{\"tag_name\":\"value\",\"extra_content\":\"xsi:type=CD\",\"preferred_code_sets\":[\"SNOMED-CT\"]}{{/ }}")

      template.registerInBaseContext("code_display", Box(code_display))
      
      let entry = CDAKEntry()
      entry.time = 1270598400
      entry.add_code("314443004", code_system: "SNOMED-CT")
      
      let data = ["entry": entry]
      let rendering = try template.render(Box(data))
      print("trying to render...")
      print(rendering)
      print("rendering complete.")
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
  }
  
  func testDictionaryEachTemplate() {
    do {

      let entry = CDAKEntry()
      entry.time = 1270598400
      entry.add_code("314443004", code_system: "SNOMED-CT")
      entry.add_code("123345344", code_system: "SNOMED-CT")
      entry.add_code("345345345", code_system: "SNOMED-CT")
      entry.add_code("ABCSDFDFS", code_system: "LOINC")
      
      let template = try Template(string: "time:{{entry.time}}  codes:{{#each(entry.codes)}}{{@key}} {{#each(.)}} {{.}} {{/}} {{/}}")
      //each(entry.codes)
      let data = ["entry": entry]
      template.registerInBaseContext("each", Box(StandardLibrary.each))
      let rendering = try template.render(Box(data))

      print("trying to render...")
      print(rendering)
      print("rendering complete.")
    }
    catch let error as MustacheError {
      print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
  
  func testCodeDisplayFilter2() {
    
    do {
      //triple mustache tags to disable escaping
      let template = try Template(string: "code_display = {{{code_display}}}")
      
      let entry = CDAKEntry()
      entry.time = 1270598400
      entry.add_code("314443004", code_system: "SNOMED-CT")
      
      let opts : [String:Any] = [
        "tag_name":"value",
        "extra_content": "xsi:type=\"CD\"",
        "preferred_code_sets" : ["SNOMED-CT"]
      ]
      
      let data = ["code_display": ViewHelper.code_display(entry, options: opts)]
      let rendering = try template.render(Box(data))
      
      print("trying to render...")
      print(rendering)
      print("rendering complete.")
    }
    catch let error as MustacheError {
      fatalError("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    
  }
  

  var bigTestRecord: CDAKRecord {
    
    let entry = CDAKEntry()
    entry.time = 1270598400
    entry.add_code("314443004", code_system: "SNOMED-CT")
    entry.add_code("123345344", code_system: "SNOMED-CT")
    entry.add_code("345345345", code_system: "SNOMED-CT")
    entry.add_code("ABCSDFDFS", code_system: "LOINC")
    
    let testRecord = TestRecord()
    let record: CDAKRecord = testRecord.bigger_record()
    record.first = "Steven"
    record.last = "Smith"
    record.gender = "female"
    
    record.telecoms.append(CDAKTelecom(use: "Home", value: "(123)456-7890"))
    record.telecoms.append(CDAKTelecom(use: "Work", value: "(987)654-3210"))
    
    record.addresses.append(CDAKAddress(street: ["123 My Street","Unit xyz"], city: "Chicago", state: "IL", zip: "12345", country: "USA", use: "Home"))
    record.addresses.append(CDAKAddress(street: ["One Derful Way"], city: "Kadavu", state: "IL", zip: "99999", country: "Fiji", use: "Vacation"))
    
    record.allergies.append(CDAKAllergy(event: ["time": 1270598400, "codes":["SNOMED-CT":["xyz", "abc"]], "description": "my first allergy" ]))
    record.allergies.append(CDAKAllergy(event: ["time": 1270597400, "codes":["LOINC":["987"]], "description": "my second allergy", "specifics": "specific2" ]))
    record.allergies.append(CDAKAllergy(event: ["time": 1270597400, "codes":["RxNorm":["987"]], "description": "my third allergy", "specifics": "specific3" ]))
    
    let lr = CDAKLabResult(event: ["time": 1270598400, "codes":["LOINC":["xyz", "abc"]], "description": "my first lab result" ])
    // in case you want to test the other result value template info
    //      lr.values.append(PhysicalQuantityResultValue(scalar: nil, units: "imanilvalue"))
    //      lr.values.append(PhysicalQuantityResultValue(scalar: "left", units: "imastring"))
    //      lr.values.append(PhysicalQuantityResultValue(scalar: true, units: "imabool"))
    lr.values.append(CDAKPhysicalQuantityResultValue(scalar: 6, units: "inches"))
    lr.values.append(CDAKPhysicalQuantityResultValue(scalar: 12.2, units: "liters"))
    lr.values.append(CDAKPhysicalQuantityResultValue(scalar: -3.333, units: "hectares"))
    record.results.append(lr)

    return record
    
  }
  
  func testPartialTemplate() {
    do {
      

      
      //set this BEFORE you create the template
      // disables all HTML escaping
   //   Mustache.DefaultConfiguration.contentType = .Text

      let bundle = Bundle(for: type(of: self))
      let path = bundle.path(forResource: "record", ofType: "mustache")
      let template = try Template(path: path!)

      let data = ["patient": bigTestRecord]
      // USE: telecoms:{{#each(patient.telecoms)}} hi {{value}} {{use}} {{/}}
      template.registerInBaseContext("each", Box(StandardLibrary.each))
      // USE: {{ UUID_generate(nil) }}
      template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))
      // USE: {{ date_as_number(z) }}, nil: {{ date_as_number(nil) }}
      template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
      
      // USE: {{ value_or_null_flavor(entry.as_point_in_time) }}
      template.registerInBaseContext("value_or_null_flavor", Box(MustacheFilters.value_or_null_flavor))

      template.registerInBaseContext("oid_for_code_system", Box(MustacheFilters.oid_for_code_system))
      
      
      template.registerInBaseContext("is_numeric", Box(MustacheFilters.is_numeric))
      template.registerInBaseContext("is_bool", Box(MustacheFilters.is_bool))
      
      
      //Removing this registration
      // keep to show how you can abuse things
      // USE   code_display = {{# code_display(x)}}{\"tag_name\":\"value\",\"extra_content\":\"xsi:type=CD\",\"preferred_code_sets\":[\"SNOMED-CT\"]}{{/ }}
      //template.registerInBaseContext("code_display", Box(MustacheFilters.codeDisplayForEntry))

      //configuration.contentType = .Text
      //template.contentType = .Text
      
      //codeDisplayForEntry

      
      let rendering = try template.render(Box(data))
      
      print("trying to render...")
      print("======================")
      print(rendering)
      print("======================")
      print("rendering complete.")
    }
    catch let error as MustacheError {
      print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
  }
  
//  func testWithTemplateGenerator() {
//    
//    let template_helper = CDAKTemplateHelper(template_format: "c32", template_subdir: "c32", template_directory: nil)
//    let template = template_helper.template("show")
//
//    let data = ["patient": bigTestRecord]
//    
//    // USE: telecoms:{{#each(patient.telecoms)}} hi {{value}} {{use}} {{/}}
//    template.registerInBaseContext("each", Box(StandardLibrary.each))
//    // USE: {{ UUID_generate(nil) }}
//    template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))
//    // USE: {{ date_as_number(z) }}, nil: {{ date_as_number(nil) }}
//    template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
//    // USE: {{ value_or_null_flavor(entry.as_point_in_time) }}
//    template.registerInBaseContext("value_or_null_flavor", Box(MustacheFilters.value_or_null_flavor))
//    template.registerInBaseContext("oid_for_code_system", Box(MustacheFilters.oid_for_code_system))
//    template.registerInBaseContext("is_numeric", Box(MustacheFilters.is_numeric))
//    template.registerInBaseContext("is_bool", Box(MustacheFilters.is_bool))
//
//
//    do {
//      let rendering = try template.render(Box(data))
//      
//      print("trying to render...")
//      print("======================")
//      print(rendering)
//      print("======================")
//      print("rendering complete.")
//    }
//    catch let error as MustacheError {
//      print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
//    }
//    catch let error as NSError {
//      print(error.localizedDescription)
//    }
//    
////    let str = "{\"name\":\"James\"}"
////    
////    let result = convertStringToDictionary(str) // ["name": "James"]
//
//    
//  }
  
  func transformAnyObjectDict(_ dict: [String:AnyObject]) -> [String:Any?] {
    var otherJson: [String:Any?] = [:]
    for(key, value) in dict {
      if let value = value as? [String:AnyObject] {
        //print("converting json dict for key: \(key)")
        otherJson[key] = transformAnyObjectDict(value)
      } else if let value = value as? [AnyObject] {
        var values = [Any]()
        for v in value {
          if let v = v as? [String:AnyObject] {
            //print("going to try to convert nested for key: \(key)")
            values.append(transformAnyObjectDict(v))
          } else {
            //print("appending array entry for key: \(key)")
            values.append(v as Any)
          }
        }
        otherJson[key] = values
      }
      else {
        otherJson[key] = (value as Any)
      }
      //we need to do the whole thing
    }
    return otherJson
  }
  
//  func testLoadFileFromPath() {
//    
//    let json_files : [String] = [
////      "506afdf87042f9e32c000069", //Mary Berry
////      "506afdf87042f9e32c000001", //Barry Berry
//      "4dcbecdb431a5f5878000004" //Rosa Vasquez
//    ]
//
//    let format = "c32"
//    
//    for json_file in json_files {
//      let json = loadJSONFromBundleFile(json_file)
//      if let json = json {
//        
//        var otherJson: [String:Any?] = [:]
//        otherJson = transformAnyObjectDict(json)
//        let test_record = CDAKRecord(event: otherJson)
////        print(test_record)
//        
//        
//        
//        let template_helper = CDAKTemplateHelper(template_format: format, template_subdir: format, template_directory: nil)
//        let template = template_helper.template("show")
//        
//        let data = ["patient": test_record]
//        
//        // USE: telecoms:{{#each(patient.telecoms)}} hi {{value}} {{use}} {{/}}
//        template.registerInBaseContext("each", Box(StandardLibrary.each))
//        // USE: {{ UUID_generate(nil) }}
//        template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))
//        // USE: {{ date_as_number(z) }}, nil: {{ date_as_number(nil) }}
//        template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
//        template.registerInBaseContext("date_as_string", Box(MustacheFilters.DateAsHDSString))
//        
//        // USE: {{ value_or_null_flavor(entry.as_point_in_time) }}
//        template.registerInBaseContext("value_or_null_flavor", Box(MustacheFilters.value_or_null_flavor))
//        template.registerInBaseContext("oid_for_code_system", Box(MustacheFilters.oid_for_code_system))
//        template.registerInBaseContext("is_numeric", Box(MustacheFilters.is_numeric))
//        template.registerInBaseContext("is_bool", Box(MustacheFilters.is_bool))
//        
//        
//        do {
//          let rendering = try template.render(Box(data))
//          
//          print("trying to render...")
//          print("======================")
//          print(rendering)
//          print("======================")
//          print("rendering complete.")
//        }
//        catch let error as MustacheError {
//          print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
//        }
//        catch let error as NSError {
//          print(error.localizedDescription)
//        }
//
//        
//        
//      }
//    }
//    
//  }
  
  func loadJSONFromBundleFile(_ filename: String) -> [String:AnyObject]? {
    
    let fileName = "\(filename)"
    let directory: String? = nil
    let bundle = Bundle(for: type(of: self))
    //NSBundle.mainBundle()

    guard let filePath = bundle.path(forResource: fileName, ofType: "json", inDirectory: directory) else {
      fatalError("Failed to find file '\(fileName)' in path '\(directory)' ")
    }
    
    let templateURL = URL(fileURLWithPath: filePath)
    if let data = try? Data(contentsOf: templateURL) {
      return convertDataToDictionary(data)
    }
    return nil
  }
  
  
  //http://stackoverflow.com/questions/30480672/how-to-convert-a-json-string-to-a-dictionary
  func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
    if let data = text.data(using: String.Encoding.utf8) {
//      do {
//        let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
//        return json
//      }
//      catch let error as NSError {
//        print(error.localizedDescription)
//      }
      return convertDataToDictionary(data)
    }
    return nil
  }
  
  func convertDataToDictionary(_ data: Data) -> [String:AnyObject]? {
    do {
      let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
      return json
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    return nil
  }

  
  func testHeaderInC32() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //record.header = nil
      
      let x = record.export(inFormat: .c32)
      //      let x = record.export(inFormat: .ccda)
      print(x)
    }
    catch {
    }
  }

  func testHeaderInCCDA() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //record.header = nil
      
      let x = record.export(inFormat: .ccda)
      //      let x = record.export(inFormat: .ccda)
      print(x)
    }
    catch {
    }
  }

  func testGlobalHeaderAcrossRecords() {

    var header: CDAKQRDAHeader?
    var records: [CDAKRecord] = []
    var files: [String] = ["Patient-673", "Vitera_CCDA_SMART_Sample", "export_cda"]
    

    for file in files {
      let doc = TestHelpers.fileHelpers.load_xml_string_from_file(file)
      do {
        let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
        records.append(record)
        if records.count == 1 {
          header = record.header
        } else {
          record.header = header
        }
      }
      catch {
      }
    }
    
    for record in records {
      XCTAssertEqual(record.header?.description, header?.description)
      //print(record.export(inFormat: .ccda))
    }
  }

  
  func testViteraImport() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Vitera_CCDA_SMART_Sample")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      //record.header = nil
      
//      for encounter in record.encounters {
//        print(encounter.performer)
//      }
      
      //let x = record.export(inFormat: .ccda)
      let x = record.export(inFormat: .c32)
      print(x)
    }
    catch {
    }
  }

  
  func testTemplatesFromDifferentDirectories() {
    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
    do {
      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
      
//      print(record.header?.json)
      
//      let repo = TemplateRepository(
//        bundle: CDAKCommonUtility.bundle,
//        templateExtension: "mustache")

      let repo = TemplateRepository(bundle: CDAKCommonUtility.bundle)
//      print(CDAKCommonUtility.bundle)
      
      
//      let filemanager:NSFileManager = NSFileManager()
//      let files = filemanager.enumeratorAtPath(CDAKCommonUtility.bundle.bundlePath)
//      while let file = files?.nextObject() {
//        print(file)
//      }

//      let enumerator = NSFileManager.defaultManager().enumeratorAtPath(CDAKCommonUtility.bundle.bundlePath)
//      var filePaths = [NSURL]()
//      
//      while let filePath = enumerator?.nextObject() as? String {
//        print(filePath)
//      }

      
      
//      let repo = TemplateRepository(directoryPath: "/health-data-standards/templates")

      //      let repo = TemplateRepository(bundle: NSBundle.mainBundle())
      
//      let repo = TemplateRepository(bundle: NSBundle(forClass: self.dynamicType))
      
      //NSBundle.mainBundle()
      
//      print(repo)
      
      let format = "c32"
      //c32_show.c32.mustache
//      let template_name = "\(format)_show.\(format).mustache"
      let template_name = "c32_show.c32"
      do {
//        let template = try repo.template(named: "health-data-standards/templates/\(format)/\(format)_show.\(format)")
        let template = try repo.template(named: template_name)
        
        
        let data = ["patient": record]
        
        template.registerInBaseContext("each", Box(StandardLibrary.each))
        template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))
        template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
        template.registerInBaseContext("date_as_string", Box(MustacheFilters.DateAsHDSString))
        template.registerInBaseContext("value_or_null_flavor", Box(MustacheFilters.value_or_null_flavor))
        template.registerInBaseContext("oid_for_code_system", Box(MustacheFilters.oid_for_code_system))
        template.registerInBaseContext("is_numeric", Box(MustacheFilters.is_numeric))
        template.registerInBaseContext("is_bool", Box(MustacheFilters.is_bool))
        
        
        do {
          let rendering = try template.render(Box(data))
          
          print("trying to render...")
          print("======================")
          print(rendering)
          print("======================")
          print("rendering complete.")
        }
        catch let error as MustacheError {
          print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
        }
        catch let error as NSError {
          print(error.localizedDescription)
        }

        
      }
      catch {
        print("no template found '\(template_name)'")
      }
      
//      let template_helper = CDAKTemplateHelper(template_format: "c32", template_subdir: "c32", template_directory: nil)
//      let template = template_helper.template("show")
      
      
      
      
    }
    catch {
      XCTFail()
    }
  }
  
//  func testHeaderGeneration() {
//    let doc = TestHelpers.fileHelpers.load_xml_string_from_file("Patient-673")
//    do {
//      let record = try CDAKImport_BulkRecordImporter.importRecord(doc)
//      
//      let template_helper = CDAKTemplateHelper(template_format: "cat1", template_subdir: "cat1", template_directory: nil)
//      let template = template_helper.template("header")
//      
//      record.header = nil
//      
//      let data = ["patient": record]
//      
//      template.registerInBaseContext("each", Box(StandardLibrary.each))
//      template.registerInBaseContext("UUID_generate", Box(MustacheFilters.UUID_generate))
//      template.registerInBaseContext("date_as_number", Box(MustacheFilters.DateAsNumber))
//      template.registerInBaseContext("date_as_string", Box(MustacheFilters.DateAsHDSString))
//      template.registerInBaseContext("value_or_null_flavor", Box(MustacheFilters.value_or_null_flavor))
//      template.registerInBaseContext("oid_for_code_system", Box(MustacheFilters.oid_for_code_system))
//      template.registerInBaseContext("is_numeric", Box(MustacheFilters.is_numeric))
//      template.registerInBaseContext("is_bool", Box(MustacheFilters.is_bool))
//      
//      
//      do {
//        let rendering = try template.render(Box(data))
//        
//        print("trying to render...")
//        print("======================")
//        print(rendering)
//        print("======================")
//        print("rendering complete.")
//      }
//      catch let error as MustacheError {
//        print("Failed to process template. Line \(error.lineNumber) - \(error.kind). Error: \(error.description)")
//      }
//      catch let error as NSError {
//        print(error.localizedDescription)
//      }
//
//      
//      
//    }
//    catch {
//      XCTFail()
//    }
//  }

  
  
}
