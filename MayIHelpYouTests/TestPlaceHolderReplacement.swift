//
//  TestPlaceHolderReplacement.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 10/05/2023.
//

import XCTest
import FirebaseAuth

@testable import MayIHelpYou

final class TestPlaceHolderReplacement: XCTestCase {

	
	var chat = SettingsChat.sampleALIChat
	let placeholderRegex = "<[a-z]*>"
	let libraryCode = "JA56"
	let uid = "ABCD1234"
	let email = "john.goodtsadt@me.com"
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testRegEx() throws {
		
		let string = "Change Library Code from <librarycode>"
		
		XCTAssertTrue(string.matches(placeholderRegex) )
		
	}
	func testRegExMessage() throws {
		
		
		let bucket = chat.messageQ.filter{ $0.bucketType == .loggedin}
		
		XCTAssertEqual(4,bucket.count)
		
		var count = 0
		bucket.forEach {
			let text = $0.text
			if text.matches(placeholderRegex) {
				count += 1
				if text.contains(placeholder.uid) {
					if let currentUser = Auth.auth().currentUser {
						let uid = currentUser.email ?? String(currentUser.uid.prefix(4))
						let replaced = text.replacingOccurrences(of: placeholder.uid, with: uid)
						
						XCTAssertEqual("You are logged in as \(uid)",replaced)
						
					}
				}else if text.contains(placeholder.email) {
					let replaced = text.replacingOccurrences(of: placeholder.email, with: email)
					XCTAssertEqual("",replaced)
				}else if text.contains(placeholder.librarycode) {
					let replaced = text.replacingOccurrences(of: placeholder.librarycode, with: libraryCode)
					XCTAssertEqual("Change Library Code from \(libraryCode)",replaced)
					
					
					
				}else{
					fatalError()
				}
			}
		}
		XCTAssertEqual(2,count)
	}
}
