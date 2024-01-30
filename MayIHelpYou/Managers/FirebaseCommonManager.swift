//
//  FirebaseCommonManager.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 14/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

func fbUpdateConversationProperty<T>(_ code:String, property:String, value:T, UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.conversations).document(String(UID))
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating conversation field \(property): \(err)")
		}
	}
}
func fbUpdateConversationPropertyNewPath<T>(_ code:String, conversationNumber:Int, property:String, value:T, UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversationNumber)).collection(fb.questions).document(String(UID))
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating conversation field \(property): \(err)")
		}
	}
}
