//
//  CommunityTabCategories.swift
//  PronounceIt
//
//  Created by John goodstadt on 18/02/2023.
//

import Foundation
import SwiftUI

enum LessonStateEnum: Int, Codable, CustomStringConvertible {
	var description: String {
		switch self {
			case .notStarted:return "Not Started"
			case .started:return "Started"
			case .waiting:return "Waiting"
			case .complete:return "Complete"
			case .postComplete:return "After Completed"
		}
	}
	
	case notStarted
	case started
	case waiting
	case complete
	case postComplete
	
	
	var stateForDB: Int {
		self.rawValue
	}
	var stateForPrinting: String {
		switch self {
			case .notStarted:
				return "Not Started"
			case .started:
				return "Started"
			case .waiting:
				return "waiting"
			case .complete:
				return "Complete"
			case .postComplete:
				return "After Completion"
		}
	}
	
	
}


class Lesson: Equatable, Hashable, Identifiable, Codable {
	
	let id: Int //Unique id. For now id and lessonNumber are the same
	var lessonNumber: Int // this should be the unique lesson Number.
	var packNumber:Int = 1//move to lessonNumber
	var title: String //displayable string
	var selected: Bool //which TAB is currently selected
	var playCycle:Int = 0 //if hear target is 4 then this indiocates which cycle we are in 1,2,3,4 (and so complete)
	var waiting = false //true when part of lesson complete - but stops to quick reminder
	var waitTimeTarget:Date = Date() //will be future date
	var complete = false //full completion of of all phrases in lesson
	var additional:String = ""
	var sortNumber:Int = 1 //if the ID is not the same as sort order
	var lessonState:LessonStateEnum = .notStarted
	
	var linkTitle:String = ""
	var linkLink:String = ""
	var linkType:String = ""
	var startDate:Date = Date(timeIntervalSince1970: 0)  //Date.distantPast does not work on firebase timestamp
	var endDate:Date = Date().futureDate(years: 10) //Date.distantFuture
	

	init (id: Int , title: String, selected: Bool) {
		self.id = id
		self.lessonNumber = id
		self.title = title
		self.selected = selected
	}
	
	init (id: Int , title: String, selected: Bool, additional:String) {
		self.id = id
		self.lessonNumber = id
		self.title = title
		self.selected = selected
		self.additional = additional
	}
	
	init (id: Int , title: String, selected: Bool, additional:String, linkTitle:String, linkLink:String, linkType:String) {
		self.id = id
		self.lessonNumber = id
		self.title = title
		self.selected = selected
		self.additional = additional
		self.linkTitle = linkTitle
		self.linkLink = linkLink
		self.linkType = linkType
	}

	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		id =  try values.decodeIfPresent(Int.self, forKey: .id) ?? 1
		
		lessonNumber =  try values.decodeIfPresent(Int.self, forKey: .lessonNumber) ?? 1
		
		title =  try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		selected =  try values.decodeIfPresent(Bool.self, forKey: .selected) ?? false
		playCycle =  try values.decodeIfPresent(Int.self, forKey: .playCycle) ?? 0
		//waiting =  try values.decodeIfPresent(Bool.self, forKey: .waiting) ?? false
		waitTimeTarget =  try values.decodeIfPresent(Date.self, forKey: .waitTimeTarget) ?? Date()
		//complete =  try values.decodeIfPresent(Bool.self, forKey: .complete) ?? false
		additional =  try values.decodeIfPresent(String.self, forKey: .additional) ?? ""
		sortNumber =  try values.decodeIfPresent(Int.self, forKey: .sortNumber) ?? 0
		
		let state =   try values.decodeIfPresent(Int.self, forKey: .lessonState) ?? 0
		switch state {
			case 0:lessonState = .notStarted
			case 1:lessonState = .started
			case 2:lessonState = .waiting
			case 3:lessonState = .complete
			case 4:lessonState = .postComplete
			default:
				lessonState = .notStarted
		}
		
		linkTitle =  try values.decodeIfPresent(String.self, forKey: .linkTitle) ?? ""
		linkLink =  try values.decodeIfPresent(String.self, forKey: .linkLink) ?? ""
		linkType =  try values.decodeIfPresent(String.self, forKey: .linkType) ?? ""
	
		startDate =  try values.decodeIfPresent(Date.self, forKey: .startDate) ?? Date(timeIntervalSince1970: 0)
		endDate =  try values.decodeIfPresent(Date.self, forKey: .endDate) ??  Date().futureDate(years: 10)
		
	
	}
	static func == (lhs: Lesson, rhs: Lesson) -> Bool {
		lhs.id == rhs.id
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
//Subset of above
class LessonStateForUser: Equatable, Hashable, Identifiable, Codable {
	var id: Int
	var playCycle:Int = 0 //if hear target is 4 then this indiocates which cycle we are in 1,2,3,4 (and so complete)
	//var waiting = false //true when part of lesson complete - but stops to quick reminder
	var waitTimeTarget:Date = Date() //will be future date
	//var complete = false //full completion of of all phrases in lesson
	var lessonState:LessonStateEnum = .notStarted
	
	init(id:Int){
		self.id = id
	}
	
	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		id =  try values.decodeIfPresent(Int.self, forKey: .id) ?? 1
		

		playCycle =  try values.decodeIfPresent(Int.self, forKey: .playCycle) ?? 0
		//waiting =  try values.decodeIfPresent(Bool.self, forKey: .waiting) ?? false
		waitTimeTarget =  try values.decodeIfPresent(Date.self, forKey: .waitTimeTarget) ?? Date()
		//complete =  try values.decodeIfPresent(Bool.self, forKey: .complete) ?? false
		
		let state =   try values.decodeIfPresent(Int.self, forKey: .lessonState) ?? 0
		switch state {
			case 0:lessonState = .notStarted
			case 1:lessonState = .started
			case 2:lessonState = .waiting
			case 3:lessonState = .complete
			case 4:lessonState = .postComplete
			default:
				lessonState = .notStarted
		}
		
		//print("LessonStateForUser id:\(id) state:\(state) state:\(lessonState)")
		
		
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	static func == (lhs: LessonStateForUser, rhs: LessonStateForUser) -> Bool {
		lhs.id == rhs.id
	}
}
