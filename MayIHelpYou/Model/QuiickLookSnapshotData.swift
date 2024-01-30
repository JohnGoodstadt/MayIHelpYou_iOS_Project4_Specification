//
//  SnapshotData.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 22/05/2023.
//

import Foundation

public struct QuiickLookSnapshotData : Codable {
	
	
	let lastSavedDate:Date
	
	let  company:String
	let  lessonCode:String
	let  libraryCode:LibraryCode

	
}
