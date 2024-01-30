//
//  LoginStateMachine.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 07/05/2023.
//

import Foundation

// Define the possible states of the state machine.
enum LogInState {
	case notLoggedIn
	case loggedIn
	case logInError
	case libraryCodeNotFound
	case libraryCodeGood
	
	case changeLibrayCode //also get code from user
	case changingLibrayCode //waiting for async to return
	case changedLibrayCodeSuccess //async result good
	case changedLibrayCodeError //async result bad
	case changeSpokenName
	case changeSpokenNameSuccess
	case changeSpokenNameError
	case changeSpokenNameConfirm
	case changeSpokenNameConfirmYes
	case changeSpokenNameConfirmNo
	case changeVoice
	case logInComplete

}

// Define the state machine class.
class LogInStateMachine: CustomStringConvertible  {
	private var currentState: LogInState = .notLoggedIn

	var getCurrentState : LogInState {
		currentState
	}
	
	var description: String {
		return "\(currentState) "
	}
	
	// Define the function for transitioning to the next state.
	func transition(to state: LogInState) {
		switch (currentState, state) {
			case (.notLoggedIn, .loggedIn),
				(.notLoggedIn, .logInError):
				currentState = state
				print("Transitioned to state: \(state)")
				
			case (.logInError, .loggedIn):
				currentState = state
				print("Transitioned to state: \(state)")
			case (.loggedIn, .libraryCodeNotFound),
				(.loggedIn, .libraryCodeGood),
				(.loggedIn, .changeSpokenName):
				currentState = state
				print("Transitioned to state: \(state)")

			case (.changeSpokenName, .changeSpokenNameConfirm):
				currentState = state
				print("Transitioned to state: \(state)")
				
			case (.changeSpokenNameSuccess, .changeSpokenNameConfirm):
				currentState = state
				print("Transitioned to state: \(state)")
				
			case (.changeSpokenNameConfirm, .changeSpokenNameConfirmYes),
				 (.changeSpokenNameConfirm, .changeSpokenNameConfirmNo):
				currentState = state
				print("Transitioned to state: \(state)")
			case (.changeSpokenNameConfirmNo,.changeSpokenName):
				currentState = state
				print("Transitioned to state: \(state)")
				
			case (.changeSpokenNameConfirmYes,.changeVoice):
				currentState = state
				print("Transitioned to state: \(state)")
			case (.changeSpokenNameConfirm,.logInComplete), //TODO: review changeSpokenNameConfirm
				(.changeVoice,.logInComplete):
				currentState = state
				print("Transitioned to state: \(state)")
				
				//TODO:
//			case (.changeLibrayCode, .changingLibrayCode),//because of async
//				(.changeLibrayCode, .changedLibrayCodeSuccess),
//				(.changeLibrayCode, .changedLibrayCodeError),
//				(.changingLibrayCode, .changedLibrayCodeSuccess),
//				(.changingLibrayCode, .changedLibrayCodeError):
//				currentState = state

//			case (.changedLibrayCodeSuccess, .loggedIn)://going back
//				currentState = state
//			case (.changeSpokenNameSuccess, .changeLibrayCode): //did 1 action going to another action
//				currentState = state
//			case (.changedLibrayCodeSuccess, .changeSpokenName): //did 1 action going to the other action
//				currentState = state
//			case (.changeSpokenName, .changeSpokenNameSuccess):
//				currentState = state
//			case (.changeSpokenNameSuccess, .loggedIn):
//				currentState = state


				
//
//			case (.logout, .loggingOut):
//				currentState = state
//			case (.loggingOut, .loggingOutSuccess),
//				(.loggingOut, .loggingOutError):
//				currentState = state

			default:
				printhires("Invalid transition from \(currentState) to \(state)")
		}
	}
	

}


