//
//  User.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 30/03/2023.
//

import Foundation

struct User: Codable, Identifiable {
	let id:String //usually firebase Auth uid
	let UID:String //could be same as id
	let name:String //users given name
	let spokenName:String //name user is happy to hear spoken
	let loggedIn:Bool
	let isAnon:Bool
	let provider:String
	let providerCompany:String
	let email:String
	let isEmailVerified:Bool
	
	let lastUpdateDate:Date
	let lastLoggedInDate:Date
	let lastLoggedOutDate:Date
}
//short struct for subset
struct UserVariables: Codable {
	let spokenName:String
	let voiceMale:Bool
}
