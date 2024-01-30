//
//  Thread.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 12/04/2023.
//

import Foundation
//https://medium.com/@theinkedengineer/check-if-app-is-running-unit-tests-the-swift-way-b51fbfd07989
extension Thread {
  var isRunningXCTest: Bool {
	for key in self.threadDictionary.allKeys {
	  guard let keyAsString = key as? String else {
		continue
	  }
	
	  if keyAsString.split(separator: ".").contains("xctest") {
		return true
	  }
	}
	return false
  }
	var isNotRunningXCTest: Bool {
		!isRunningXCTest
	}
}
