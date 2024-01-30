//
//  WTDNModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 10/05/2023.
//

import Foundation

struct WTDNChat: Identifiable, CustomStringConvertible {
	var id: UUID { avatar.id }
	let avatar: Avatar
	var messages: [WTDNMessage]
	var messageQ: [WTDNMessage]
	var hasUnreadMessage = false
	var sortNumber = 1
	
	var description: String {
		return "p:\(self.avatar.name)  mcq:\(self.messages.count))"
	}
	
	init(avatar: Avatar,_ messageQ:[WTDNMessage]) {
		self.avatar = avatar
		self.messages = [WTDNMessage]()
		self.messageQ = messageQ
		
	}
}

struct WTDNMessage: Identifiable {
	
	enum MessageType {
		case Sent, Received
	}
	
	enum RowType {
		case text,option1,option2,goToPhraseLibrary,goToPractice,goToLesson,unknown
	}
	
	enum BucketType {
		case preamble,postOption2,
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


extension WTDNChat {

	
//	static let messages:[WTDNMessage] = []
	
	static let messages:[WTDNMessage] = [
		WTDNMessage("Hi <spokenname>",bucketType: .preamble),
		WTDNMessage("This chat thread is here to help you find the most useful things to do",bucketType: .preamble),
		WTDNMessage("When you come to this chat thread we’ll suggest some of the thing you can do next",bucketType: .preamble),
		WTDNMessage("Shall I make a suggestion?",bucketType: .preamble),
		WTDNMessage("Yes please",rowType:.option1, bucketType: .preamble, isButton: .normal),
		WTDNMessage("Not right now",rowType:.option2, bucketType: .preamble, isButton: .normal),
		
		WTDNMessage("No problem, come back when your're ready",bucketType: .postOption2),
		
		//not yet
		//WTDNMessage("<lessontitle>",bucketType: .postOption2),
	]
	
	static let messagesObsolete = [WTDNMessage("Company dress code.", type: .Received,rowType: .unknown),
						   WTDNMessage("Covid policy", type: .Received,rowType: .unknown),
						   WTDNMessage("Weelkly department notes", type: .Received,rowType: .unknown),
						   WTDNMessage("Tap any above to view", type: .Received,rowType: .text)]
	

}
