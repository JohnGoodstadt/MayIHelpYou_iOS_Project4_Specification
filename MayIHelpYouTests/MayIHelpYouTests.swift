//
//  MayIHelpYouTests.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 16/03/2023.
//



import XCTest
@testable import MayIHelpYou
/*
 Were firebase compile errors
 https://github.com/firebase/firebase-ios-sdk/issues/10049
 and
 https://stackoverflow.com/questions/60753233/the-default-firebaseapp-instance-must-be-configured-before-the-defaultfirebaseap
 */
/*
 testing blog
 https://www.swiftbysundell.com/articles/writing-testable-code-when-using-swiftui/
 */
@MainActor  class MayIHelpYouTests: XCTestCase {

	private var dataManager:DataManager = DataManager(true)
	
//	@MainActor override func setUpWithError() throws {
//		 self.dataManager = DataManager(true)
//    }
	
	@MainActor override func setUp() {
		super.setUp()
		//self.dataManager = DataManager(true)
	}
	
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLessonCount() throws {
		XCTAssertEqual(StarterLessons.count,dataManager.lessons.count)
    }

	func testPraseCount() throws {
		XCTAssertEqual(StarterPhrases.count,dataManager.phrases.count)
	}
	func testCategoryCount() throws {
		XCTAssertEqual(StarterPhraseCategories.count,dataManager.phraseCategories.count)
	}


}
