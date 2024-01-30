//
//  TestLessonStateMachine.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 12/04/2023.
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
/*
 let currentState = stateMachine.currentState

 // Check which state it is
 if currentState is NotStartedState {
	 print("The state machine is in the NotStartedState")
 } else if currentState is FirstState {
	 print("The state machine is in the FirstState")
 } else if currentState is SecondState {
	 print("The state machine is in the SecondState")
 } else if currentState is ThirdState {
	 print("The state machine is in the ThirdState")
 } else if currentState is CompletedState {
	 print("The state machine is in the CompletedState")
 }
 */
@MainActor class TestLessonStateMachine: XCTestCase {
//	private var dataManager:DataManager = DataManager(true)
	private var stateMachine:LessonStateMachine = LessonStateMachine()
	
	@MainActor override func setUpWithError() throws {
//		 self.dataManager = DataManager(true)
		stateMachine = LessonStateMachine()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testInitialState() throws {
		XCTAssert(stateMachine.currentState is NotStartedState)
	}

	func testMoveFromInitialState() throws {
		
		XCTAssert(stateMachine.currentState is NotStartedState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is StartedState)
	}

	func testMoveFromInitialToFinal() throws {
		
		XCTAssert(stateMachine.currentState is NotStartedState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is StartedState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is WaitingState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is CompleteState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is PostCompleteState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is PostCompleteState)
		
	}
	func testPreviousMoves() throws {
		
		XCTAssert(stateMachine.currentState is NotStartedState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is StartedState)
		stateMachine.previousState()
		XCTAssert(stateMachine.currentState is StartedState)
		
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is WaitingState)
		stateMachine.previousState()
		XCTAssert(stateMachine.currentState is NotStartedState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is StartedState)
		stateMachine.previousState()
		XCTAssert(stateMachine.currentState is StartedState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is WaitingState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is CompleteState)
		stateMachine.previousState()
		XCTAssert(stateMachine.currentState is CompleteState)
		stateMachine.nextState()
		XCTAssert(stateMachine.currentState is PostCompleteState)
		stateMachine.previousState()
		XCTAssert(stateMachine.currentState is PostCompleteState)

		
	}

	func testSavedWaitingState() throws {
		
		let savedState = WaitingState()
		stateMachine = LessonStateMachine(savedState)
		XCTAssert(stateMachine.currentState is WaitingState)
		
	}
	func testSavedPostCompleteState() throws {
		
		let savedState = PostCompleteState()
		stateMachine = LessonStateMachine(savedState)
		XCTAssert(stateMachine.currentState is PostCompleteState)
		
	}
}
