//
//  EmptyDB.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 27/03/2023.
//

import Foundation

let NewLibraryCodeStarterSet = LibraryCode(code: "",
									 company: "", lessonsPerPhrase: 4,
									 timeBetweenLessons: 240,
									 cardGradientHigh: [255,0,89],
									 cardGradientLow: [255,128,155])


let NewLessonsStarterSet: [Lesson] = [
	Lesson(id: 1, title: "Lesson 1", selected: true)
]

let NewPhraseCategoriesStarterSet: [PhraseCategory] = [
	PhraseCategory(id: 1, title: "Introductions", selected: true,additional: "Introducing yourself to a customer is the simplest, and most important, thing you can do to help them with their visit​")
]

let NewPhrasesStarterSet: [Phrase] = [
	
	Phrase(phraseType: .introductions,
		   lessonNumber: 1,
		   sortNumber: 1,
		   phrase:"Hello and welcome",
		   additional: "Making customers welcome with a smile and a greeting makes a great start.",
		   linkTitle:"",
		   linkLink:"",
		   linkType:""
		  )
]

let NewFutureTabsStarterSet: [FutureTabCategory] = []

let NewAvatars: [Avatar] = [
	
	Avatar(name: "Matilda",avatarArea: .practice, imgString: "img4",voice:"en-AU-News-E", subarea:1),
	Avatar(name: "Peter",avatarArea: .practice, imgString: "img9",voice:"en-AU-News-G", subarea:2),
	
	Avatar(name: "Jett",avatarArea: .practice,  imgString: "img3", subarea:3),
	Avatar(name: "Change my settings",avatarArea: .changeSettings, subTitle: "Logout or library code", imgString: "img7"),
	Avatar(name: "Login flow",avatarArea: .loginFlow, subTitle: "Login with various options", imgString: "img6"),
	Avatar(name: "What next?",avatarArea: .whatsNext, subTitle: "Your next steps are here.", imgString: "img5"),

	Avatar(name: "Help",avatarArea: .help, subTitle: "Introductions, Help and FAQ", imgString: "img1"),

	
]


let NewConversationsStarterSet:[Conversation] = [
	Conversation(
		id: 1,
		conversationNumber:1,
		sortNumber:1,
		prompt: "First Prompt. ",
		correctChoice: "Good morning",
		wrongChoice1: "Good afternoon",
		wrongChoice2: "Hello, nice to meet you",
		correctExplanation: "If its before noon use Good morning as the greeting",
		createdDate:Date(timeIntervalSince1970: 0),
		updatedDate:Date(timeIntervalSince1970: 0)
	)
]
