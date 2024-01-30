//
//  TestLoginStateMachine.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 07/05/2023.
//

import XCTest
@testable import MayIHelpYou

final class TestNotLoggedInStateMachine: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNewSignIn() throws {
		
		let stateMachine = LogInStateMachine()

		XCTAssert(stateMachine.getCurrentState == LogInState.notLoggedIn)
		
		
		print("Current state: \(stateMachine.getCurrentState)")
		print("Login with Apple/Google/phone/email")
		stateMachine.transition(to: .loginWithApple)
		XCTAssert(stateMachine.getCurrentState == LogInState.loginWithApple)
		let loginWithAppleSuccess = stateMachine.login() //50%
		if loginWithAppleSuccess {
			print("Login with Apple succeeded!")
			
			XCTAssert(stateMachine.getCurrentState == LogInState.loginSuccess)
			
			stateMachine.transition(to: .checkRegistered)
			let checkRegistered = stateMachine.checkRegistered() //50%
			if checkRegistered {
				printhires("Register check success.")
				XCTAssert(stateMachine.getCurrentState == LogInState.registerSuccess)
				
				stateMachine.transition(to: .courseCode)
				let courseCodeSuccess = stateMachine.checkCourseCode() //50%
				if courseCodeSuccess {
					printhires("Course Code check success.")
				}else{
					
					printhires("Course Code check failed.")
					
					//either
					print("not registered or invalid code")
					print("do same options:")
					
					print("2 options")
					print("1 try again")
					print("2 Ask to be registered")
				}
				
			}else{
				printhires("Register check failed.")
				XCTAssert(stateMachine.getCurrentState == LogInState.loginSuccess)
				
				print("No Problem")
				print("Please let us know your name")
				print("Please let us know your organisation")
				print("Please let us know your email")
				print("Please let us know your course code\n")
				
				//generate email Registration Team
			}
			
			
		} else {
			print("Login with Apple failed.")
			
			XCTAssert(stateMachine.getCurrentState == LogInState.loginWithApple)
			
		}

		
		
		stateMachine.transition(to: .askForInfo)
		stateMachine.transition(to: .loginSuccess)
    }

  

}
