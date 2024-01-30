//
//  TestConversationAsChat.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 20/04/2023.
//

import XCTest
@testable import MayIHelpYou

final class Test1ConversationAsChat: XCTestCase {

	var c:[Conversation] = []
	
    override func setUpWithError() throws {
		self.c = MinimalConversations
    }

    func test1Conversion() throws {

		var chats:[PracticeChat] = [PracticeChat]()
		let person = Person(name: "Alice", imgString: "img1")
		
		var ms = [ChatMessage]()
		
		c.forEach{
			
			let cn = $0.conversationNumber
				
			ms.append(ChatMessage(cn,"Can you choose the correct answer? 1,2 or 3?",.intro))
			ms.append(ChatMessage(cn,$0.prompt,.prompt))
			ms.append(ChatMessage(cn,$0.wrongChoice1,.wrong1))
			ms.append(ChatMessage(cn,$0.wrongChoice2,.wrong2))
			ms.append(ChatMessage(cn,$0.correctChoice,.correct))
			ms.append(ChatMessage(cn,"Is it 1, 2 or 3?",.question))
			
			ms.append(ChatMessage(cn,"Well done.😅",.congrats))
			ms.append(ChatMessage(cn,"If its before noon use Good morning as the greeting.",.correctExplanation))
			ms.append(ChatMessage(cn,"Carry on? y/n",.more))
		}
		chats.append(PracticeChat(person: person, ms, initialQuestionNumber: 1,conversationNumber: 1))
		XCTAssertEqual(1, chats.count)
		
		
    }
	func test1ConversionRandomResponses() throws {

		var chats:[PracticeChat] = [PracticeChat]()
		
		let p = Person(name: "Alice", imgString: "img1")

		let intro = ["Can you choose the correct answer? 1,2 or 3?",
					 "Which of these is the correct response?"]
		
		let ask = ["Is it 1, 2 or 3?","1,2 or 3","What's the answer"]
		
		let congrats = ["Well done.😅","Correct😅"]
		
		let more = ["Carry on?","Try another? (y/n)"]
		
		var ms = [ChatMessage]()
		
		c.forEach{
			
			let cn = $0.conversationNumber
			
			ms.append(ChatMessage(cn,intro.randomElement()!,.intro))
			ms.append(ChatMessage(cn,$0.prompt,.prompt))
			ms.append(ChatMessage(cn,$0.wrongChoice1,.wrong1))
			ms.append(ChatMessage(cn,$0.wrongChoice2,.wrong2))
			ms.append(ChatMessage(cn,$0.correctChoice,.correct))
			ms.append(ChatMessage(cn,ask.randomElement()!,.question))
			
			ms.append(ChatMessage(cn,congrats.randomElement()!,.congrats))
			ms.append(ChatMessage(cn,$0.correctExplanation,.correctExplanation))
			ms.append(ChatMessage(cn,more.randomElement()!,.more))
			
		}
		
		chats.append(PracticeChat(person: p, ms, initialQuestionNumber: 1,conversationNumber: 1))
		
		
		
		XCTAssertEqual(chats[0].person.name, "Alice")
		
		
		let m = chats[0].messages
		XCTAssertEqual(m[0].rowType, .intro)
		
		
	}

}
