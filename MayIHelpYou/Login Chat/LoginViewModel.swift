//
//  LoginViewModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 03/05/2023.
//


import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
	
	@Published var chat:LoginChat
	
	let auth = Auth.auth()
	
	//TODO: use instead from DataManager() in LoginView
	var currentLibraryCode:String = ""
	var currentSpokenName:String = ""
	
	var stateMachine = LogInStateMachine()
	//var avatar:Avatar?
	
//	init(){
//		chat = LoginChat.chat
////		let dynamicChat = makeUpChat()
//	}
	init(avatar:Avatar){
		chat = LoginChat(avatar:avatar,LoginChat.messages)
	}
	//MARK: - SendMessages
	@discardableResult
	func sendMessage(_ text: String) -> LoginMessage? {
		let message = LoginMessage(text, type: .Received)
		self.chat.messages.append(message)
		return message
	}
	@discardableResult
	func userSendMessage(_ text: String) -> LoginMessage? {
		let message = LoginMessage(text, type: .Sent)
		self.chat.messages.append(message)
		return message
	}
	@discardableResult
	func sendMessage(_ text: String, rowType: LoginMessage.RowType) -> LoginMessage? {
		let message = LoginMessage(text, type: .Received,rowType: rowType)
		self.chat.messages.append(message)
		return message
	}

	@discardableResult
	func sendMessages(_ bucketType: LoginMessage.BucketType)  -> LoginMessage?{
		
		let bucketRaw = self.chat.messageQ.filter{ $0.bucketType == bucketType }
		
		let copiedMessages = copyMessages(bucketRaw) //new UUIDs
		self.chat.messages.append(contentsOf: replacePlaceholders(copiedMessages))
		
		return copiedMessages.last
	}
	@discardableResult
	func sendMessage(_ message:LoginMessage)  -> LoginMessage?{
		
		self.chat.messages.append(message)
		
		return self.chat.messages.last
	}
	@discardableResult
	func sendMessage(_ rowType: LoginMessage.RowType)  -> LoginMessage?{
		
		let bucket = self.chat.messageQ.filter{ $0.rowType == rowType }

		let copiedMessages = copyMessages(bucket)
		self.chat.messages.append(contentsOf: copiedMessages)
		
		return copiedMessages.last
	}
	//in message is extra message(s) to start before reset messages
	func resetToStart(bucketType: LoginMessage.BucketType = .unknown, rowType: LoginMessage.RowType = .unknown){
		self.chat.messages.removeAll()
		
		if bucketType != .unknown {
			sendMessages(bucketType)
		}else if rowType != .unknown {
			sendMessage(rowType)
		}
		
		
		if let _ = Auth.auth().currentUser {
			sendMessages(.loggedin)
			sendMessages(.preamble)
			sendMessages(.cancelLogin) //if already logged in allow cancelling
		}else{
			sendMessages(.notLoggedIn)
			sendMessages(.preamble)
		}
		
		
	}
	func markAsUnread(_ newValue: Bool, chat: LoginChat) {
		self.chat.hasUnreadMessage = newValue
	}

	
//MARK: - Login

	func signInWithDemoAccount(_ email:String,_ password:String) async -> Bool {
		
		let result = await fbSignInWithDemoAccount(email,password)
		switch result {
			case .failure(let error):
				print(error.localizedDescription)
				
				return false
				
			case .success(let isUserAuthorized):
				if isUserAuthorized {
					print("Logged in OK")
					return true
					
				}else{
					////printhires("user \(authToken) is NOT authorized - DB 'isauthorized' flag is false")
//								returnValue = false
					print("Logged in NOT OK")
//					viewModel.sendMessage(.loginError)
					return false
				}
		}

		
	}
	
	
	
	
	
}
//MARK: private routines
extension LoginViewModel {
	
	fileprivate func copyMessages(_ messages: [LoginMessage]) -> [LoginMessage] {
		
		var messagesCopied = [LoginMessage]() //because need new id (UUID)
		messages.forEach{
			messagesCopied.append(LoginMessage($0.text,rowType: $0.rowType, bucketType: $0.bucketType, isButton: $0.isButton))
		}
		
		return messagesCopied
	}
	fileprivate func replacePlaceholders(_ bucketRaw: [LoginMessage]) -> [LoginMessage] {
		
		var bucketProcessed = [LoginMessage]()
		
		bucketRaw.forEach {
			let text = $0.text
			if text.matches(placeholderRegEx) {
				
				var replaced = ""
				
				if text.contains(placeholder.uid) {
					if let currentUser = Auth.auth().currentUser {
						let uid = currentUser.email ?? String(currentUser.uid.prefix(4))
						replaced = text.replacingOccurrences(of: placeholder.uid, with: uid)
					}else{
						replaced = $0.text
					}
				}
				else if text.contains(placeholder.email) {
					if let currentUser = Auth.auth().currentUser {
						replaced = text.replacingOccurrences(of: placeholder.email, with: currentUser.email ?? "Unknown email")
					}else{
						replaced = $0.text
					}
				}
				else if text.contains(placeholder.spokenname) {
					replaced = text.replacingOccurrences(of: placeholder.spokenname, with: self.currentSpokenName)
				}
				else if text.contains(placeholder.librarycode) {
					replaced = text.replacingOccurrences(of: placeholder.librarycode, with: self.currentLibraryCode)//TODO: replace LibraryCode
				}else{
					replaced = $0.text
				}
				
				let message = LoginMessage(replaced,rowType: $0.rowType, bucketType: $0.bucketType, isButton: $0.isButton)
				
				bucketProcessed.append(message)
				
			}else{
				bucketProcessed.append($0)
			}
		}
		
		return bucketProcessed
	}
//	func makeUpChat(avatar:Avatar) -> LoginChat {
//		LoginChat(avatar:avatar,LoginChat.loginMessages)
//	}
}
extension LoginViewModel {

	func FRED(){}
	func logoutButtonPressed() -> Bool {
		
		let auth = Auth.auth()
		
		do {
			let _ = Auth.auth().currentUser?.uid ?? ""
			
			try auth.signOut()
			
			//if we use model screen do we need messavges?
//			sendMessages(.loggedOutOK)
			resetToStart(bucketType: .loggedOutOK)
			return true
			
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
			sendMessages(.loggedOutError)

			return false
		}
	}
	
}


@available(iOS 15.0, *)
extension LoginViewModel {
	
	
	func isLibraryCodeValid(_ code:String) -> Bool {
		code.matches(libraryCodeRegEx) ? true : false
	}
	func isSpokenNameValid(_ spokenName:String) -> Bool {
		spokenName.split(separator: " ").count == 1 ? true : false //1 word only
	}
	
	
}




