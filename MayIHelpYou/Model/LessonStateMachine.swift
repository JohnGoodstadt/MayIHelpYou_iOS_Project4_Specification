//
//  LessonsStateMachine.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 12/04/2023.
//

import Foundation

protocol LessonState {
	func nextState() -> LessonState
	func previousState() -> LessonState
}

class NotStartedState: LessonState {
	func nextState() -> LessonState {
		return StartedState()
	}
	func previousState() -> LessonState {
		return self
	}
}

class StartedState: LessonState {
	func nextState() -> LessonState {
		return WaitingState()
	}
	func previousState() -> LessonState {
		return self
	}
}

class WaitingState: LessonState {
	func nextState() -> LessonState {
		return CompleteState()
	}
	func previousState() -> LessonState {
		return NotStartedState()
	}
}

class CompleteState: LessonState {
	func nextState() -> LessonState {
		return PostCompleteState()
	}
	func previousState() -> LessonState {
		return self
	}
}

class PostCompleteState: LessonState {
	func nextState() -> LessonState {
		return self
	}
	func previousState() -> LessonState {
		return self
	}
}

class LessonStateMachine {
	var currentState: LessonState {
		didSet {
			UserDefaults.standard.set(String(describing: currentState), forKey: "currentState")
			//print("saving current state:\(currentState)")
		}
	}
	init(_ savedState:LessonState = NotStartedState()) {
		//print("init() saved state \(savedState)")
		currentState = savedState
	}
	
	func nextState() {
		currentState = currentState.nextState()
	}
	
	func previousState() {
		currentState = currentState.previousState()
	}
}
/*
 // Example usage
 let stateMachine = LessonStateMachine()
 print(stateMachine.currentState) // prints the saved state or defaults to NotStartedState if no state has been saved
 stateMachine.nextState()
 print(stateMachine.currentState) // FirstState
 stateMachine.nextState()
 print(stateMachine.currentState) // SecondState
 stateMachine.previousState()
 print(stateMachine.currentState) // FirstState
 stateMachine.nextState()
 print(stateMachine.currentState) // SecondState
 stateMachine.nextState()
 print(stateMachine.currentState) // ThirdState
 stateMachine.nextState()
 print(stateMachine.currentState) // CompletedState
 stateMachine.nextState()
 print(stateMachine.currentState) // CompletedState
 stateMachine.previousState()
 print(stateMachine.currentState) // ThirdState
 */

