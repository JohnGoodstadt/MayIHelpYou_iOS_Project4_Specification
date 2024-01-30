//
//  MayIHelpYouAdminTests.swift
//  MayIHelpYouAdminTests
//
//  Created by John goodstadt on 06/04/2023.
//

import XCTest

@testable import MayIHelpYou_Admin

final class MayIHelpYouAdminTests: XCTestCase {

	private var dataManager:DataManager?
	
	override func setUpWithError() throws {
		dataManager = DataManager(true)
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testHighestLessonNumber() throws {
		
		XCTAssertTrue(1,dataManager.phrases.count())
		
		let i = dataManager.doesLessonHavePhrases(UID: lesson.id)
		print(i)
	}

}
