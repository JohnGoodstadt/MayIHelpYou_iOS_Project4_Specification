//
//  ChatManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 20/04/2023.
//

import Foundation

func conversationToMessageList(_ conversations:[Conversation]) -> [ChatMessage]{

	let intro = ["Can you choose the correct answer? 1,2 or 3?",
				 "Which of these is the correct response?"]
	
	let ask = ["Is it 1, 2 or 3?","1,2 or 3","What's the answer"]
	
	let congrats = ["Well done.😅","Correct😅"]
	
	let more = ["Carry on?","Try another? (y/n)"]
	
	var ms = [ChatMessage]()
	
	conversations.forEach{
		
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
	
	return ms
	
}
