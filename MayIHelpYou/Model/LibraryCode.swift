//
//  Code.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 29/03/2023.
//

import Foundation
import SwiftUI

class LibraryCode:  Codable, Hashable, Equatable, Identifiable {
	
	var code:String //user can update this when changing library
	var company:String
	var lessonsPerPhrase:Int
	var timeBetweenLessons:Int
	
	var lessonTabTitle:String
	var practiceTabTitle:String
	var phrasesTabTitle:String
	var lessonReminderTime:Date = Date() //stored later -- offline
	var lessonReminderOn = true //user can start/stop
	var logo = Data()
	
	
	init (code:String,
		  company:String,
		  lessonsPerPhrase:Int,
		  timeBetweenLessons:Int,
		  cardGradientHigh:[Int],
		  cardGradientLow:[Int])
	{
		self.code = code
		self.company = company
		self.lessonsPerPhrase = lessonsPerPhrase
		self.timeBetweenLessons = timeBetweenLessons
		
		self.lessonTabTitle = "Lesson"//lessonTabTitle
		self.practiceTabTitle = "Practice"//practiceTabTitle
		self.phrasesTabTitle = "Phrases"//phrasesTabTitle
//		self.cardGradientHigh = cardGradientHigh
//		self.cardGradientLow = cardGradientLow
	}
	
	
	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		code =  try values.decodeIfPresent(String.self, forKey: .code) ?? ""
		company =  try values.decodeIfPresent(String.self, forKey: .company) ?? ""
		lessonsPerPhrase =  try values.decodeIfPresent(Int.self, forKey: .lessonsPerPhrase) ?? 4
		timeBetweenLessons =  try values.decodeIfPresent(Int.self, forKey: .timeBetweenLessons) ?? 240 //minutes
		lessonTabTitle =  try values.decodeIfPresent(String.self, forKey: .lessonTabTitle) ?? "Lesson;"
		practiceTabTitle =  try values.decodeIfPresent(String.self, forKey: .practiceTabTitle) ?? "Practice;"
		phrasesTabTitle =  try values.decodeIfPresent(String.self, forKey: .phrasesTabTitle) ?? "Lesson;"
		logo =  try values.decodeIfPresent(Data.self, forKey: .logo) ?? Data()
		
		print("init(from decoder '\(lessonTabTitle)' for code:\(code)")
		
		
	}
	var COLORHigh: Color {
//		Color(red: Double(cardGradientHigh[0]), green: Double(cardGradientHigh[1]), blue: Double(cardGradientHigh[2]))
		Color(red: Double(255), green: Double(0), blue: Double(89))
	}
	var COLORLow: Color {
//		Color(red: Double(cardGradientLow[0]), green: Double(cardGradientLow[1]), blue: Double(cardGradientLow[2]))
		Color(red: Double(255), green: Double(128), blue: Double(155))
	}
	
	static func == (lhs: LibraryCode, rhs: LibraryCode) -> Bool {
		lhs.code == rhs.code
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}



