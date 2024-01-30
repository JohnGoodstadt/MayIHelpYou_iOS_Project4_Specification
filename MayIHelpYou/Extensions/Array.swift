//
//  Array.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 16/04/2023.
//

import Foundation
extension Array {
  func indexExists(_ index: Int) -> Bool {
	return self.indices.contains(index)
  }
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}
