//
//  TestChats.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 19/04/2023.
//

import XCTest
import Collections
@testable import MayIHelpYou

final class TestChatsQueue: XCTestCase {
		
	//var deque:Deque<String> = []
	var messageQueue:Deque<ChatMessage> = []
	var messageQueues:[Deque<ChatMessage>] = []
		
    override func setUpWithError() throws {

		
		messageQueue.append(ChatMessage("Hey Alex, can you answer this one? 👋", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)))
		messageQueue.append(ChatMessage("Its 11am on a rainy Tuesday. You are near the front entrance to the store. A customer comes in through the door and pauses to look around. 👋", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)))
		messageQueue.append(ChatMessage("1️⃣ Good morning, welcome to Barlows", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)))
		messageQueue.append(ChatMessage("2️⃣ Good afternoon, welcome to Barlows", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)))
		messageQueue.append(ChatMessage("3️⃣ Hello, nice to meet you", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)))
		messageQueue.append(ChatMessage("Is it 1, 2 or 3", type: .Received, date: Date(timeIntervalSinceNow: -86400 * 4)))
		
		var q2:Deque<ChatMessage> = [	]
		
		let a:[ChatMessage] = [
			ChatMessage("Well done.😅", type: .Received),
			ChatMessage("If its before noon use Good morning as the greeting.", type: .Received),
			ChatMessage("What about this one?", type: .Received),
			ChatMessage("The customer replies 'Good morning' and looks past you into the store, they are scanning the aisles.", type: .Received),
			ChatMessage("What do you say?", type: .Received),
			ChatMessage("Carry on? y/n", type: .Received)
		]
		
		q2.append(contentsOf: a)
		
		messageQueues = [messageQueue,q2]

		
    }

	
	func testInitialMessagesBatch() {
		XCTAssertEqual(6,messageQueue.count)
		if let f:ChatMessage = messageQueue.popFirst() {
			XCTAssertEqual("Hey Alex, can you answer this one? 👋",f.text)
		}
		if let l:ChatMessage = messageQueue.popLast(){
			XCTAssertEqual("Is it 1, 2 or 3",l.text)
		}
		XCTAssertEqual(4,messageQueue.count)
	}
	
	func testMessageQueues(){
		XCTAssertEqual(2,messageQueues.count)
	}



}
