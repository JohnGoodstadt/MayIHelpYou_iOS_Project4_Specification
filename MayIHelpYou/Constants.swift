//
//  Constants.swift
//  May I Help You?
//
//  Created by John goodstadt on 18/03/2023.
//

import Foundation

let adminUsers = ["testing@apple.com","daniele@ieaai.com","alex@socialfutures.com","alex@starcafe.com","john@goodstadt.com","paul@goodstadt.com","alex@chruszcz.com"] //using password password
let demoPassword = "X1FHzDhf" //X1FHzDhf //all the other users to above
let adminPassword = "password"

let TARGET_AUDIO_COUNT = 4
let LESSON_DELAY_AMOUNT = 4 //hours

//User before real user's details
let defaultCompanyName = "Barlow"
let defaultCompanyNamePossessive = "Barlow's"
let defaultUsername = "John Alexander"
let defaultLibraryCode = "JA65"//JA64"


let defaultLessonReminder = true
let defaultLessonReminderTime = "9am"

let lessonNotificationUID = "goodstdt.lessons.mihy"

enum placeholder {
	static let uid = "<uid>"
	static let email = "<email>"
	static let librarycode = "<librarycode>"
	static let spokenname = "<spokenname>"
	static let lessontitle = "<lessontitle>"
}

let placeholderRegEx = "<[a-z]*>"
let libraryCodeRegEx = "[A-Z][A-Z][0-9][0-9]"
let spokenNameRegEx = "[A-Za-z]"

let GOOGLE_MALE_VOICE = "en-AU-Wavenet-B"
let GOOGLE_FEMALE_VOICE = "en-AU-Wavenet-A"

public enum AppTabs: Hashable {
		case home
		case lesson
		case phrases
		case practice
		case account
}
