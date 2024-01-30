//
//  CardData.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 29/03/2023.
//

import Foundation


let PracticeCardData = [
	PracticeCard(
		id: 1,
		prompt: "Its 11am on a rainy Tuesday. You are near the front entrance to the store. A customer comes in through the door and pauses to look around.",
		correctOption: "Good morning, welcome to Barlows",
		wrongChoice1: "Good afternoon, welcome to Barlows",
		wrongChoice2: "Hello, nice to meet you",
		explanation: "If its before noon use Good morning as the greeting",
		image: "",
		gradientColors:  ["ColorBlueberryDark", "ColorBlueberryLight"],
		description: """
""",
		started: false,
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0),
		nextDate:Date(timeIntervalSince1970: 0)
	),
	PracticeCard(
		id: 2,
		prompt: "The customer replies 'Good morning' and looks past you into the store, they are scanning the aisles",
		correctOption: "Are you looking for anything in particular?",
		wrongChoice1: "There's lots of things to choose from, have fun",
		wrongChoice2: "Please have a look around and let me know if I can help you with anything",
		explanation: "You have spotted that the customer is looking for something. Asking them what they are looking shows that you are being attentive.",
		image: "",
		gradientColors:  ["ColorBlueberryDark", "ColorBlueberryLight"],
		description: """
""",
		started: false,
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0),
		nextDate:Date(timeIntervalSince1970: 0)
	),
	PracticeCard(
		id: 3,
		prompt: "Yes, its good isn't it. I'll take this one.",
		correctOption: "That’s great, I can take this over to the counter now so its ready for you. Please keep having a look around and I'll be waiting",
		wrongChoice1: "That's great. Bring it over to the counter and I can put that through",
		wrongChoice2: "That's great, why don't you  leave it there for now and have a look around if you need something else",
		explanation: "Once a customer has made a choice offer to start processing the sale immediately. If a customer puts the item back on the shelf they are likely to leave without purchasing",
		image: "",
		gradientColors:  ["ColorBlueberryDark", "ColorBlueberryLight"],
		description: """
""",
		started: false,
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0),
		nextDate:Date(timeIntervalSince1970: 0)
	)
	
]
