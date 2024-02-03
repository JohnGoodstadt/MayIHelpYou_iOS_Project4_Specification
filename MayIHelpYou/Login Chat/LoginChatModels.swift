//
//
//  Chat.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  
	

import Foundation
import FirebaseAuth

struct LoginChat: Identifiable, CustomStringConvertible {
	var id: UUID { avatar.id }
	let avatar: Avatar
	var messages: [LoginMessage]
	var messageQ: [LoginMessage] //original message list from DB. Will fill messages[] list
	var hasUnreadMessage = false
	var sortNumber = 1
	
	var description: String {
		return "p:\(self.avatar.name)  mc:\(self.messages.count)) mcq:\(self.messageQ.count)"
	}
	
	init(avatar: Avatar,_ messageQ:[LoginMessage]) {
		self.avatar = avatar
		self.messages = [LoginMessage]()
		self.messageQ = messageQ
		
	}
	
}

struct LoginMessage: Identifiable {
	
	enum MessageType {
		case Sent, Received
	}
	
	enum RowType {
		case text,login,logout,logoutconfirmed,
			 url,continuelesson,authmessage,
			 changeLibraryCode,invalidLibraryCode,sameLibraryCode,checkedLibraryCode,notFoundLibraryCode,changedLibraryCodeSuccess,
			 changeSpokenName ,changeSpokenNameSuccess ,changeSpokenNameError ,
			 //Login specific
			 loginJG,loginIndaPoint,loginTesting,
			 loginSuccess, loginError,loginErrorNotInFirebase,
			 introLibraryCode, displayLibraryCodeJA65,displayLibraryCodeDA65,displayLibraryCodeSC01,messageToAdmin,
			 introSpokenName, enterSpokenName,
			 spokenNameConfirmYes,spokenNameConfirmNo, //loop spoken name changing
			 chooseVoiceMale,chooseVoiceFemale,logInComplete,cancelLogin,
			 
			 unknown
	}

	enum BucketType {
		case preamble,notLoggedIn, loggedin, loggedOutOK, loggedOutError,
			emailformatInvalid,sendMessageToAdmin,
			 libraryCodesErrorNotFound,
			 libraryCodesErrordisabled,
			 chooseVoice,cancelLogin,
			 
			 unknown
		
	}
	
	enum ButtonType {
		case normal, apple,google,cancelLogin, none
		
	}
	
	let id = UUID()
	let date: Date
	let text: String
	let type: MessageType
	var rowType:RowType
	var bucketType:BucketType
	var isButton:ButtonType = .none
	var tag = "" //used for Library code chosen by user -- button tap
	
	init(_ text: String, type: MessageType = .Received, rowType:RowType = .text, sortNumber:Int = 1, bucketType:BucketType = .unknown, isButton:ButtonType = .none, tag:String = "") {
		self.date = Date()
		self.text = text
		self.type = type
		self.rowType = rowType
		self.bucketType = bucketType
		self.isButton = isButton
		self.tag = tag
	}
	

}


extension LoginChat {
	
	
	static let messages = [

				  //LoginMessage("Demo of login flow.",bucketType: .preamble),
				  
				  //MARK: Logging In
				  LoginMessage("You are not logged in",bucketType: .notLoggedIn),
				  LoginMessage("You are logged in as <uid>",bucketType: .loggedin),
				  
				  LoginMessage("Choose one of the following:",bucketType: .preamble),
				  LoginMessage("Enter your email address below",bucketType: .preamble),
//				  LoginMessage("Or",bucketType: .preamble),
//				  LoginMessage("Tap on an already setup login:",bucketType: .preamble),
//				 
//				  //disable for demo's. use account panel to login with these.
				 // LoginMessage("indapoint@gmail.com",rowType:.loginIndaPoint, bucketType: .preamble, isButton:  .normal),
//				  LoginMessage("testing@gmail.com",rowType:.loginTesting, bucketType: .preamble, isButton:  .normal),
//				  
				  

				  
				 
				  LoginMessage("Cancel login",rowType:.cancelLogin, bucketType: .cancelLogin, isButton:  .normal),
				  
				  LoginMessage("You have logged in successfully",rowType: .loginSuccess),
				  LoginMessage("Something went wrong logging you in. Please try again",rowType: .loginError),
				  LoginMessage("Or send a message to the administrator",bucketType: .sendMessageToAdmin),
				  LoginMessage("Send Message",rowType:.messageToAdmin, bucketType: .sendMessageToAdmin, isButton: .normal),
				  
				  
				  
				  LoginMessage("Something went wrong logging you in. Maybe you are not yet authorized for the DB. Please try again with a different ID or contact an administrator",rowType: .loginErrorNotInFirebase),
				  
				  //MARK: Library Code
				  LoginMessage("Looking for library codes...",rowType: .introLibraryCode),
				  
				  LoginMessage("Library Code JA65",rowType: .displayLibraryCodeJA65,isButton: .normal),
				  LoginMessage("Library Code DA65",rowType: .displayLibraryCodeDA65,isButton: .normal),
				  LoginMessage("Library Code SC01",rowType: .displayLibraryCodeSC01,isButton: .normal),
				 
				  
				  LoginMessage("Invalid email format entered. Try again.",bucketType: .emailformatInvalid),
				  
				  LoginMessage("No Library codes found",bucketType: .libraryCodesErrorNotFound),
				  LoginMessage("Send a message to the administrator to request access",bucketType: .libraryCodesErrorNotFound),
				  LoginMessage("Send Message",rowType:.messageToAdmin, bucketType: .libraryCodesErrorNotFound, isButton: .normal),
				  
				  
				  //MARK: spoken Name
				  LoginMessage("We can setup a spoken name, a name that the app will speak.",rowType: .introSpokenName),
				  LoginMessage("Type in what you would like that to be. Usually your first name. Then we will play it.",rowType: .enterSpokenName),
				  
				  LoginMessage("Name added successfully", rowType: .changeSpokenNameSuccess),
				  LoginMessage("Name has a problem", rowType: .changeSpokenNameError),
				  LoginMessage("A one word name that represents you. Try agin", rowType: .changeSpokenNameError),
				  
				  LoginMessage("I am happy with this. Use this name",rowType: .spokenNameConfirmYes, isButton: .normal),
				  LoginMessage("Change this to something else.",rowType: .spokenNameConfirmNo, isButton: .normal),
				  

				  LoginMessage("You can choose a male or female voice",bucketType: .chooseVoice),
				  LoginMessage("Choose it now",bucketType: .chooseVoice),
				  LoginMessage("Male",rowType: .chooseVoiceMale, bucketType: .chooseVoice, isButton: .normal),
				  LoginMessage("Female",rowType: .chooseVoiceFemale, bucketType: .chooseVoice, isButton: .normal),
				  
				  LoginMessage("All done. Go to App",rowType: .logInComplete, isButton: .normal),

				  
				  
				]
	

}

