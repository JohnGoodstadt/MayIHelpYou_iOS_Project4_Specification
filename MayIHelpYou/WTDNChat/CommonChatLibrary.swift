//
//  CommonChatLibrary.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 17/05/2023.
//

import Foundation
import FirebaseAuth

func copyMessages<T>(_ messages: [T]) -> [T] {
	
	var messagesCopied = [T]() //because need new id (UUID)
	
	messages.forEach{
		if $0 is LoginMessage {
			let m = $0 as! LoginMessage
			
			let new = LoginMessage(m.text,rowType: m.rowType, bucketType: m.bucketType, isButton: m.isButton)
			messagesCopied.append(new as! T)
		}
		else if $0 is WTDNMessage {
			
			let m = $0 as! WTDNMessage
			
			let new = WTDNMessage(m.text,rowType: m.rowType, bucketType: m.bucketType, isButton: m.isButton)
			messagesCopied.append(new as! T)
		}
		else if $0 is HelpMessage {
			
			let m = $0 as! HelpMessage
			
			let new = HelpMessage(m.text,rowType: m.rowType, bucketType: m.bucketType, isButton: m.isButton)
			messagesCopied.append(new as! T)
		}
		else{
			printhires("Error in code copyMessages() FIXIT FIXIT")
		}
	}//:LOOP
	return messagesCopied
}
#if DONT_COMPILE
func replacePlaceholdersNew<T>(_ bucketRaw: [T], placeholders:[String] = [String]()) -> [T] {
	
	var bucketProcessed = [T]()
	
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
			}
			else{
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
#endif
