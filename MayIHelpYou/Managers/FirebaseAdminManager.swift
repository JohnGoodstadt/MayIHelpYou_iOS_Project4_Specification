//
//  FirebaseManagerAdmin.swift
//  MayIHelpYou Admin
//
//  Created by John goodstadt on 13/04/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

//func fsUploadLogo(_ code:String, logo:Data){
//
//}

func fsCreateLibraryCodeEntries(_ libraryCode:LibraryCode,authusers:[String],_ phrases:[Phrase],_ phraseCategories:[PhraseCategory],_ lessonTabs:[Lesson],_ conversations:[Conversation],_ avatars:[Avatar]){
	
	
	
	guard libraryCode.code.isNotEmpty else {
		return
	}
	
	let db = Firestore.firestore()
	let upperCode = libraryCode.code.uppercased()
	let batchItems = Firestore.firestore().batch()
	
	//Library Doc itself
	let libraryCodeDoc = try! Firestore.Encoder().encode(libraryCode)
	let codeDocRef = db.collection(upperCode).document(upperCode)//.setData(libraryCodeDoc)
	batchItems.setData(libraryCodeDoc, forDocument: codeDocRef)
	
	
//	Firestore.firestore().collection(upperCode).document(upperCode).setData(doc)
	
	printhires("Conversations")
	//Conversations
	
	
	
	for conversation in conversations {
		
		//1 high level doc - then sub collection
		let doc = ConversationDoc(id: conversation.conversationNumber, conversationNumber: conversation.conversationNumber)
		
		let conversationDoc = try! Firestore.Encoder().encode(doc)
		let conversationDocRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.conversationNumber))
		batchItems.setData(conversationDoc, forDocument: conversationDocRef)
		
		
		let itemDoc = try! Firestore.Encoder().encode(conversation)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.conversationNumber)).collection(fb.questions).document(String(conversation.id))
		batchItems.setData(itemDoc, forDocument: itemDocRef)
	}
	
	//Lessons Tabs
	printhires("Lessons Tabs")
	for lesson in lessonTabs {
		let itemDoc = try! Firestore.Encoder().encode(lesson)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.lessons).document(String(lesson.id))
		batchItems.setData(itemDoc, forDocument: itemDocRef)
	}
	//Phrases
	printhires("Phrases")
	for phrase in phrases {
		let itemDoc = try! Firestore.Encoder().encode(phrase)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.phrases).document(phrase.id)
		batchItems.setData(itemDoc, forDocument: itemDocRef)
	}
	
	//phrase Categories
	printhires("phrase Categories")
	for phraseCategory in phraseCategories {
		let itemDoc = try! Firestore.Encoder().encode(phraseCategory)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.phraseCategories).document(String(phraseCategory.id))
		batchItems.setData(itemDoc, forDocument: itemDocRef)
	}
	
	//AVATARS
	printhires("AVATARS")
	for avatar in avatars {
		let itemDoc = try! Firestore.Encoder().encode(avatar)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.avatars).document(avatar.id.description)
		batchItems.setData(itemDoc, forDocument: itemDocRef)
	}

	//authorized users
	printhires("authorized users")
	for authuser in authusers {
		
		let authorizedUsers = AuthorizedUsers(authtoken: authuser, isauthorized: true)
		let itemDoc = try! Firestore.Encoder().encode(authorizedUsers)
		
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.authorizedusers).document()
		batchItems.setData(itemDoc, forDocument: itemDocRef)
	}
	
	
	
	
	
	batchItems.commit() { err in
		if let err {
			printhires("Error writing batch \(err)")
		} else {
			print("Batch group write succeeded.")
		}
	}
	
}
func fsUploadAvatars(_ code:String,_ avatars:[Avatar]){
	
	let db = Firestore.firestore()
	
	let upperCode = code.uppercased()
	
	let batchItems = Firestore.firestore().batch()
	for avatar in avatars {
		
		let itemDoc = try! Firestore.Encoder().encode(avatar)
		
		
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.avatars).document(avatar.id.description)
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Batch group write succeeded.")
		}
	}
}

func fsUploadConversationsNewPath(_ code:String,_ conversations:[Conversation]) {
	
	let db = Firestore.firestore()
	
	let upperCode = code.uppercased()
	
	let batchItems = Firestore.firestore().batch()
	for conversation in conversations {
		
		let itemDoc = try! Firestore.Encoder().encode(conversation)
		
		print(itemDoc.count)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.conversationNumber)).collection(fb.questions).document(String(conversation.id))
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Batch group write succeeded.")
		}
	}
}

func fsUploadConversations(_ code:String,_ conversations:[Conversation]) {
	
	let db = Firestore.firestore()
	
	let upperCode = code.uppercased()
	
	let batchItems = Firestore.firestore().batch()
	for conversation in conversations {
		
		let itemDoc = try! Firestore.Encoder().encode(conversation)
		
		print(itemDoc.count)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.id))
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Batch group write succeeded.")
		}
	}
}

func fsUploadLessons(_ code:String,_ lessonTabs:[Lesson]) {
	
	let db = Firestore.firestore()
	
	let upperCode = code.uppercased()
	
	let batchItems = Firestore.firestore().batch()
	for lesson in lessonTabs {
		
		let itemDoc = try! Firestore.Encoder().encode(lesson)
		
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.lessons).document(String(lesson.id))
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Batch group write succeeded.")
		}
	}
}
func uploadPhrases(company:String,code:String,_ phrases:[Phrase]) {
	
	let db = Firestore.firestore()
	_ = company.lowercased()
	let upperCode = code.uppercased()
	
	print("Uploading item count:\(phrases.count)")
	
//	let codeDoc = CodeDoc(id: upperCode, title: "phrase Tabs for code '\(upperCode)'")
//	db.collection(lowerCompany).document(codeDoc.id.uppercased()).setData(["title": codeDoc.title])
	
	let chunkedArray = phrases.chunked(by: 50)
	
	
	for chunk in chunkedArray {
		let batchItems = Firestore.firestore().batch()
		for phrase in chunk {
			
			let itemDoc = try! Firestore.Encoder().encode(phrase)
			let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.phrases).document(phrase.id)
			
			batchItems.setData(itemDoc, forDocument: itemDocRef)
			
		}
		batchItems.commit() { err in
			if let err {
				print("Error writing batch \(err)")
			} else {
				print("Batch group write succeeded.")
			}
		}
	}
	//BATCH END
}
func uploadPhraseCategories(company:String,code:String,_ phraseCategories:[PhraseCategory]) {
	
	let db = Firestore.firestore()
	
	_ = company.lowercased()
	let upperCode = code.uppercased()
	
	
	let batchItems = Firestore.firestore().batch()
	for phraseCategory in phraseCategories {
		
		let itemDoc = try! Firestore.Encoder().encode(phraseCategory)
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.phraseCategories).document(String(phraseCategory.id))
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Batch group write succeeded.")
		}
	}
}

func uploadLibraryCodeDoc(code:String) {
	
	let upperCode = code.uppercased()
	
	let doc = try! Firestore.Encoder().encode(MinimalLibraryCode)
	
	Firestore.firestore().collection(upperCode).document(upperCode).setData(doc)
	

}

func fbUpdatePhraseProperty<T>(_ code:String, property:String, value:T, UID:String){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.phrases).document(UID)
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			// can get validly when starting to create a new  RecallItem - not yet created doc
			//- Error updating field words: Error Domain=FIRFirestoreErrorDomain Code=5 "No document to update:
			print("Error updating phrasefield \(property): \(err)")
		}
	}
}
func fbUpdateLessonProperty<T>(_ code:String, property:String, value:T, UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.lessons).document(String(UID))
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating lesson field \(property): \(err)")
		}
	}
}
func fbUpdatePhraseCategoryProperty<T>(_ code:String, property:String, value:T, UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.phraseCategories).document(String(UID))
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating lesson field \(property): \(err)")
		}
	}
}
func fsDeletePhrase(_ code:String, UID:String){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	
	
	Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.phrases).document(UID).delete { err in
		if let err {
			printhires("Error removing phrase: \(err)")
		}
	}
	

}
func fbUpdateLibraryCodeProperty<T>(_ code:String, property:String, value:T){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	
	let itemRef = Firestore.firestore().collection(code).document(code)
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating code field \(property): \(err)")
		}
	}
}
func fbUpdateCompanyProperty<T>(_ companyname:String, property:String, value:T){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	
	let itemRef = Firestore.firestore().collection(fb.companies).document(companyname)
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating logo field \(property): \(err)")
		}
	}
}

func fbUploadLesson(code:String,_ lesson:Lesson) {
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()

	let doc = try! Firestore.Encoder().encode(lesson)
	db.collection(upperCode).document(upperCode).collection(fb.lessons).document(String(lesson.id)).setData(doc)
}
func fbUploadConversation(code:String,_ conversation:Conversation) {
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()

	let doc = try! Firestore.Encoder().encode(conversation)
	db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.id)).setData(doc)
}
func fbUploadConversationNewPath(code:String,_ conversation:Conversation) {
	
	


	let db = Firestore.firestore()
	let upperCode = code.uppercased()

	//parent collection
	let conversationDoc = ConversationDoc(id: conversation.conversationNumber, conversationNumber: conversation.conversationNumber)
	let mainDoc = try! Firestore.Encoder().encode(conversationDoc)
	db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.conversationNumber)).setData(mainDoc)
	
	//sub collection
	let doc = try! Firestore.Encoder().encode(conversation)
	db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(conversation.conversationNumber)).collection(fb.questions).document(String(conversation.id)).setData(doc)
	

}
func fsReadCollectionCount(_ code:String, collection:String) async  -> Int {
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let query = db.collection(upperCode).document(upperCode).collection(collection)
	let countQuery = query.count
	do {
		let snapshot = try await countQuery.getAggregation(source: .server)
		//print(snapshot.count)
		return Int(truncating: snapshot.count)
	} catch {
		print(error);
		return -1
	}
}
