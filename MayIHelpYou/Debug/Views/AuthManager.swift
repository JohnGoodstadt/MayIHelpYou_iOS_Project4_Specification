//
//  AuthManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 30/03/2023.
//

import Foundation
import FirebaseAuth

class AuthManager {
	static let shared = AuthManager()
	private let auth = Auth.auth()
	private var verificationId: String?
	
	public func startAuth(phoneNumber: String, completion: @escaping (Bool) -> Void) {
		
		PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
			guard let verificationId, error == nil else{
				print("Error PhoneAuthProvider()")
				print(error.debugDescription)
				return
			}
			
			self?.verificationId = verificationId
			completion(true)
		}
	}
	
	public func verifyCode(smsCode: String, completion: @escaping (Bool) -> Void) {
		guard  let verificationId else {
			completion(false)
			return
		}
		let credential = PhoneAuthProvider.provider().credential(
			withVerificationID: verificationId,
			verificationCode: smsCode
		)
		
		auth.signIn(with: credential) { result, error in
			guard result != nil, error == nil else {
				completion(false)
				return
			}
			
			completion(true)
			
		}
		
	}
}
