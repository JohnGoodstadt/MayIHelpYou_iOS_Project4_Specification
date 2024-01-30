//
//  AuthorizedUsers.swift
//  MayIHelpYou Admin
//
//  Created by John goodstadt on 01/06/2023.
//

import Foundation

struct AuthorizedUsers: Encodable {
	let authtoken:String
	let isauthorized:Bool
}
