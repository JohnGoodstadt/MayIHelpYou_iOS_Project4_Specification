//
//  StarterConversations.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 17/04/2023.
//

import Foundation

let StarterConversations:[Conversation] = [
	Conversation(
		id: 1,
		conversationNumber:1,
		sortNumber:1,
		prompt: "1. Its 11am on a rainy Tuesday. You are near the front entrance to the store. A customer comes in through the door and pauses to look around.",
		correctChoice: "Good morning, welcome to Barlows",
		wrongChoice1: "Good afternoon, welcome to Barlows",
		wrongChoice2: "Hello, nice to meet you",
		correctExplanation: "If its before noon use Good morning as the greeting",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	),
	Conversation(
		id: 2,
		conversationNumber:1,
		sortNumber:1,
		prompt: "2. The customer replies 'Good morning' and looks past you into the store, they are scanning the aisles",
		correctChoice: "Are you looking for anything in particular?",
		wrongChoice1: "There's lots of things to choose from, have fun",
		wrongChoice2: "Please have a look around and let me know if I can help you with anything",
		correctExplanation: "You have spotted that the customer is looking for something. Asking them what they are looking shows that you are being attentive.",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	),
	Conversation(
		id: 3,
		conversationNumber:1,
		sortNumber:1,
		prompt: "3. The customer replies, 'Thanks, yes, I'm looking for the Tableware'",
		correctChoice: "Let me take you over there",
		wrongChoice1: "Its over there at the back of the store",
		wrongChoice2: "I'm not sure where that is, its probably at the back though near the cooking stuff",
		correctExplanation: "Always offer to take the customer to the ",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	),
	Conversation(
		id: 4,
		conversationNumber:2,
		sortNumber:1,
		prompt: "1. You are working at the Customer Service desk. A customer comes into the store carrying a bag. They approach you and say that they have had a problem with the item and need to return it.",
		correctChoice: "I'm sorry that you have had a problem. Can you let me know what the problem was?",
		wrongChoice1: "I'm sorry but we don't accepts returns if an item has been used",
		wrongChoice2: "I hope that you have a receipt because we don't accept returns without a receipt",
		correctExplanation: "Our priority is that the customer's problem is resolved so expressing empathy and finding out the cause of the issue is important",
		wrong1Explanation: "We do accept returns, even no matter if an item has been used and has been found to be faulty or not fit for purpose",
		wrong2Explanation: "This is an unprofessional tone to take with a customer and does not express empathy with their situation",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	)
	,
	Conversation(
		id: 5,
		conversationNumber:2,
		sortNumber:1,
		prompt: "2. Is Today Tuesday?",
		correctChoice: "No",
		wrongChoice1: "Could be, not looked at my phone yet",
		wrongChoice2: "No, its Wednesday",
		correctExplanation: "Testing Question and Answer",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	)
]
