//
//  EmptyDB.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 27/03/2023.
//

import Foundation

let MinimalLibraryCode = LibraryCode(code: defaultLibraryCode,
									 company: defaultCompanyName, lessonsPerPhrase: 4,
									 timeBetweenLessons: 240, cardGradientHigh: [255,0,89],
									 cardGradientLow: [255,128,155])


let MinimalLessons: [Lesson] = [
	Lesson(id: 1, title: "Lesson 1", selected: true)
]

let MinimalPhraseCategories: [PhraseCategory] = [
	PhraseCategory(id: 1, title: "Introductions", selected: true,additional: "Introducing yourself to a customer is the simplest, and most important, thing you can do to help them with their visit​")
]

let MinimalPhrases: [Phrase] = [
	
	Phrase(phraseType: .introductions,
		   lessonNumber: 1,
		   sortNumber: 1,
		   phrase:"Hello and welcome",
		   additional: "Making customers welcome with a smile and a greeting makes a great start to their shopping experience.",
		   linkTitle:"",
		   linkLink:"",
		   linkType:""
		  )
]


let MinimalAvatars: [Avatar] = [
	
	
	//BUG: these ale
	
	//Avatar(name: "Unknown 1",avatarArea: .practice, imgString: "img4",voice:"en-AU-News-E", subarea:1),
	//TODO: Not yet decoupled from DB - May 2023
	Avatar(name: "Matilda",avatarArea: .practice, imgString: "img4",voice:"en-AU-News-E", subarea:1),
	Avatar(name: "Peter",avatarArea: .practice, imgString: "img9",voice:"en-AU-News-G", subarea:2),
	
	Avatar(name: "Jett",avatarArea: .practice,  imgString: "img3", subarea:3),
	Avatar(name: "Change my settings",avatarArea: .changeSettings, subTitle: "Logout or library code", imgString: "img7"),
	Avatar(name: "Login flow",avatarArea: .loginFlow, subTitle: "Login with various options", imgString: "img6"),
	Avatar(name: "What next?",avatarArea: .whatsNext, subTitle: "Your next steps are here.", imgString: "img5"),

	Avatar(name: "Help",avatarArea: .help, subTitle: "Introductions, Help and FAQ", imgString: "img1"),
//	Avatar(name: "Not Used 2",avatarArea: .unused, imgString: "img2"),
//	Avatar(name: "Not Used 3",avatarArea: .unused, imgString: "img8"),
	
]


let EmptyConversations:[Conversation] = [
	Conversation(
		id: 1,
		conversationNumber:1,
		sortNumber:1,
		prompt: "An error occurred download conversations. Please contect an administrator",
		correctChoice: "",
		wrongChoice1: "",
		wrongChoice2: "",
		correctExplanation: "",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	)
]

let MinimalConversations:[Conversation] = [
	Conversation(
		id: 1,
		conversationNumber:1,
		sortNumber:1,
		prompt: "Its 11am on a rainy Tuesday. You are near the front entrance to the store. A customer comes in through the door and pauses to look around.",
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
		prompt: "The customer replies 'Good morning' and looks past you into the store, they are scanning the aisles",
		correctChoice: "Are you looking for anything in particular?",
		wrongChoice1: "There's lots of things to choose from, have fun",
		wrongChoice2: "Please have a look around and let me know if I can help you with anything",
		correctExplanation: "You have spotted that the customer is looking for something. Asking them what they are looking shows that you are being attentive.",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	)
]

