//
//  ControlPanelViewModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 27/03/2023.
//

import Foundation

@available(iOS 15, *)
extension ControlPanelView {
	@MainActor class ViewModel: ObservableObject {
		
		@Published var selectedFutureIndex: Int = 1
		
		func isLibraryCodeValid(_ code:String) -> Bool {
			
			guard code.count == 4 else { return false }
			
			return true
		}
		
		
		func calcCompletions() -> [Bool]{
			
			return []
		}
		
		func appVersion() -> String {
			
			var versionString = ""
			var versionBuild = ""
			if  let dictionary = Bundle.main.infoDictionary {
				
				var CFBundleShortVersionString = ""
				if let version = dictionary["CFBundleShortVersionString"] as! String? {
					CFBundleShortVersionString = version
				}
				let build = dictionary["CFBundleVersion"] as! String
				
				versionString = CFBundleShortVersionString
				versionBuild = build
				
				return versionString + "." + versionBuild
			}
			
			return "?"
		}
		
	}
}
