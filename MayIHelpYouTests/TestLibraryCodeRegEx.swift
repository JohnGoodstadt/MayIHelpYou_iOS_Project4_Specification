//
//  TestLibraryCodeRegEx.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 11/05/2023.
//

import XCTest
@testable import MayIHelpYou

final class TestLibraryCodeRegEx: XCTestCase {



    func testRegExSuccess() throws {
       

		XCTAssertTrue("AB12".matches(libraryCodeRegEx) )
		XCTAssertTrue("ZY98".matches(libraryCodeRegEx) )
		
    }
	
	func  testRegExFail() throws {
		
		XCTAssertFalse("AB".matches(libraryCodeRegEx) )
		XCTAssertFalse("ab12".matches(libraryCodeRegEx) )
		XCTAssertFalse("aB12".matches(libraryCodeRegEx) )
		XCTAssertFalse("Ab99".matches(libraryCodeRegEx) )
		XCTAssertFalse("12AB".matches(libraryCodeRegEx) )
		XCTAssertFalse("123B".matches(libraryCodeRegEx) )
		XCTAssertFalse("1ABC".matches(libraryCodeRegEx) )
		
	}

   

}
