//
//  TestQuestionNumber.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 19/04/2023.
//

import XCTest
import Collections
@testable import MayIHelpYou

final class TestQuestionNumber: XCTestCase {
	
	
	var chats:[ChatMessage] = []
	
	var groupedBy:OrderedDictionary<Int, [ChatMessage]> = OrderedDictionary<Int, [ChatMessage]>()
	var messageQueues:[Deque<ChatMessage>] = []
	var messageQueues2: Deque<Deque<ChatMessage>> = []
	
	override func setUpWithError() throws {
		//Firebase DB
		chats.append(ChatMessage(1,"Hey Alex, can you answer this one? 👋", type: .Received))
		chats.append(ChatMessage(1,"Its 11am on a rainy Tuesday. You are near the front entrance to the store. A customer comes in through the door and pauses to look around. 👋", type: .Received))
		chats.append(ChatMessage(1,"1️⃣ Good morning, welcome to Barlows", type: .Received))
		chats.append(ChatMessage(1,"2️⃣ Good afternoon, welcome to Barlows", type: .Received))
		chats.append(ChatMessage(1,"3️⃣ Hello, nice to meet you", type: .Received))
		chats.append(ChatMessage(1,"Is it 1, 2 or 3", type: .Received))
		
		chats.append(ChatMessage(2,"Well done.😅", type: .Received))
		chats.append(ChatMessage(2,"If its before noon use Good morning as the greeting.", type: .Received))
		chats.append(ChatMessage(2,"What about this one?", type: .Received))
		chats.append(ChatMessage(2,"The customer replies 'Good morning' and looks past you into the store, they are scanning the aisles.", type: .Received))
		chats.append(ChatMessage(2,"What do you say?", type: .Received))
		chats.append(ChatMessage(2,"Carry on? y/n", type: .Received))
	
		
		self.groupedBy = OrderedDictionary(grouping: chats, by: { $0.questionNumber })
	}
	
	func testGroupedBy() throws {
		XCTAssertEqual(2,groupedBy.count)
	}
	
	func testGroupedByRead() throws {

		XCTAssertEqual(2,groupedBy.count)

		groupedBy.forEach({
			var queue:Deque<ChatMessage> = []
			queue.append(contentsOf: $0.value)//
			messageQueues2.append(queue)
		})
		
		
		XCTAssertEqual(2,messageQueues2.count)
		
		let q1 = messageQueues2.popFirst()
		XCTAssertEqual(6,q1?.count)
		
		XCTAssertEqual(1,messageQueues2.count)
//
		let q2 = messageQueues2.popFirst()
		XCTAssertEqual(6,q2?.count)
//
		XCTAssertEqual(0,messageQueues2.count)
		
		
	}
	
}
