//
//  InductionChatModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 10/05/2023.
//

import Foundation


struct InductionChat: Identifiable, CustomStringConvertible {
	var id: UUID { avatar.id }
	let avatar: Avatar
	var messages: [InductionMessage]
	var hasUnreadMessage = false
	var sortNumber = 1
	
	var description: String {
		return "p:\(self.avatar.name)  mcq:\(self.messages.count))"
	}
}

struct InductionMessage: Identifiable {
	
	enum MessageType {
		case Sent, Received
	}
	
	enum RowType {
		case text,login,logout,lessoncode,url,continuelesson,authmessage,unknown
	}

	enum DocType {
		case dress,covid,dept,unknown
	}
	
	let id = UUID()
	let date: Date
	let text: String
	let type: MessageType
	var rowType:RowType
	var docType:DocType
	
	init(_ text: String, type: MessageType, date: Date, rowType:RowType = .text, sortNumber:Int = 1, docType:DocType = .unknown) {
		self.date = date
		self.text = text
		self.type = type
		self.rowType = rowType
		self.docType = docType
	}
	
	init(_ text: String, type: MessageType) {
		self.init(text, type: type, date: Date())
	}
}


#if DONT_COMPILE

extension InductionChat {
	

	
	
	static let MinimalInductionChats: [SettingsChat] = [
	
		InductionChat(avatar: InductionAvatar(name: "Induction", subTitle: "Find all Intro Company documents here", imgString: "img1"),
				 messages: [], messageQ: [
					InductionMessage("Company dress code", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1),rowType: .url,docType: .dress),
					InductionMessage("Covid policy", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1),rowType: .url,docType: .covid),
					InductionMessage("Weelkly department notes", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 1),rowType: .url,docType: .dept),
					InductionMessage("Tap any above to view", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4),rowType: .text)
				 ], hasUnreadMessage: false,sortNumber: 2)
		
	
	
	]
	
}
#endif
