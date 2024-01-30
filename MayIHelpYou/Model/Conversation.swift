//
//  Card.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 29/03/2023.
//

import Foundation
 enum QuestionState: Int, Decodable, CustomStringConvertible  {
	 
	 var description: String {
		 switch self {
			 case .question:
				 return "Question"
			 case .correct:
				 return "Correct"
			 case .incorrect:
				 return "Incorrect"
			 case .completed:
				 return "Completed"
		 }
	 }
	 
	case question
	case correct
	case incorrect
	case completed
	
//	init(from decoder: Decoder) throws {
//		let container = try decoder.singleValueContainer()
//		let status = try? container.decode(Int.self)
//		switch status {
//			  case 0: self = .question
//			  case 1: self = .correct
//			  case 2: self = .incorrect
//			  case 3: self = .completed
//
//			case .none:
//				self = .question
//			case .some(_):
//				self = .question
//		}
//	  }
	
	var desc: String {
		switch self {
				
			case .question:
				return "Question"
			case .correct:
				return "Correct"
			case .incorrect:
				return "Incorrect"
			case .completed:
				return "Completed"
		}
	}
}

class Conversation:  Codable, Hashable, Identifiable {
	
	
	static func == (lhs: Conversation, rhs: Conversation) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	var id:Int
	var conversationNumber:Int
	var sortNumber:Int
	var prompt: String = ""
	var correctChoice: String = ""
	var wrongChoice1: String = ""
	var wrongChoice2: String = ""
	var correctExplanation: String = ""
	var wrong1Explanation: String = ""
	var wrong2Explanation: String = ""
	var createdDate: Date = Date(timeIntervalSince1970: 0)
	var updatedDate: Date = Date(timeIntervalSince1970: 0)
	
//	var conversationState:QuestionState = .question
	var conversationState:Int = 0
	
	init(
		id:Int = 999999,
		conversationNumber: Int = 1,
		sortNumber: Int  = 1,
		prompt:String = "",
		correctChoice:String = "",
		wrongChoice1:String,
		wrongChoice2:String,
		correctExplanation:String = "",
		wrong1Explanation:String = "",
		wrong2Explanation:String = "",
		createdDate:Date,
		updatedDate:Date,
		//TODO: change to ENUM
//		conversationState:QuestionState = .question
		conversationState:Int = 0// = .question

	){
		self.id = id
		self.conversationNumber = conversationNumber
		self.sortNumber = sortNumber
		self.prompt = prompt
		self.correctChoice = correctChoice
		self.wrongChoice1 = wrongChoice1
		self.wrongChoice2 = wrongChoice2
		self.correctExplanation = correctExplanation
		self.wrong1Explanation = wrong1Explanation
		self.wrong2Explanation = wrong2Explanation

		self.createdDate = createdDate
		self.updatedDate = updatedDate
		self.conversationState = conversationState

		if self.wrong1Explanation.isEmpty {
			self.wrong1Explanation = "Wrong Explanation 1"
		}
		
		if self.wrong2Explanation.isEmpty {
			self.wrong2Explanation = "Wrong Explanation 2"
		}
		
	}
	
	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
	
		id =  try values.decodeIfPresent(Int.self, forKey: .id) ?? 1
		conversationNumber =  try values.decodeIfPresent(Int.self, forKey: .conversationNumber) ?? 1
		sortNumber =  try values.decodeIfPresent(Int.self, forKey: .sortNumber) ?? 0
		prompt =  try values.decodeIfPresent(String.self, forKey: .prompt) ?? ""
		correctChoice =  try values.decodeIfPresent(String.self, forKey: .correctChoice) ?? ""
		wrongChoice1 =  try values.decodeIfPresent(String.self, forKey: .wrongChoice1) ?? ""
		wrongChoice2 =  try values.decodeIfPresent(String.self, forKey: .wrongChoice2) ?? ""
		correctExplanation =  try values.decodeIfPresent(String.self, forKey: .correctExplanation) ?? ""
		wrong1Explanation =  try values.decodeIfPresent(String.self, forKey: .wrong1Explanation) ?? ""
		wrong2Explanation =  try values.decodeIfPresent(String.self, forKey: .wrong2Explanation) ?? ""
	
		conversationState =  try values.decodeIfPresent(Int.self, forKey: .conversationState) ?? 0
		
//		let state =   try values.decodeIfPresent(Int.self, forKey: .conversationState) ?? 0
//		switch state {
//			case 0:conversationState = .question
//			case 1:conversationState = .correct
//			case 2:conversationState = .incorrect
//			case 3:conversationState = .completed
//			default:
//				conversationState = .question
//		}
	}
}

struct ConversationDoc: Encodable {
	let id:Int
	let conversationNumber:Int
}

struct ConversationStatistic: Hashable, Identifiable, Codable {
	var id:String
	var mistakeCount:Int = 1
	var correctCount:Int = 1
	var createdDate:Date = Date()
	var updatedDate:Date = Date()
}
