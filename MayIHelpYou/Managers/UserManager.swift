//
//  UserManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 28/04/2023.
//

import Foundation
import FirebaseAuth

func checkAuthorization(code:String) async -> Bool {
	
	var returnValue = false

	guard let _ = Auth.auth().currentUser else { return false }
	
	let authToken = getAuthToken()
	
	
	let result = await fbIsCurrentUserAuthorizedAsyncAwait(code: code, authtoken: authToken)
	switch result {
		case .failure(let error):
			print(error.localizedDescription)
			printhires("user \(authToken) is NOT authorized")
			
		case .success(let isUserAuthorized):
			if isUserAuthorized {				
				returnValue = true
			}else{
				printhires("user \(authToken) is NOT authorized - DB 'isauthorized' flag is false")
				returnValue = false
				
			}
	}
	
	
	return returnValue
	
}
func checkAuthorization(code:String,authtoken:String) async -> (OK:Bool,missing:Bool,flagfail:Bool) {
	
	var returnValue = (false,false,false) //assume fail

	guard let _ = Auth.auth().currentUser else { return returnValue }
	
	let result = await fbIsCurrentUserAuthorizedAsyncAwait(code: code, authtoken: authtoken)
	switch result {
		case .failure(let error):
			print(error.localizedDescription)
			printhires("user \(authtoken) is NOT authorized for \(code)")
			returnValue = (false,false,false)
		case .success(let isUserAuthorized):
			if isUserAuthorized {
				returnValue = (true,true,true)
			}else{
				printhires("user \(authtoken) is NOT authorized for \(code)- DB 'isauthorized' flag is false")
				returnValue = (false,true,false)
				
			}
	}
	
	
	return returnValue
	
}
func getAuthToken() -> String{
	
	guard let user = Auth.auth().currentUser else { return "" }
	
	//1. google - email is present -- display name is present
	//2. facebook -- email is empty -- display name is present
	//3. apple - email is present -- display name is empty
	//mostly 1 row - have had 2 rows john.memorize@gmail.com and johngoodstadt@icloud.com ?
	//if so then both need to be in authorized user list on firebase
	
	//NOTE: could be several entries - not all valid - order might be random - might be linked LogonIDs
	for item in user.providerData {
		print("providerID:\(item.providerID) email:\(item.email ?? "No email") uid:\(item.uid) displayName:\(item.displayName ?? "Unknown name")")
	}
	for item in user.providerData {
		
		switch item.providerID {
			case "google.com":
				if let email = item.email { return email }
			case "facebook.com":
				//Token to check is always the email address first
				if let email = item.email { return email }
			case "apple.com":
				if let email = item.email { return email }
				
			default: //maybe "Firebase"
				print(item.providerID)
				if let email = item.email { return email }
		}
	}
	
	return ""
}
