//
//  ControlPanelViewModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 27/03/2023.
//

import Foundation

@available(iOS 15.0, *)
extension LoginView {
	@MainActor class ViewModel: ObservableObject {
		
		func isLibraryCodeValid(_ code:String) -> Bool {
			
			guard code.count == 4 else { return false }
			
			return true
		}
		
		func isSpokenNameValid(_ code:String) -> Bool {
			
			guard code.count >= 2 else { return false }
			
			return true
		}
		
	}
}
