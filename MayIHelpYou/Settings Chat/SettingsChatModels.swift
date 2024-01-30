//
//
//  Chat.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  


import Foundation
import FirebaseAuth

struct SettingsChat: Identifiable, CustomStringConvertible {
	var id: UUID { avatar.id }
	let avatar: Avatar
	var messages: [SettingsMessage]
	var messageQ: [SettingsMessage] //original message list from DB. Will fill messages[] list
	var hasUnreadMessage = false
	var sortNumber = 1
	
	var description: String {
		return "p:\(self.avatar.name)  mc:\(self.messages.count)) mcq:\(self.messageQ.count)"
	}
	
	init(avatar: Avatar,_ messageQ:[SettingsMessage]) {
		self.avatar = avatar
		self.messages = [SettingsMessage]()
		self.messageQ = messageQ
		
	}
	
}

struct SettingsMessage: Identifiable {
	
	enum MessageType {
		case Sent, Received
	}
	
	enum RowType {
		case text,login,logout,loginChat,logoutconfirmed,
			 url,continuelesson,authmessage,
			 changeLibraryCode,invalidLibraryCode,sameLibraryCode,checkedLibraryCode,notFoundLibraryCode, changedLibraryCodeSuccess,
			 changeSpokenName ,changeSpokenNameSuccess ,changeSpokenNameError ,
			 changeNotification,
			 setMale,setFemale,
			 unknown
	}
	
	enum BucketType {
		case notLoggedIn, loggedin, loggedOutOK, loggedOutError, unknown
		
	}
	
	let id = UUID()
	let date: Date
	let text: String
	let type: MessageType
	var rowType:RowType
	var bucketType:BucketType
	var isButton = false
	var tag = "" //used for Library code chosen by user -- button tap
	
	
	init(_ text: String, type: MessageType = .Received, rowType:RowType = .text, sortNumber:Int = 1, bucketType:BucketType = .unknown, isButton:Bool = false, tag:String = "") {
		self.date = Date()
		self.text = text
		self.type = type
		self.rowType = rowType
		self.bucketType = bucketType
		self.isButton = isButton
		self.tag = tag
		
	}
	
	
}


extension SettingsChat {
	
	
	static let messages = [
		SettingsMessage("You are logged in as <uid>.",bucketType: .loggedin),
		
		SettingsMessage("Choose one of the following:",bucketType: .loggedin),
		SettingsMessage("Change Library Code from <librarycode>",rowType: .changeLibraryCode,bucketType: .loggedin, isButton: true),

		SettingsMessage("Change your spoken name from <spokenname>", rowType: .changeSpokenName,bucketType: .loggedin, isButton: true),

		//Reminder
		SettingsMessage("Set up my daily reminder", rowType: .changeNotification,bucketType: .loggedin, isButton: true),
		
//		#if DONT_COMPILE
//		ALIMessage("Set up my daily reminder",bucketType: .loggedin),
//		ALIMessage("You can set up or change your daily reminder in your Account settings",bucketType: .loggedin),
//
//		ALIMessage("Take me to my Account settings", rowType: .changeNotification,bucketType: .loggedin, isButton: true),
//
//		#endif
		
		
		/* moved to Account page
		SettingsMessage("Login with another ID (Page)",rowType: .logout,bucketType: .loggedin, isButton: true),
		*/
		SettingsMessage("Login with another ID",rowType: .loginChat,bucketType: .loggedin, isButton: true),
		
		SettingsMessage("You are not signed In",bucketType: .notLoggedIn),
		SettingsMessage("Choose one of the following:",bucketType: .notLoggedIn),
		
		SettingsMessage("Hey Alex, you can login or logut or change your Lesson Code right here👋", type: .Received),
		SettingsMessage("Login now👋", rowType: .login),
		
		SettingsMessage("Login now", rowType: .logoutconfirmed,isButton: true),
		
		SettingsMessage("Change Library Code", rowType: .changeLibraryCode),
		
		
	
		
		SettingsMessage("Invalid Library Code.", rowType: .invalidLibraryCode),
		SettingsMessage("Please try again or choose something else", rowType: .invalidLibraryCode),
		
		SettingsMessage("Sorry, you're not registered for that course", rowType: .notFoundLibraryCode),
		SettingsMessage("Two options:", rowType: .notFoundLibraryCode),
		SettingsMessage("Try again or use a different course code", rowType: .notFoundLibraryCode),
		SettingsMessage("Contact us to ask to be registered", rowType: .notFoundLibraryCode),
		
		
		SettingsMessage("You already have this library, try another code", rowType: .sameLibraryCode),
		
		
		
		SettingsMessage("That's great. We'll set up the course for you now.", rowType: .checkedLibraryCode),
		
		SettingsMessage("All phrases downloaded", rowType: .changedLibraryCodeSuccess),
		
		
		
		SettingsMessage("Send message to admin to Authorize you", rowType: .authmessage),
		SettingsMessage("Which one? Tap the button", rowType: .text),
		
		SettingsMessage("Logged out OK", bucketType: .loggedOutOK),
		SettingsMessage("Login now👋", rowType: .login),
		
		SettingsMessage("Logged out error", bucketType: .loggedOutError),
		SettingsMessage("try again", bucketType: .loggedOutError),
		
		//MARK: spoken Name
		
		SettingsMessage("Name changed successfully", rowType: .changeSpokenNameSuccess),
		SettingsMessage("Name change has a problem", rowType: .changeSpokenNameError),
		SettingsMessage("A one word name that represents you. Try agin", rowType: .changeSpokenNameError),
		
		//google voice
		SettingsMessage("Set a male voice", rowType: .setMale,bucketType: .loggedin, isButton: true),
		SettingsMessage("Set a female voice", rowType: .setFemale,bucketType: .loggedin, isButton: true),
		
	]
	
	
}
