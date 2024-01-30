//
//  TestConversationAsChat.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 20/04/2023.
//

import XCTest
@testable import MayIHelpYou

final class Test1ConversationAsDict: XCTestCase {

	var c:[Conversation] = []
	
    override func setUpWithError() throws {
		self.c = MinimalConversations
    }

    func test1Conversion() throws {
		
		var preQ = [ChatMessage]()
		var q = [ChatMessage]()
		var postQCorrect = [ChatMessage]()
		var postQWrong1 = [ChatMessage]()
		var postQWrong2 = [ChatMessage]()
		
		
		let c1 = StarterConversations[0]
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
		
		
		
		XCTAssertEqual(2, preQ.count)
		XCTAssertEqual(4, q.count)
		XCTAssertEqual(3, postQCorrect.count)
		XCTAssertEqual(2, postQWrong1.count)
		XCTAssertEqual(2, postQWrong2.count)
		
		var conversations = [Dictionary<String, [ChatMessage]>]()
		
		var d = Dictionary<String, [ChatMessage]>()
		
		d["preQ"] = preQ
		d["q"] = q
		d["postQCorrect"] = postQCorrect
		d["postQWrong1"] = postQWrong1
		d["postQWrong2"] = postQWrong2
		
		conversations.append(d)
		
		XCTAssertEqual(1, conversations.count)
		
		
		
		
    }
	func test2Conversions() throws {


		let cs = StarterConversations.prefix(2)
		var questions = [Dictionary<String, [ChatMessage]>]()
		
		cs.forEach{

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

		
		XCTAssertEqual(2, questions.count)
		
		
	}

}
