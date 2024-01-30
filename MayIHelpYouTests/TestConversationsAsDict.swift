//
//  TestConversationAsChat.swift
//  MayIHelpYouTests
//
//  Created by John goodstadt on 20/04/2023.
//

import XCTest
@testable import MayIHelpYou

final class TestConversationsAsDict: XCTestCase {

	var c:[Conversation] = []
	
    override func setUpWithError() throws {
		self.c = StarterConversations.filter{ $0.conversationNumber == 1 }
    }

    
	func testConversions() throws {

		var questions = [Dictionary<String, [ChatMessage]>]()
		
		self.c.forEach{

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

		
		XCTAssertEqual(3, questions.count)
		
		
	}

}
