//
//  HDSTemplateHelperTest.swift
//  CCDAccess
//
//  Created by Eric Whitley on 12/21/15.
//  Copyright © 2015 Eric Whitley. All rights reserved.
//

import XCTest

class HDSTemplateHelperTest: XCTestCase {
    
  override func setUp() {
      super.setUp()
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
  
  func test_template_finding() {

    let template_helper = HDSTemplateHelper(template_format: "c32", template_subdir: "c32", template_directory: nil)
    let erb = template_helper.template("show")
    
//    template_helper = HealthDataStandards::Export::TemplateHelper.new('c32', 'c32')
//    erb = @template_helper.template 'show'
//    assert erb
//    assert erb.filename.match(/.*show.c32.erb/)
//    assert erb.src.length > 0
//    assert erb.src.include? 'ClinicalDocument'
    
  }
  
}
