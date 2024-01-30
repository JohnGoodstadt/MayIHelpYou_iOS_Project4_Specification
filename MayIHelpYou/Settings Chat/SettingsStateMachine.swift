//
//  ALIStateMachine.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 07/05/2023.
//

import Foundation

// Define the possible states of the state machine.
enum LoggedInState {
	case loggedIn
	case changeLibrayCode //also get code from user
	case changingLibrayCode //waiting for async to return
	case changedLibrayCodeSuccess //async result good
	case changedLibrayCodeError //async result bad
	case changeSpokenName
	case changeSpokenNameSuccess
	case cchangeSpokenNameError
	case logout
	case loggingOut
	case loggingOutSuccess
	case loggingOutError

}

// Define the state machine class.
class SettingsStateMachine: CustomStringConvertible  {
	private var currentState: LoggedInState = .loggedIn

	var getCurrentState : LoggedInState {
		currentState
	}
	
	var description: String {
		return "\(currentState) "
	}
	
	// Define the function for transitioning to the next state.
	func transition(to state: LoggedInState) {
		switch (currentState, state) {
			case (.loggedIn, .changeLibrayCode),
				(.loggedIn, .logout),
				(.loggedIn, .changeSpokenName):
				
				currentState = state
				print("Transitioned to state: \(state)")
			case (.changeLibrayCode, .changingLibrayCode),//because of async
				(.changeLibrayCode, .changedLibrayCodeSuccess),
				(.changeLibrayCode, .changedLibrayCodeError),
				(.changingLibrayCode, .changedLibrayCodeSuccess),
				(.changingLibrayCode, .changedLibrayCodeError):
				currentState = state

			case (.changedLibrayCodeSuccess, .loggedIn)://going back
				currentState = state
			case (.changeSpokenNameSuccess, .changeLibrayCode): //did 1 action going to another action
				currentState = state
			case (.changedLibrayCodeSuccess, .changeSpokenName): //did 1 action going to the other action
				currentState = state
			case (.changeSpokenName, .changeSpokenNameSuccess):
				currentState = state
			case (.changeSpokenNameSuccess, .loggedIn):
				currentState = state


				
				
			case (.logout, .loggingOut):
				currentState = state
			case (.loggingOut, .loggingOutSuccess),
				(.loggingOut, .loggingOutError):
				currentState = state

			default:
				printhires("Invalid transition from \(currentState) to \(state)")
		}
	}
	
	// Define the function for simulating a login attempt.
	func logout() -> Bool {
		switch currentState {
			case .logout:
			// Simulate a successful logout 50% of the time.
			let success = Double.random(in: 0...1) < 0.5
			if success {
				transition(to: .loggingOutSuccess)
			} else {
				transition(to: .loggingOutError)
			}
			return success
		default:
			// Invalid state for login attempt.
			print("Cannot login from state: \(currentState)")
			return false
		}
	}

	func checkLibraryCode() -> Bool {
		switch currentState {
		case .changeLibrayCode:
			// Simulate a successful code check 50% of the time.
			let success = Double.random(in: 0...1) < 0.5
			if success {
				transition(to: .changedLibrayCodeSuccess)
			} else {
				transition(to: .changedLibrayCodeError)
			}
			return success
		default:
			// Invalid state for login attempt.
			print("Cannot check course code from state: \(currentState)")
			return false
		}
	}
}

