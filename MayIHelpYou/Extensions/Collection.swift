//
//  Array.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 15/04/2023.
//

import Foundation
extension Collection {
	func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
