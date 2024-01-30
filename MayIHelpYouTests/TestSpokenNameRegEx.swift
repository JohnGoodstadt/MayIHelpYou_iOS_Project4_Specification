//
//  TestSpokenNameRegEx.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 11/05/2023.
//

import XCTest
@testable import MayIHelpYou

final class TestSpokenNameRegEx: XCTestCase {

	func testRegExSuccess() throws {
	   

		XCTAssertTrue("john".matches(spokenNameRegEx) )
		XCTAssertTrue("Peter".matches(spokenNameRegEx) )
		
	}
	
	func  testRegExFail() throws {
		
		XCTAssertFalse("john goodstadt".matches(spokenNameRegEx) )
		XCTAssertFalse("ab".matches(spokenNameRegEx) )
		
	}

}
