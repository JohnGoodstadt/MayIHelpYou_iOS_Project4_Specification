//
//  Card.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 29/03/2023.
//

import Foundation

class PracticeCard:  Codable, Hashable, Identifiable, CustomStringConvertible {
	static func == (lhs: PracticeCard, rhs: PracticeCard) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	var id:Int//String = UUID().uuidString
	var prompt: String = ""
	var correctOption: String = ""
	var wrongChoice1: String = ""
	var wrongChoice2: String = ""
	var explanation: String = ""
	var image: String = ""
	var gradientColors: [String] = ["ColorBlueberryDark", "ColorBlueberryLight"]
	var `description`: String = ""
	var started: Bool = false
	var createdDate: Date = Date(timeIntervalSince1970: 0)
	var updatedDate: Date = Date(timeIntervalSince1970: 0)
	var nextDate: Date = Date(timeIntervalSince1970: 0)
	
	init(
		id:Int = 999999,
		prompt:String = "",
		correctOption:String = "",
		wrongChoice1:String,
		wrongChoice2:String,
		explanation: String,
		image: String,
		gradientColors: [String],
		description: String,
		started: Bool,
		createdDate:Date,
		updatedDate:Date,
		nextDate:Date

	){
		self.id = id//999//UUID().uuidString
		self.prompt = prompt
		self.correctOption = correctOption
		self.wrongChoice1 = wrongChoice1
		self.wrongChoice2 = wrongChoice2
		self.explanation = explanation
		self.image = image
		self.gradientColors = gradientColors
		self.`description` = description
		self.started = started
		self.createdDate = createdDate
		self.updatedDate = updatedDate
		self.nextDate = nextDate
	}
}
