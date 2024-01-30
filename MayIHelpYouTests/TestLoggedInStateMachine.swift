//
//  TestLoggedInStateMachine.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 11/05/2023.
//

import XCTest
@testable import MayIHelpYou

final class TestLoggedInStateMachine: XCTestCase {



	func testLibraryCode() throws {
		
		let stateMachine = SettingsStateMachine()
		
		XCTAssert(stateMachine.getCurrentState == LoggedInState.loggedIn)
	
		
		stateMachine.transition(to: .changeLibrayCode)
		
		let libraryCodeSuccess = stateMachine.checkLibraryCode()
		
		//50:50 chance of success so run 3 times
		if libraryCodeSuccess {
			XCTAssert(stateMachine.getCurrentState == LoggedInState.changedLibrayCodeSuccess)
		}else{
			XCTAssert(stateMachine.getCurrentState == LoggedInState.changedLibrayCodeError)
		}
			
		
		if stateMachine.checkLibraryCode() {
			XCTAssert(stateMachine.getCurrentState == LoggedInState.changedLibrayCodeSuccess)
		}else{
			XCTAssert(stateMachine.getCurrentState == LoggedInState.changedLibrayCodeError)
		}
		
		
		if stateMachine.checkLibraryCode() {
			XCTAssert(stateMachine.getCurrentState == LoggedInState.changedLibrayCodeSuccess)
		}else{
			XCTAssert(stateMachine.getCurrentState == LoggedInState.changedLibrayCodeError)
		}
	}


}
