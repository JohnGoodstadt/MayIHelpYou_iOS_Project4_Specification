//
//
//  Chat.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  


import Foundation

//You chat With a Person
struct PracticeChat: Identifiable, CustomStringConvertible, Codable {
	var description: String {
		return "p:\(self.avatar.name) qn:\(self.currentQuestionNumber) mcq:\(self.messages.count) mc:\(self.messageQ.count)"
	}
	
	
	
	var id: UUID { avatar.id }
	let avatar: Avatar
	var messages: [ChatMessage] //fills as user responds
	var messageQ: [ChatMessage] //original message list from DB. Will fill messages[] list
	var conversationNumber: Int
	var currentQuestionNumber: Int = 1 //(or chat number/) if 4 questions in a conversation the this is 1 to 4
	var completedCurrentQuestion = false //split before and after 'carry on' button
	var completed: Bool = false
	var attempts: Int = 1 //will be overwritten by chate state for user
	var spokenname: String
	
	
	var hasUnreadMessage = false
	var sortNumber = 1
	
	
	init(avatar: Avatar,_ messageQ:[ChatMessage], messages:[ChatMessage] = [ChatMessage](),spokenname:String, initialQuestionNumber:Int = 1, conversationNumber:Int = 1 ) {
		self.avatar = avatar
		self.messages = [ChatMessage]()
		self.messageQ = messageQ
		self.currentQuestionNumber = initialQuestionNumber
		self.conversationNumber = conversationNumber
		self.spokenname = spokenname
		
		rollForwardToQuestion(initialQuestionNumber)
	}
	mutating func resetState(){
		
		rollForwardToQuestion(1)
	}
	mutating func rollForwardToQuestion(_ questionNumber:Int){
		
		self.messages.removeAll()
		self.currentQuestionNumber = questionNumber
		self.completedCurrentQuestion = false
		self.completed = false
		if questionNumber == 1 {
			
			var bucket = messageQ.filter{ $0.questionNumber == 1 && $0.bucketType == .question}
			for (index, _) in bucket.enumerated() {
				bucket[index].text = replacePlaceholders(bucket[index].text)
			}
			self.messages.append(contentsOf:bucket )
		}else{
			//get success path for previous messages and then just the question for last question
			let preQuestion =  self.messageQ.filter({
				$0.questionNumber < questionNumber &&
				($0.rowType == .prompt ||
				$0.rowType == .correct ||
				$0.rowType == .correctExplanation )
			})
			
			let thisQuestion =  self.messageQ.filter{ $0.questionNumber == questionNumber && $0.bucketType == .question}
			let allMessages = preQuestion + thisQuestion
			self.messages.append(contentsOf: allMessages )
		}
	}
	
	mutating func incQN(){
		self.currentQuestionNumber += 1
	}
	
	
	fileprivate func replacePlaceholders(_ text: String) -> String {

		if text.contains(placeholder.spokenname) {
			return text.replacingOccurrences(of: placeholder.spokenname, with: self.spokenname)
		}

		return text
	}
}

struct ChatMessage: Identifiable, Codable {
	
	enum MessageType: Codable {
		case Sent, Received, Question
	}
	
	enum RowType: Codable {
		case intro,prompt,wrong1,wrong2,correct,question,congrats,more,
			 correctResponse,incorrectResponse,
			 correctExplanation,incorrect1Explanation,incorrect2Explanation,
			 complete,restart, unknown
	}
	
	enum BucketType: Codable {
		case question, postCorrect, postWrong1, postWrong2, completed
		
	}
	
	var id = UUID()
	//var sortNumber: Int = 1 //so we know messages are in the correct order
	let date: Date //Not used in Chat View
	var text: String
	let type: MessageType //sent or received
	var questionNumber:Int
	var rowType:RowType
	var bucketType:BucketType
	var isButton = false
	
	init(_ text: String, type: MessageType, date: Date) {
		self.date = date
		self.text = text
		self.type = type
		self.questionNumber = 1
		self.rowType = .unknown
		self.bucketType = .question
		self.isButton = false //because .question
	}
	
	init(_ text: String, type: MessageType) {
		self.init(text, type: type, date: Date())
	}
	init(_ text: String, type: MessageType, rowType: RowType) {
		self.questionNumber = 1
		self.text = text
		self.type = type
		self.date = Date()
		self.rowType = rowType
		self.bucketType = .question
		self.isButton = false //because .question
	}
	init(_  questionNumber:Int, _ text: String, type: MessageType = .Received) {
		self.questionNumber = questionNumber
		self.text = text
		self.type = type
		self.date = Date()
		self.rowType = .unknown
		self.bucketType = .question
		self.isButton = false //because .question
	}
	init(_  questionNumber:Int, _ text: String,_ rowType: RowType,_ bucketType:BucketType = .question) {
		self.questionNumber = questionNumber
		//self.sortNumber = sortNumber
		
		
//		#if DEBUG
//		let shortID:String = "\(id.description)"
//		self.text = "\(shortID.prefix(4)):\(questionNumber):\(text)"
//		#else
		self.text = text
//		#endif
		
		switch rowType {
			case .correct,.wrong1,.wrong2:
				self.type = .Sent
			default:
				self.type = .Received
		}
		
		self.date = Date()
		self.rowType = rowType
		self.bucketType = bucketType

		self.isButton = (rowType == .correct ||  rowType == .wrong1 ||  rowType == .wrong2 || rowType == .more  || rowType == .restart )
	}
}

struct Person: Identifiable {
	let id = UUID()
	let name: String
	let imgString: String
	let questionCount: Int
	
	init(name:String, imgString:String, questionCount:Int = 1){
		self.name = name
		self.imgString = imgString
		self.questionCount = questionCount
	}
}

class ChatStateForUser: Equatable, Hashable, Identifiable, Codable {
	var id:Int//String = UUID().uuidString
	var conversationNumber: Int
	var currentQuestionNumber: Int
	var completed = false //full completion of of all questions in the conversation
	var attempts:Int = 1// collect stats for each full attaempt at a conversation/chat
	var correctCount = 0
	var mistakeCount = 0
	var createdDate:Date = Date()
	var updatedDate:Date = Date()

	
	public required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		id =  try values.decodeIfPresent(Int.self, forKey: .id) ?? 1


		conversationNumber =  try values.decodeIfPresent(Int.self, forKey: .conversationNumber) ?? 1
		currentQuestionNumber =  try values.decodeIfPresent(Int.self, forKey: .currentQuestionNumber) ?? 1
		completed =  try values.decodeIfPresent(Bool.self, forKey: .completed) ?? false
		attempts =  try values.decodeIfPresent(Int.self, forKey: .attempts) ?? 1





	}
	init(conversationNumber:Int,currentQuestionNumber:Int,completed:Bool, attempts:Int = 1){
		self.id = conversationNumber
		self.conversationNumber = conversationNumber
		self.currentQuestionNumber = currentQuestionNumber
		self.completed = completed
		self.attempts = attempts
		self.updatedDate = Date()
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	static func == (lhs: ChatStateForUser, rhs: ChatStateForUser) -> Bool {
		lhs.id == rhs.id
	}
}
