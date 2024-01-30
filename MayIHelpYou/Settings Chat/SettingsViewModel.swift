//
//  LoginViewModel.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 03/05/2023.
//


import Foundation
import FirebaseAuth

class SettingsViewModel: ObservableObject {
	
	@Published var chat:SettingsChat
	
	let auth = Auth.auth()
	
	//TODO: use instead from DataManager() in LoginView
	var currentLibraryCode:String = ""
	var currentSpokenName:String = ""
	
	var stateMachine = SettingsStateMachine()
//	var avatar:Avatar?
	
	init(avatar:Avatar){
//		chat = ALIChat.sampleALIChat
		chat = SettingsChat(avatar:avatar,SettingsChat.messages)
	}
	//MARK: - SendMessages
	@discardableResult
	func sendMessage(_ text: String) -> SettingsMessage? {
		let message = SettingsMessage(text, type: .Received)
		self.chat.messages.append(message)
		return message
	}
	@discardableResult
	func userSendMessage(_ text: String) -> SettingsMessage? {
		let message = SettingsMessage(text, type: .Sent)
		self.chat.messages.append(message)
		return message
	}
	@discardableResult
	func sendMessage(_ text: String, rowType: SettingsMessage.RowType) -> SettingsMessage? {
		let message = SettingsMessage(text, type: .Received,rowType: rowType)
		self.chat.messages.append(message)
		return message
	}
	
	func sendMessages(_ bucketType: SettingsMessage.BucketType) {
		
		let bucketRaw = self.chat.messageQ.filter{ $0.bucketType == bucketType }
		
		self.chat.messages.append(contentsOf: replacePlaceholders(bucketRaw))
	}
	
	@discardableResult
	func sendMessage(_ rowType: SettingsMessage.RowType)  -> SettingsMessage?{
		
		let bucket = self.chat.messageQ.filter{ $0.rowType == rowType }

		let copiedMessages = copyMessages(bucket)
		self.chat.messages.append(contentsOf: copiedMessages)
		
		return copiedMessages.last
	}
	@discardableResult
	func sendMessage(_ message:SettingsMessage)  -> SettingsMessage?{
		
		self.chat.messages.append(message)
		
		return self.chat.messages.last
	}
	//in message is extra message(s) to start before reset messages
	func resetToStart(bucketType: SettingsMessage.BucketType = .unknown, rowType: SettingsMessage.RowType = .unknown){
		self.chat.messages.removeAll()
		
		if bucketType != .unknown {
			sendMessages(bucketType)
		}else if rowType != .unknown {
			sendMessage(rowType)
		}
		
		sendMessages(.loggedin)
	}
	func markAsUnread(_ newValue: Bool, chat: SettingsChat) {
		self.chat.hasUnreadMessage = newValue
	}
	
//	func changeSpokenNameButtonPressed(){
//		
//	}
	fileprivate func copyMessages(_ messages: [SettingsMessage]) -> [SettingsMessage] {
		
		var messagesCopied = [SettingsMessage]() //because need new id (UUID)
		messages.forEach{
			messagesCopied.append(SettingsMessage($0.text,rowType: $0.rowType, bucketType: $0.bucketType, isButton: $0.isButton))
		}
		
		return messagesCopied
	}
	fileprivate func replacePlaceholders(_ bucketRaw: [SettingsMessage]) -> [SettingsMessage] {
		
		var bucketProcessed = [SettingsMessage]()
		
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
				
				let message = SettingsMessage(replaced,rowType: $0.rowType, bucketType: $0.bucketType, isButton: $0.isButton)
				
				bucketProcessed.append(message)
				
			}else{
				bucketProcessed.append($0)
			}
		}
		
		return bucketProcessed
	}
	
	
	
	
	
}

extension SettingsViewModel {
	
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
extension SettingsViewModel {
	
	
	func isLibraryCodeValid(_ code:String) -> Bool {
		code.matches(libraryCodeRegEx) ? true : false
	}
	func isSpokenNameValid(_ spokenName:String) -> Bool {
		spokenName.split(separator: " ").count == 1 ? true : false //1 word only
	}
	
	
}




