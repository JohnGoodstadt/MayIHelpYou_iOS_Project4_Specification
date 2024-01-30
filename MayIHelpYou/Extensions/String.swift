//
//  String.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 03/04/2023.
//

import Foundation

extension String {
	var withoutPunctuations: String {
		return self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
	}
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
	
	func matches(_ regex: String) -> Bool {
		return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
	}
	
	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: self)
	}
	
	func capitalizingFirstLetter() -> String {
		return prefix(1).capitalized + dropFirst()
	}
	
	mutating func capitalizeFirstLetter() {
		self = self.capitalizingFirstLetter()
	}
	
}
