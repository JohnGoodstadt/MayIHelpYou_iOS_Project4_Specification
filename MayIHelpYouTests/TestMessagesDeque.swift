//
//  TestMessagesDeque.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 20/04/2023.
//

import XCTest
import Collections
@testable import MayIHelpYou

final class TestMessagesDeque: XCTestCase {

	var chat:PracticeChat?
	
	override func setUpWithError() throws {
		
		
		let c = StarterConversations
		
		let ml = conversationToMessageList(c)
		
		let groupedBy = OrderedDictionary(grouping: ml, by: { $0.questionNumber })

		let person1 = Person(name: "Alice", imgString: "img1")
		let chat1 = PracticeChat(person: person1, groupedBy[1]!, initialQuestionNumber: 1,conversationNumber: 1)
		
		self.chat = chat1
		//let person2 = Person(name: "Bob", imgString: "img2")
		//let chat2 = Chat(person: person2, messages: groupedBy[2]! )
		
	}


	func testChatsQue(){

		var messageQueue:Deque<ChatMessage> = []

		
		messageQueue.append(contentsOf: chat!.messages)
		
		XCTAssertEqual(27, messageQueue.count)
		
		let m = messageQueue.popFirst()
		
		XCTAssertEqual(26, messageQueue.count)
	}

	func testChatToDictionaries(){
		
		let numbers = [3, 7, 4, -2, 9, -6, 10, 1]
		let positivePrefix = numbers.prefix(while: { $0 > 0 })
		// positivePrefix == [3, 7, 4]
		
		var preamble = Dictionary<String, [ChatMessage]>()
		var questions = Dictionary<String, [ChatMessage]>()
		var postamble = Dictionary<String, [ChatMessage]>()
		
		
		chat!.messages.forEach{
			var m1 = [ChatMessage]()
			
			if $0.rowType != .question {
				m1.append($0)
			}
			
			
			
		}
		
		let topChunk = chat!.messages.prefix(while: { $0.rowType != .question})
		
		XCTAssertEqual(5, topChunk.count)
		
		
	}

}
