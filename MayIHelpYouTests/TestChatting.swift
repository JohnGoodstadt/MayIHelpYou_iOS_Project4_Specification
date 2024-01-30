//
//  testChatting.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 20/04/2023.
//

import XCTest
import Collections
@testable import MayIHelpYou

final class TestChatting: XCTestCase {

	var conversations = [[Dictionary<String, [ChatMessage]>]]()
	
    override func setUpWithError() throws {
		let groupedBy = OrderedDictionary(grouping: StarterConversations, by: { $0.conversationNumber})
		
		
		
		for key in groupedBy {
			
			var questions = [Dictionary<String, [ChatMessage]>]()
			
			let conversation = key.value
			
			conversation.forEach{
				
				var preQ = [ChatMessage]()
				var q = [ChatMessage]()
				var postQCorrect = [ChatMessage]()
				var postQWrong1 = [ChatMessage]()
				var postQWrong2 = [ChatMessage]()
				
				let c1 = $0
				let cn = c1.conversationNumber
				
				preQ.append(ChatMessage(cn,"Can you choose the correct answer? 1,2 or 3?",.intro))
				preQ.append(ChatMessage(cn,c1.prompt,.prompt))
				q.append(ChatMessage(cn,c1.wrongChoice1,.wrong1))
				q.append(ChatMessage(cn,c1.wrongChoice2,.wrong2))
				q.append(ChatMessage(cn,c1.correctChoice,.correct))
				q.append(ChatMessage(cn,"Is it 1, 2 or 3?",.question))
				
				postQCorrect.append(ChatMessage(cn,"Well done.😅",.congrats))
				postQCorrect.append(ChatMessage(cn,"If its before noon use Good morning as the greeting.",.correctExplanation))
				postQCorrect.append(ChatMessage(cn,"Carry on? y/n",.more))
				
				postQWrong1.append(ChatMessage(cn,"Sorry, try again 1,2 or 3",.incorrectResponse))
				postQWrong1.append(ChatMessage(cn,c1.wrong1Explanation,.incorrectResponse))
				
				postQWrong2.append(ChatMessage(cn,"Sorry, try again 1,2 or 3",.incorrectResponse))
				postQWrong2.append(ChatMessage(cn,c1.wrong2Explanation,.incorrectResponse))
				
				
				
				var d = Dictionary<String, [ChatMessage]>()
				
				d["preQ"] = preQ
				d["q"] = q
				d["postQCorrect"] = postQCorrect
				d["postQWrong1"] = postQWrong1
				d["postQWrong2"] = postQWrong2
				
				questions.append(d)
			
				
			}
			
			conversations.append(questions)
		}
		
    }
	
	
	func testChatting(){
		
		XCTAssertEqual(2, conversations.count)
		
		let c1 = conversations[0]
		let c2 = conversations[1]
		
		XCTAssertEqual(3, c1.count) //Its 11am on a rainy Tuesday...
		XCTAssertEqual(2, c2.count)
		
		
		
		
	}

	func testUnbundleQuestion1(){
		
		let c1 = conversations[0] //e.g. Peter
		
		let question1 = c1[0] //First Question
		
		let preQ = question1["preQ"]
		let Q = question1["q"]
		let postQCorrect = question1["postQCorrect"]
		let postQWrong1 = question1["postQWrong1"]
		let postQWrong2 = question1["postQWrong2"]
		
		
		XCTAssertEqual(2, preQ!.count)
		XCTAssertEqual(4, Q!.count)
		XCTAssertEqual(3, postQCorrect!.count)
		XCTAssertEqual(2, postQWrong1!.count)
		XCTAssertEqual(2, postQWrong2!.count)
		
	}
	func testUnbundleQuestion2(){
		
		let c1 = conversations[0] //e.g. Peter
		
		let question2 = c1[1] //Second Question
		
		let preQ = question2["preQ"]
		let Q = question2["q"]
		let postQCorrect = question2["postQCorrect"]
		let postQWrong1 = question2["postQWrong1"]
		let postQWrong2 = question2["postQWrong2"]
		
		
		XCTAssertEqual(2, preQ!.count)
		XCTAssertEqual(4, Q!.count)
		XCTAssertEqual(3, postQCorrect!.count)
		XCTAssertEqual(2, postQWrong1!.count)
		XCTAssertEqual(2, postQWrong2!.count)
		
	}
}
