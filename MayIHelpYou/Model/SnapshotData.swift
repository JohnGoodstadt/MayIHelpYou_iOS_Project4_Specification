//
//  SnapshotData.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 22/05/2023.
//

import Foundation

public struct SnapshotData : Codable {
	
	
	let lastSavedDate:Date
	
	let  company:String
	let  lessonCode:String
	let  libraryCode:LibraryCode
	let  phrases:[Phrase]
	let  phraseCategories:[PhraseCategory]
	let  lessons:[Lesson]
	let  chatQuestions:[PracticeChat]
	let  avatars:[Avatar]
	
	let  spokenName:String = ""// from User table
	let  voiceName:String = GOOGLE_FEMALE_VOICE
	
}
