//
//  DataManager+Admin.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 05/04/2023.
//

import Foundation
import SwiftUI

//Used By Admin pages
extension DataManager {
//	func updatePhraseProperty999<T>(_ code:String, property:String, value:T, UID:String){
//		fbUpdatePhraseProperty(default LibraryCode, property: fb.phrase, value: value, UID: phrase.id)
//	}
	func addPhrase(_ phrase:Phrase) {
		phrases.insert(phrase, at: 0)
	}
	func addConversation(_ conversation:Conversation) {
		conversations.append(conversation)
	}
	func addQuestionToConversation(UID:Int, question:Conversation) {
		if let _ = conversations.firstIndex(where: { $0.id == UID}) {
			conversations.append(question)
		}
	}
	func updateConversation(UID:Int) {
		//force update
		if let idx = conversations.firstIndex(where: { $0.id == UID}) {
			conversations[idx] = conversations[idx]
		}
	}
	func updatePhrase(UID:String) {
		//force update
		if let idx = phrases.firstIndex(where: { $0.id == UID}) {
			phrases[idx] = phrases[idx]
		}
	}
	func updateLesson(UID:Int) {
		//force update
		if let idx = lessons.firstIndex(where: { $0.id == UID}) {
			lessons[idx] = lessons[idx]
		}
	}
	func updateCategory(UID:Int) {
		//force update
		if let idx = phraseCategories.firstIndex(where: { $0.id == UID}) {
			phraseCategories[idx] = phraseCategories[idx]
		}
	}
	func addPhraseCategory(_ category:PhraseCategory) {
		phraseCategories.append(category)
	}
	func removePhraseCategory(UID:Int) {
		if let idx = phraseCategories.firstIndex(where: { $0.id == UID}) {
			phraseCategories.remove(at: idx)
		}
	}
	func removePhrase(UID:String) {
		if let idx = phrases.firstIndex(where: { $0.id == UID}) {
			phrases.remove(at: idx)
		}
	}
	func updateCategories() {
		//force update in collection
		
		guard !phraseCategories.isEmpty else {
				return
		}
		phraseCategories[0] = phraseCategories[0]
	}
	func addLesson(_ lesson:Lesson) {
		lessons.append(lesson)
	}
	func removeLesson(UID:Int) {
		if let idx = lessons.firstIndex(where: { $0.id == UID}) {
			lessons.remove(at: idx)
		}
	}
	func doesLessonHavePhrases(UID:Int) -> Bool {
		phrases.contains(where: { $0.lessonNumber == UID})
	}
	func doesLessonHavePhrasesHint(UID:Int,_ length:Int = 20) -> String {
		if let idx = phrases.firstIndex(where: { $0.lessonNumber == UID}) {
			return String(phrases[idx].phrase.prefix(length))
		}
		
		return ""
	}
	func doesPhraseCategoryHavePhrases(UID:Int) -> Bool {
		phrases.contains(where: { $0.categoryNumber == UID})
	}
	func doesPhraseCategoryHavePhrasesHint(UID:Int,_ length:Int = 20) -> String {
		if let idx = phrases.firstIndex(where: { $0.categoryNumber == UID}) {
			return String(phrases[idx].phrase.prefix(length))
		}
		
		return ""
	}
	func highestLessonNumber() -> Int {
		
		guard !lessons.isEmpty else { return 0 }
		
		//let sortedAsc = lessons.sorted(by: { $0.lessonNumber < $1.lessonNumber })
		//let sortedDesc = lessons.sorted(by: { $0.lessonNumber > $1.lessonNumber })
		
		let sorted = lessons.sorted(by: { $0.lessonNumber > $1.lessonNumber })
		return sorted.first?.lessonNumber ?? 0
		

	}
	func highestPhraseCategoryNumber() -> Int {
		
		guard !phraseCategories.isEmpty else { return 0 }
		
		let sorted = phraseCategories.sorted(by: { $0.categoryNumber > $1.categoryNumber })
		return sorted.first?.categoryNumber ?? 0
		

	}
	func highestConversationID() -> Int {
		
		guard !conversations.isEmpty else { return 0 }
		
		return conversations.map { $0.id }.max() ?? 0
		
		//let sorted = conversations.sorted(by: { $0.id > $1.id })
		//return sorted.first?.id ?? 0
		

	}
	
	func highestConversationNumber() -> Int {
		
		guard !conversations.isEmpty else { return 0 }
		
		return conversations.map { $0.conversationNumber }.max() ?? 0
		
//		let sorted = conversations.sorted(by: { $0.conversationNumber > $1.conversationNumber })
//		return sorted.first?.conversationNumber ?? 0
		

	}
}
