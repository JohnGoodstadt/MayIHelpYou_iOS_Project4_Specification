//
//  Test2Chats.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 20/04/2023.
//

import XCTest
import Collections
@testable import MayIHelpYou

final class TestMessagesGroupBy: XCTestCase {

	var c:[Conversation] = []
	
	override func setUpWithError() throws {
		self.c = StarterConversations
	}

	func test2Chats () {
	
		let ml = conversationToMessageList(c)
		
		XCTAssertEqual(45,ml.count)
		
	}
	func testGroupBy () {
	
		let ml = conversationToMessageList(c)
		
		let groupedBy = OrderedDictionary(grouping: ml, by: { $0.questionNumber })
		
		XCTAssertEqual(2,groupedBy.count)
		
	}

	func testFirstGroupBy () {
	
		let ml = conversationToMessageList(c)
		
		let groupedBy = OrderedDictionary(grouping: ml, by: { $0.questionNumber })
		
		let first = groupedBy[1] //dictionary
		
		XCTAssertEqual(27,first?.count)
		
	}
	func testSecondGroupBy () {
	
		let ml = conversationToMessageList(c)
		
		let groupedBy = OrderedDictionary(grouping: ml, by: { $0.questionNumber })
		
		let last = groupedBy[2] //dictionary
		
		XCTAssertEqual(18,last?.count)
		
	}
	func testFirstChat () {
	
		let ml = conversationToMessageList(c)
		
		let groupedBy = OrderedDictionary(grouping: ml, by: { $0.questionNumber })
		
		let first = groupedBy[1] //dictionary

		let person = Person(name: "Alice", imgString: "img1")
		let chat = PracticeChat(person: person, first!, initialQuestionNumber: 1,conversationNumber: 1)
		
		XCTAssertEqual(27, chat.messages.count)
		XCTAssertEqual("alice", chat.person.name.lowercased())
		
	}
	func testChats () {
	
		let ml = conversationToMessageList(c)
		
		let groupedBy = OrderedDictionary(grouping: ml, by: { $0.questionNumber })
		


		let person1 = Person(name: "Alice", imgString: "img1")
		let chat1 = PracticeChat(person: person1,  groupedBy[1]!, initialQuestionNumber: 1,conversationNumber: 1 )
		
		let person2 = Person(name: "Bob", imgString: "img2")
		let chat2 = PracticeChat(person: person2,  groupedBy[2]!, initialQuestionNumber: 1,conversationNumber: 1 )
		

		XCTAssertEqual(27, chat1.messages.count)
		XCTAssertEqual("alice", chat1.person.name.lowercased())
		
		XCTAssertEqual(18, chat2.messageQ.count)
		XCTAssertEqual("bob", chat2.person.name.lowercased())
		
	}
	

}
