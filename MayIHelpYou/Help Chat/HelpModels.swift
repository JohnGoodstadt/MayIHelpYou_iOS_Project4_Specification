//
//  EmptyModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 10/05/2023.
//

import Foundation

struct HelpChat: Identifiable, CustomStringConvertible {
	var id: UUID { avatar.id }
	let avatar: Avatar
	var messages: [HelpMessage]
	var messageQ: [HelpMessage]
	var hasUnreadMessage = false
	var sortNumber = 1
	
	var description: String {
		return "p:\(self.avatar.name)  mcq:\(self.messages.count))"
	}
	
	init(avatar: Avatar,_ messageQ:[HelpMessage]) {
		self.avatar = avatar
		self.messages = [HelpMessage]()
		self.messageQ = messageQ
		
	}
}

struct HelpMessage: Identifiable {
	
	enum MessageType {
		case Sent, Received
	}
	
	enum RowType {
		case text,more,howtouse,problems,
			 unknown
	}

	enum BucketType {
		case preamble,answer1,answer2,answer3,
		unknown
	}
	
	enum ButtonType {
		case normal, none
	}
	
	let id = UUID()
	let date: Date
	let text: String
	let type: MessageType
	var rowType:RowType
	var bucketType:BucketType
	var isButton:ButtonType = .none
	
	init(_ text: String, type: MessageType = .Received, rowType:RowType = .text, sortNumber:Int = 1, bucketType:BucketType = .unknown, isButton:ButtonType = .none) {
		self.date = Date()
		self.text = text
		self.type = type
		self.rowType = rowType
		self.bucketType = bucketType
		self.isButton = isButton
	}

}


extension HelpChat {

	
	static let messages:[HelpMessage] = [
		HelpMessage("This chat thread is to explain a little about the app and answer some frequently asked questions",bucketType: .preamble),
		HelpMessage("Tell me more about the app",rowType:.more, bucketType: .preamble, isButton: .normal),
		HelpMessage("How do I use the app?",rowType:.howtouse, bucketType: .preamble, isButton: .normal),
		HelpMessage("I’m having problems, can you help me?",rowType:.problems, bucketType: .preamble, isButton: .normal),
		
		HelpMessage("May I Help You is made to give you some tips and training on how to delight your customers",bucketType: .answer1),
		HelpMessage("We use small micro lessons to give you easy tips, with repetition to help you remember things easily",bucketType: .answer1),
		HelpMessage("We also got interactive practice so you can explore some different scenarios",bucketType: .answer1),
		
		HelpMessage("The app has three things for you do; Lessons, Phrases and Practice. You can navigate using the tabs at the bottom of the screen",bucketType: .answer2),
		HelpMessage("Lessons are very short listening exercises to give you some pointers on managing customers. We recommend doing these every day",bucketType: .answer2),
		HelpMessage("Phrases can be explored to show you ways of helping customers in different situations",bucketType: .answer2),
		HelpMessage("Practice is an interactive way for try some different scenarios and test your skills",bucketType: .answer2),
		HelpMessage("Go back to the Home tab for a suggestion on what to do next",bucketType: .answer2),
		
		HelpMessage("No problem, let us know what the problem is with a quick explanation",bucketType: .answer3),
		//HelpMessage("I’m having problems, can you help me?",rowType:.problems, bucketType: .answer3, isButton: .normal),
		
	]
	


}
