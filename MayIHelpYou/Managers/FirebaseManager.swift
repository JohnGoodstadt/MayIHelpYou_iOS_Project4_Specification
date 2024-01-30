//
//  FirebaseLibrary.swift
//  MayIHelpYou
//
//  Created by John goodstadt on 23/03/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

enum fb {
	static let code = "code"
	static let libraryCode = "libraryCode"
	static let companies = "companies"
	static let logo = "logo"
	static let name = "name"
	static let phrase = "phrase"
	static let audio = "audio"
	static let additional = "additional"
	static let phrases = "phrases"
//	static let lessonTabs = "lessonTabs" //TODO: going Obsolete - see below
	static let lessons = "lessons"
	static let conversations = "conversations"
	static let questions = "questions"
	static let avatars = "avatars"
	static let chats = "chats"
	static let attempts = "attempts"
	static let chatState = "chatState"
	static let lessonNumber = "lessonNumber"
	static let categoryNumber = "categoryNumber"
	static let title = "title"
	//static let phraseTabs = "phraseTabs"  //TODO: going Obsolete - see below
	static let phraseCategories = "phraseCategories"
	static let users = "users"
	static let authorizedusers = "authorizedusers"
	static let isauthorized = "isauthorized"
	static let authtoken = "authtoken"
	static let lastLoggedInDate = "lastLoggedInDate"
	static let lastLoggedOutDate = "lastLoggedOutDate"
	static let lastUpdateDate = "lastUpdateDate"
	static let isAnon = "isAnon"
	static let provider = "provider"
	static let loggedIn = "loggedIn"
	static let spokenName = "spokenName"
	static let lessonReminderTime = "lessonReminderTime"
	static let lessonReminderOn = "lessonReminderOn"
	
	static let voiceMale = "voiceMale"
	static let voiceName = "voiceName"
	
	static let statistics = "statistics"
	static let playedCount = "playedCount"
	static let lessonStatisticsObsolete = "lessonStatistics"
	static let complete = "complete"
	static let completed = "completed"
	static let playCycle = "playCycle"
//	static let waiting = "waiting"
	static let lessonState = "lessonState"
	static let phraseStatistic = "phraseStatistic"
	static let sortNumber = "sortNumber"
	
	static let lessonTabTitle = "lessonTabTitle"
	static let phrasesTabTitle = "phrasesTabTitle"
	static let practiceTabTitle = "practiceTabTitle"
	static let waitTimeTarget = "waitTimeTarget"
	//conversations
	static let conversationNumber = "conversationNumber"
	static let prompt = "prompt"
	static let correctChoice = "correctChoice"
	static let wrongChoice1 = "wrongChoice1"
	static let wrongChoice2 = "wrongChoice2"
	static let correctExplanation = "correctExplanation"
	static let wrong1Explanation = "wrong1Explanation"
	static let wrong2Explanation = "wrong2Explanation"
	//conversation counts stats
	static let wrongCount = "wrongCount" //covers 1 and 2
	static let wrong1count = "wrong1count"
	static let wrong2count = "wrong2count"
	static let correctCount = "correctCount"
	static let correct = "correct"
	
	static let mistakeCount = "mistakeCount"
	
	
	static let currentQuestionNumber = "currentQuestionNumber"
	static let createdDate = "createdDate"
	static let updatedDate = "updatedDate"
	static let stats = "stats"
	static let googleAPIAvoidedCount = "googleAPIAvoidedCount"
	static let googleAPICallCount = "googleAPICallCount"
	static let mail = "mail"
	
	
	

}
public extension Array {
	func chunked(by chunkSize:Int) -> [[Element]] {
		let groups = stride(from: 0, to: self.count, by: chunkSize).map {
			Array(self[$0..<[$0 + chunkSize, self.count].min()!])
		}
		return groups
	}
}


func signInAnonymously() async -> String {
	do {
		let authResult = try await Auth.auth().signInAnonymously()
		return authResult.user.uid
	} catch {
		return "Error: \(error.localizedDescription)"
	}
}


func createUserPhraseStatistic(_ code:String,_ phraseUID:String) {
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let doc = PhraseStatistic(id: phraseUID,playedCount: 0)
	
	let itemDoc = try! Firestore.Encoder().encode(doc)
	
	Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phrases).document(phraseUID).setData(itemDoc)

}
func updateUserLogoutStats(code:String, uid:String) {
	
	let upperCode = code.uppercased()
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(uid)
	
	itemRef.updateData([
		fb.loggedIn: false,fb.lastLoggedOutDate:Date()
	]) { err in
		if let err {
			print("Error updating fields: \(err)")
		}
	}
	
}
func updateUserLoginStats(code:String, spokenName:String) {
	
	//get all data from Firebase Auth
	if let currentUser = Auth.auth().currentUser {
		
		let uid = currentUser.uid
		_ = currentUser.phoneNumber
		_ = currentUser.isAnonymous
		let _ = currentUser.displayName
		_ = currentUser.isEmailVerified
		
		let _ = currentUser.providerID //Apple/facebook/google
		_ = currentUser.description
		_ = currentUser.metadata
		let providerData = currentUser.providerData
		
		if providerData.count > 0 {
			

			let firstProvider = providerData[0]
			let providerID = firstProvider.providerID

			let upperCode = code.uppercased()
			let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(uid)
			
			itemRef.updateData([
				fb.isAnon: false,fb.loggedIn: true,fb.spokenName: spokenName,fb.lastLoggedInDate:Date(),fb.provider:providerID
			]) { err in
				if let err {
					print("Error updating fields: \(err)")
				}else{
					
				}
			}
			
		}
	}
}
func fsUpdateUserDoc(code:String, spokenName:String) {
	
	//get all data from Firebase Auth
	if let currentUser = Auth.auth().currentUser {
		
		let uid = currentUser.uid
		_ = currentUser.phoneNumber
		_ = currentUser.isAnonymous
		let displayName = currentUser.displayName
		let email = currentUser.email ?? "unknown"
		let isEmailVerified = currentUser.isEmailVerified
		
		let providerCompany = currentUser.providerID //Apple/facebook/google
		_ = currentUser.description
		_ = currentUser.metadata
		let providerData = currentUser.providerData
		
		if providerData.count > 0 {
			

			let firstProvider = providerData[0]
			let providerID = firstProvider.providerID
		
			let user = User(id: uid,
							UID: uid,
							name: displayName ?? "Unknown",
							spokenName: spokenName,
							loggedIn: true,
							isAnon: false,
							provider: providerID,
							providerCompany: providerCompany,
							email: email,
							isEmailVerified:isEmailVerified,
							
							lastUpdateDate: Date(),
							lastLoggedInDate: Date(),
							lastLoggedOutDate: Date())
			
//			user.provider = providerID
			
			
			

			let upperCode = code.uppercased()
			let userDoc = try! Firestore.Encoder().encode(user)
			
			Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(uid).setData(userDoc)
			
			
		}
	}
	
	


}
func fbUploadLessonState(code:String,_ lessonStates:[LessonStateForUser]) {
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let batchItems = Firestore.firestore().batch()
	for lessonState in lessonStates {
		
		let itemDoc = try! Firestore.Encoder().encode(lessonState)
		
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.lessons).document(String(lessonState.id))
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Lesson stat write succeeded.")
		}
	}
}
func fbUploadChatState(code:String,_ chatState:ChatStateForUser) {
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()

	let doc = try! Firestore.Encoder().encode(chatState)
	
	db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chatState.id)).setData(doc)

}

func fbIncPracticeWrongCount(code:String, fieldName:String, _ conversationNumber:Int){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	
	//USER STAT
	let userDocRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(conversationNumber))
	
	userDocRef.updateData([fieldName: FieldValue.increment(Int64(1)),fb.updatedDate: Date()]) { err in
		if let err {
			print("Error updating user inc field \(fb.playedCount): \(err)")
			let err = err as NSError
			if err.code == 5 { //No Doc
					print("No Doc")
				
				let chatStateForUser = ChatStateForUser(conversationNumber:conversationNumber,currentQuestionNumber:1,completed:false)
				if fieldName == fb.correctCount {
					chatStateForUser.correctCount = 1
				}else{
					chatStateForUser.mistakeCount = 1
				}
				let doc = try! Firestore.Encoder().encode(chatStateForUser)

				db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(conversationNumber)).setData(doc)
				
			}
		}
	}
	

}
func fbIncPracticeCorrectCount(code:String, fieldName:String, _ conversationNumber:Int){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	
	//USER STAT
	let userDocRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(conversationNumber))
	
	userDocRef.updateData([fieldName: FieldValue.increment(Int64(1)),fb.updatedDate: Date()]) { err in
		if let err {
			print("Error updating user inc field \(fb.playedCount): \(err)")
		}
	}
	

}
func fbIncGoogleAPICount(code:String, fieldName:String){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	

	let userDocRef = db.collection(upperCode).document(upperCode).collection(fb.stats).document(fb.stats)
	
	userDocRef.updateData([fieldName: FieldValue.increment(Int64(1))]) { err in
		
		if let err {
			let err = err as NSError
			if err.code == 5 { //No Doc
				
				var doc = GoogleStats(googleAPIAvoidedCount: 0, googleAPICallCount: 1)
				if fieldName == fb.googleAPIAvoidedCount {
					doc = GoogleStats(googleAPIAvoidedCount: 1, googleAPICallCount: 0)
				}
				
				let statDoc = try! Firestore.Encoder().encode(doc)
				
				db.collection(upperCode).document(upperCode).collection(fb.stats).document(fb.stats).setData(statDoc)
				
			}
		}
	}
	

}
func fbUpdateChatAnswerAttemptCount(code:String,_ fieldName:String, attemptNumber:Int, _ chatUID:Int) {
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
/*
 see if doc exists else craete it ot update it
 */
	/*
	 correctCount
	 wrong1count
	 wrong2count
	 */
	
	Task {
		
		do {
			
			//does doc exist - if not create it else update it.
			let snapshot = try await db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chatUID)).collection(fb.attempts).document(String(attemptNumber)).getDocument()
			if snapshot.exists {
				let userDocRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chatUID)).collection(fb.attempts).document(String(attemptNumber))
				userDocRef.updateData([fieldName: FieldValue.increment(Int64(1))]) { err in
					if let err {
						print("Error updating user inc field '\(fieldName)': \(err)")
					}
				}
			}else{
				printhires("ANSWER collection doc NOT exist!")
				struct ChatAttempts: Encodable {
					let id:Int
					let correctCount:Int
					let wrongCount:Int
				}
				
				var _ = fieldName
				
				let correctCount = fieldName == fb.correctCount ? 1 : 0
				let wrongCount = fieldName == fb.wrongCount ? 1 : 0
				
				let chatAttempts = ChatAttempts(id: chatUID, correctCount: correctCount, wrongCount: wrongCount)
				
				let doc = try! Firestore.Encoder().encode(chatAttempts)
				try await db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chatUID)).collection(fb.attempts).document(String(attemptNumber)).setData(doc)
				
			}
		}
		catch {
			print(error)
		}
	}

}

func fbUpdateUserPracticeStatProperty<T>(code:String,chatID:Int, property:String, value:T){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let ref = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chatID))
	
	printhires("fbUpdateUserChatStateProperty() ID:\(chatID) \(property) value:\(value)")
	
	ref.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating chat property field \(property): \(err)")
			let err = err as NSError
			if err.code == 5 { //No Doc
					print("No Doc")
				
				//let stat = PhraseCategoryStatistic(id: String(categoryNumber))
				//let statDoc = try! Firestore.Encoder().encode(stat)
				
				//db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phraseCategories).document(String(categoryNumber)).setData(statDoc)
				
			}
		}
	}
}
func fsUpdatePlayedCount(_ code:String,_ PhraseUID:String){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	//GLOBAL STAT
	let docRef = db.collection(upperCode).document(upperCode).collection(fb.phrases).document(PhraseUID)
	docRef.updateData([fb.playedCount: FieldValue.increment(Int64(1))]) { err in
		if let err {
			print("Error updating inc field \(fb.playedCount): \(err)")
		}
	}
	
	//USER STAT
	let userDocRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phrases).document(PhraseUID)
	
	userDocRef.updateData([fb.playedCount: FieldValue.increment(Int64(1))]) { err in
		if let err {
			print("Error updating user inc field \(fb.playedCount): \(err)")
		}
	}
	

	
	
}
func fsUpdatePhraseCategoryPlayedCount(_ code:String, categoryNumber:Int){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	//PHRASE CATEGORY STAT
	let categoryDocRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phraseCategories).document(String(categoryNumber))
	
	categoryDocRef.updateData([fb.playedCount: FieldValue.increment(Int64(1)),fb.updatedDate: Date()]) { err in
		if let err {
			print("Error updating user inc field \(fb.playedCount): \(err)")
			let err = err as NSError
			if err.code == 5 { //No Doc
					print("No Doc")
				
				let stat = PhraseCategoryStatistic(id: String(categoryNumber))
				let statDoc = try! Firestore.Encoder().encode(stat)
				
				db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phraseCategories).document(String(categoryNumber)).setData(statDoc)
				
			}
			
			
			
		}
	}
}
func fsGetPhraseCategoryStats(_ code:String)async throws -> [PhraseCategoryStatistic]{
	
	guard let currentUser = Auth.auth().currentUser else { return [PhraseCategoryStatistic]() }
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	//PHRASE CATEGORY STAT
	let docRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phraseCategories)
	
	let snapshot = try await docRef.getDocuments()

	return snapshot.documents.compactMap { document in
		try? document.data(as: PhraseCategoryStatistic.self)
	}
	

}
func fsUploadPhraseCategories(_ code:String,_ categories:[PhraseCategory]) {
	
	let db = Firestore.firestore()

	let upperCode = code.uppercased()
	
	let batchItems = Firestore.firestore().batch()
	for category in categories {
		
		let itemDoc = try! Firestore.Encoder().encode(category)
		
		let itemDocRef = db.collection(upperCode).document(upperCode).collection(fb.phraseCategories).document(String(category.id))
		
		batchItems.setData(itemDoc, forDocument: itemDocRef)
		
	}
	batchItems.commit() { err in
		if let err {
			print("Error writing batch \(err)")
		} else {
			print("Batch category group write succeeded.")
		}
	}
}

func uploadLessonTabsDeprecated(company:String,code:String,_ lessonTabs:[Lesson]) {
	
	let db = Firestore.firestore()
	
	_ = company.lowercased()
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
func fbUploadPhrase(code:String,_ phrase:Phrase) {
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()

	let doc = try! Firestore.Encoder().encode(phrase)
	db.collection(upperCode).document(upperCode).collection(fb.phrases).document(String(phrase.id)).setData(doc)
}

func uploadPhraseCategory(code:String,_ category:PhraseCategory) {
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()

	let doc = try! Firestore.Encoder().encode(category)
	db.collection(upperCode).document(upperCode).collection(fb.phraseCategories).document(String(category.id)).setData(doc)
}
func fbResetAllUserLessonStats(code:String,_ lessons:[Lesson]){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let batch = db.batch()
	
	for lesson in lessons {
	
		let lessonRef =  db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.lessons).document(String(lesson.id))
		//TODO: can remove 'complete,waiting'
		batch.updateData([fb.playCycle:0,fb.lessonState:0], forDocument: lessonRef)
		
	}
	batch.commit() { err in
		if let err {
			print("Error writing batch resetAllUserStats():\(err) ")
		} else {
			print("Batch group write succeeded. resetAllUserStats()")
		}
	}
}
func fbResetAllUserChatState(code:String,_ chats:[PracticeChat]){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let batch = db.batch()
	
	//doc might not exist yet
	for chat in chats {
	
		let chatStateForUser = ChatStateForUser(conversationNumber:chat.conversationNumber,currentQuestionNumber:1,completed:false)
		let doc = try! Firestore.Encoder().encode(chatStateForUser)
		let chatRef =  db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chat.conversationNumber)) //cn is ID
		
		batch.setData(doc, forDocument: chatRef)
		
	}
	batch.commit() { err in
		if let err {
			print("Error writing batch resetAllUserChatState():\(err) ")
		} else {
			print("Batch group write succeeded. resetAllUserChatState()")
		}
	}
}
func fbResetChatAttempts(code:String,_ chats:[PracticeChat]){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let batch = db.batch()
	
	for chat in chats {
	
		let chatRef =  db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations).document(String(chat.conversationNumber)).collection(fb.attempts).document(String(chat.conversationNumber))
		batch.updateData([fb.completed:false,fb.currentQuestionNumber:1, fb.attempts:1], forDocument: chatRef)
		
	}
	batch.commit() { err in
		if let err {
			print("Error writing batch resetAllUserChatState():\(err) ")
		} else {
			print("Batch group write succeeded. resetAllUserChatState()")
		}
	}
}
func fbUpdateUserLessonStateProperty<T>(code:String,lessonID:Int, property:String, value:T){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let itemRef =  db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.lessons).document(String(lessonID))
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			print("Error updating code field \(property): \(err)")
		}
	}
}
func fbUpdateUserLessonStateProperties(code:String,lessonID:Int, lessonStateValue:Int, playCycleValue:Int){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let itemRef =  db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.lessons).document(String(lessonID))
	itemRef.updateData([
		fb.lessonState: lessonStateValue, fb.playCycle: playCycleValue
	]) { err in
		if let err {
			print("Error updating code fields in fbUpdateUserLessonStateProperties(): \(err)")
		}
	}
}
func fbUpdateUserLessonStateProperties(code:String,lessonID:Int, lessonStateValue:Int, playCycleValue:Int,waitTimeTargetValue:Date){
	
	guard let currentUser = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let itemRef =  db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.lessons).document(String(lessonID))
	itemRef.updateData([
		fb.lessonState: lessonStateValue, fb.playCycle: playCycleValue, fb.waitTimeTarget: waitTimeTargetValue
	]) { err in
		if let err {
			print("Error updating code fields in fbUpdateUserLessonStateProperties(): \(err)")
		}
	}
}

func validCodesForUser(authtoken:String) async -> [String]  {
	
	guard let _ = Auth.auth().currentUser else { return [] }
	
	var returnValue = [String]()
	
	do {
		var codes = [String]()
		
		let codesDocRef = Firestore.firestore().collection("codes")
		let snapshot = try await codesDocRef.getDocuments()
		for document in snapshot.documents {
			
			let code = document[fb.code] as! String
			codes.append(code)
		}
		print("all codes \(codes)")
		
		for code in codes {
			print("looking for \(code)")
			let upperCode = code.uppercased()
			let authDocRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.authorizedusers).whereField(fb.authtoken, isEqualTo:authtoken.lowercased()).whereField(fb.isauthorized, isEqualTo: true) as Query
			let authsnapshot = try await authDocRef.getDocuments()
			
			if authsnapshot.documents.isNotEmpty {
				print("auth code is \(code)")
				returnValue.append(code)
			}
		}
		

	}catch{
		printhires(error.localizedDescription)
		
	}

	return returnValue
}
func validCodesInApp() async -> [String]  {
	
	guard let _ = Auth.auth().currentUser else { return [] }
	
	var returnValue = [String]()
	
	do {
		var codes = [String]()
		
		let codesDocRef = Firestore.firestore().collection("codes")
		let snapshot = try await codesDocRef.getDocuments()
		for document in snapshot.documents {
			
			let code = document[fb.code] as! String
			codes.append(code)
		}
		print("all codes \(codes)")
		
		for code in codes {
			returnValue.append(code)
		}
		

	}catch{
		printhires(error.localizedDescription)
		
	}

	return returnValue
}
func doesCodeExist(code:String) async -> Bool  {
	
	
	guard code.isNotEmpty else{
		return false
	}
	
	let upperCode = code.uppercased()
	
	do{
		
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).getDocument()
		return snapshot.exists
	}catch{
		print(error)
	}
	return false
}
func doesUserExist(code:String) async -> Bool  {
	
	guard let uid = Auth.auth().currentUser?.uid else {
		return false
	}
			
	guard !code.isEmpty, !uid.isEmpty else{ return false }
	
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(uid).getDocument()
		return snapshot.exists
	}catch{
		print(error)
	}
	return false
}
func doesUserPhraseStatisticExist(code:String,_ phraseUID:String) async -> Bool  {
	
	guard let uid = Auth.auth().currentUser?.uid else { return false }
			
	guard !code.isEmpty, !phraseUID.isEmpty else { return false }
	
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(uid).collection(fb.phrases).document(phraseUID).getDocument()
		return snapshot.exists
	}catch{
		print(error)
	}
	return false
}
func doesUserExist(code:String, uid:String) async -> Bool  {
	
			
	guard !code.isEmpty, !uid.isEmpty else{ return false }
	
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(uid).getDocument()
		return snapshot.exists
	}catch{
		print(error)
	}
	return false
}

enum FBError: Error {
	case empty
	case nilUser
	case invalidUser
}

//func fbSignInWithDemoAccount2(_ email:String,_ password:String) async  -> (Result<String, FBError>) {
//
//	let result = await Auth.auth().signIn(withEmail: email, password: password) { result, err in
//		if let err = err {
//			printhires("Failed due to error:\(err)")
//			return .failure(FBError.invalidUser)
//		}else{
//			print("Successfully logged in with ID: \(result?.user.uid ?? "")")
//			return .success("")
//		}
//
//
//	}//: signIn
//}
func fbSignInWithDemoAccount(_ email:String,_ password:String) async -> (Result<Bool, Error>) {
	
	enum AuthUserError: Error {
		case userNotFound
		case other
		
	}
	
	var returnValue:Result<Bool, Error> = .failure(AuthUserError.userNotFound)
	
	do {
		let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
		let user = authDataResult.user
		
		print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
		//self.isSignedIn = true
		//	return true
		returnValue = .success(true) //only sucess exit
	}
	catch {
		print("There was an issue when trying to sign in: \(error)")
		//self.errorMessage = error.localizedDescription
		//	return false
		returnValue = .failure(AuthUserError.userNotFound)
	}
	
	return returnValue
}

func downloadStaticLessonData(company:String,code:String) async -> (Result<[String: Any], FBError>)  {
	
	guard let _ = Auth.auth().currentUser else { return .failure(FBError.nilUser) }
	
	let db = Firestore.firestore()
	
	do{
		
		guard !company.isEmpty else{
			return .failure(FBError.empty)
		}
		
		_ = company.lowercased()
		let upperCode = code.uppercased()
		
		let collection0Ref = db.collection(upperCode).document(upperCode)
		let collection1Ref = db.collection(upperCode).document(upperCode).collection(fb.phraseCategories)
		let collection2Ref = db.collection(upperCode).document(upperCode).collection(fb.lessons)
		let collection3Ref = db.collection(upperCode).document(upperCode).collection(fb.phrases)

		
		let collection0Snap = try await collection0Ref.getDocument()
		let collection1Snap = try await collection1Ref.getDocuments()
		let collection2Snap = try await collection2Ref.getDocuments()
		let collection3Snap = try await collection3Ref.getDocuments()
		
		let collection0SnapArray = [collection0Snap]
		let collection0Data = try collection0SnapArray.map { try $0.data(as: LibraryCode.self) }
		let collection1Data = try collection1Snap.documents.map { try $0.data(as: PhraseCategory.self) }
		let collection2Data = try collection2Snap.documents.map { try $0.data(as: Lesson.self) }
		let collection3Data = try collection3Snap.documents.map { try $0.data(as: Phrase.self) }
		
		let collections: [String: Any] = [
			fb.code: collection0Data,
			fb.phraseCategories: collection1Data,
			fb.lessons: collection2Data,
			fb.phrases: collection3Data
		  ]
		
		
		return .success(collections)
	}catch{
		print("====== ERROR =====")
		print("= FirebaseManager.downloadEverything() =")
		print("====== ERROR =====")
		print(error)
	}
	return .failure(FBError.empty)
}
func downloadEverything(code:String) async -> (Result<[String: Any], FBError>)  {
	//TODO: could add user. For now just using Spoken Name
	guard let currentUser = Auth.auth().currentUser else { return .failure(FBError.nilUser) }

	
	let db = Firestore.firestore()
	
	do{
		
		let upperCode = code.uppercased()
		
		let collection0Ref = db.collection(upperCode).document(upperCode)
		let collection1Ref = db.collection(upperCode).document(upperCode).collection(fb.phraseCategories)
		let collection2Ref = db.collection(upperCode).document(upperCode).collection(fb.lessons)
		let collection3Ref = db.collection(upperCode).document(upperCode).collection(fb.phrases)
		let collection4Ref = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.lessons)
		let collection5Ref = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.phrases)
		let collection6Ref = db.collection(upperCode).document(upperCode).collection(fb.conversations)
		let collection7Ref = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).collection(fb.conversations)
		let collection8Ref = db.collection(upperCode).document(upperCode).collection(fb.avatars)

		
		let collection0Snap = try await collection0Ref.getDocument()
		let collection1Snap = try await collection1Ref.getDocuments()
		let collection2Snap = try await collection2Ref.getDocuments()
		let collection3Snap = try await collection3Ref.getDocuments()
		let collection4Snap = try await collection4Ref.getDocuments()
		let collection5Snap = try await collection5Ref.getDocuments()
		let collection6Snap = try await collection6Ref.getDocuments()
		let collection7Snap = try await collection7Ref.getDocuments()
		let collection8Snap = try await collection8Ref.getDocuments()
		
		
		
		let collection0SnapArray = [collection0Snap]
		let collection0Data = try collection0SnapArray.map { try $0.data(as: LibraryCode.self) }
		let collection1Data = try collection1Snap.documents.map { try $0.data(as: PhraseCategory.self) }
		let collection2Data = try collection2Snap.documents.map { try $0.data(as: Lesson.self) }
		let collection3Data = try collection3Snap.documents.map { try $0.data(as: Phrase.self) }
		let collection4Data = try collection4Snap.documents.map { try $0.data(as: LessonStateForUser.self) }
		let collection5Data = try collection5Snap.documents.map { try $0.data(as: PhraseStatistic.self) }
		let collection6Data = try collection6Snap.documents.map { try $0.data(as: Conversation.self) }
		let collection7Data = try collection7Snap.documents.map { try $0.data(as: ChatStateForUser.self) }
		let collection8Data = try collection8Snap.documents.map { try $0.data(as: Avatar.self) }
		
		//TODO: Temp code whilst moving to new path
		//get sub path
		var conversationsNewPath:[Conversation] = [Conversation]()
		
		
		for c in collection6Data {
			let collectionRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String( c.id)).collection(fb.questions)
			let collectionSnap = try await collectionRef.getDocuments()
			let collectionData = try collectionSnap.documents.map { try $0.data(as: Conversation.self) }
			
			
			if collectionData.isNotEmpty {
				conversationsNewPath.append(contentsOf: collectionData)
			}
		}
		
		
		/*
		if let c1 = collection6Data.first(where: {$0.id == 1}) {
			
			let collectionRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String( c1.conversationNumber)).collection(fb.questions)
			let collectionSnap = try await collectionRef.getDocuments()
			let collectionData = try collectionSnap.documents.map { try $0.data(as: Conversation.self) }
			
//			dump(collectionData)
			
			
			conversationsNewPath.append(contentsOf: collectionData)
		}
		
		if let c2 = collection6Data.first(where: {$0.conversationNumber == 2}) {
			
			let collectionRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String( c2.conversationNumber)).collection(fb.questions)
			let collectionSnap = try await collectionRef.getDocuments()
			let collectionData = try collectionSnap.documents.map { try $0.data(as: Conversation.self) }
			
			conversationsNewPath.append(contentsOf: collectionData)
		}
		
		if let c3 = collection6Data.first(where: {$0.conversationNumber == 3}) {
			
			let collectionRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String( c3.conversationNumber)).collection(fb.questions)
			let collectionSnap = try await collectionRef.getDocuments()
			let collectionData = try collectionSnap.documents.map { try $0.data(as: Conversation.self) }
			
			//conversationsNewPath.append(contentsOf: collectionData)
		}
		*/

		
		
		
		let collections: [String: Any] = [
			fb.code: collection0Data,
			fb.phraseCategories: collection1Data,
			fb.lessons: collection2Data,
			fb.phrases: collection3Data,
			fb.lessonState: collection4Data,
			fb.phraseStatistic: collection5Data,
//			fb.conversations: collection6Data,
			fb.conversations: conversationsNewPath,
			fb.chatState: collection7Data,
			fb.avatars: collection8Data
		  ]
		
		
		return .success(collections)
	}catch{
		print("====== ERROR =====")
		print("= FirebaseManager.downloadEverything() =")
		print("====== ERROR =====")
		print(error)
	}
	return .failure(FBError.empty)
}

enum CustomError: Error {
	case firestoreError
}
func fsDownloadLibraryCodeDoc(code:String) async -> LibraryCode?  {
	
	//<ake sure user is signed in
	guard let _ = Auth.auth().currentUser else { return nil }
	
	_ = Firestore.firestore()
	
	do{
		
		let upperCode = code.uppercased()
		
		
//		let collection0Ref = db.collection(upperCode).document(upperCode)
//		let collection0Snap = try await collection0Ref.getDocument()
//		let collection0SnapArray = [collection0Snap]
//		let libraryCode = try collection0SnapArray.map { try $0.data(as: LibraryCode.self) }
//
		
		let docRef = Firestore.firestore().collection(upperCode).document(upperCode)//  as Query
		let snapshot = try await docRef.getDocument()

		return try? snapshot.data(as: LibraryCode.self)
		
		
//		let docRef99 = Firestore.firestore().collection(code).document(code)
//		docRef99.getDocument { (document, error) in
//			if let document = document, document.exists {
//
//				let libraryCode99 = try document.data(as: LibraryCode.self)
//
//				return libraryCode99
//
//			} else {
//				if (error != nil) {
//					print(error ?? "error in doesUserExist()")
//				}
//				print("Document does not exist")
//
//				return nil
//			}
//		}
		
		
		
		
		
	}catch{
		print("====== ERROR =====")
		print("= FirebaseManager.fsDownloadLibraryCodeDoc() =")
		print("====== ERROR =====")
		print(error)
	}
	
	return nil
}
func getCollections() async throws -> [String: Any] {
	let db = Firestore.firestore()
	let collection1Ref = db.collection("collection1")
	let collection2Ref = db.collection("collection2")
	let collection3Ref = db.collection("collection3")
	
	do {
		let collection1Snap = try await collection1Ref.getDocuments()
		let collection2Snap = try await collection2Ref.getDocuments()
		let collection3Snap = try await collection3Ref.getDocuments()
		
		let collection1Data = collection1Snap.documents.map { $0.data() }
		let collection2Data = collection2Snap.documents.map { $0.data() }
		let collection3Data = collection3Snap.documents.map { $0.data() }
		
		let collections: [String: Any] = [
			"collection1": collection1Data,
			"collection2": collection2Data,
			"collection3": collection3Data
		]
		
		return collections
	} catch {
		throw CustomError.firestoreError
	}
}

func updateAudioProperty<T>(_ code:String, property:String, value:T, UID:String){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.phrases).document(UID)
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			// can get validly when starting to create a new  RecallItem - not yet created doc
			//- Error updating field words: Error Domain=FIRFirestoreErrorDomain Code=5 "No document to update:
			print("Error updating field \(property): \(err)")
		}
	}
}
func fbUpdateUserDateProperty(_ code:String, property:String, value:Date ) {
	guard let currentUser = Auth.auth().currentUser else{
		return
	}
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid)
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			// can get validly when starting to create a new  RecallItem - not yet created doc
			//- Error updating field words: Error Domain=FIRFirestoreErrorDomain Code=5 "No document to update:
			print("Error updating date field \(property): \(err)")
		}
	}
	
}
func fbUpdateUserProperty<T>(_ code:String, property:String, value:T ) {
	guard let currentUser = Auth.auth().currentUser else { return }
	
	let upperCode = code.uppercased()
	
	let itemRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid)
	itemRef.updateData([
		property: value
	]) { err in
		if let err {
			// can get validly when starting to create a new  RecallItem - not yet created doc
			//- Error updating field words: Error Domain=FIRFirestoreErrorDomain Code=5 "No document to update:
			print("Error updating field \(property): \(err)")
		}
	}
	
}
func readUserDateProperty(_ code:String, property:String) async -> Date? {
	guard let currentUser = Auth.auth().currentUser else {
		return nil
	}
	
	var returnValue:Date?
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).getDocument()
		
				if let propertyValue = snapshot.get(property) {
					if propertyValue is Timestamp {
						if let pv = propertyValue as? Timestamp {
							returnValue = pv.dateValue()
							print("IN readUserProperty value is \(String(describing: returnValue))")
						}
					}
					
				}
		
		return returnValue
	}catch{
		print(error)
	}
	
	return nil
	
}

func fsReadUserVariables(_ code:String) async -> UserVariables? {
	
	guard let currentUser = Auth.auth().currentUser else {
		return nil
	}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	do {
		
		let docRef = db.collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid)
		let snapshot = try await docRef.getDocument()

		return try? snapshot.data(as: UserVariables.self)
		
	
	}catch {
		printhires(error.localizedDescription)
	}
	
	return nil
	
}
func read2UserProperties(_ code:String, property1:String, property2:String) async -> (On:Bool,time:Date)? {
	guard let currentUser = Auth.auth().currentUser else {
		return nil
	}
	
	var returnValue:(Bool,Date)? = nil
	var date = Date()
	var bool = true
	
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).getDocument()
		
		if let property1Value = snapshot.get(property1) {
			if property1Value is Timestamp {
				if let pv = property1Value as? Timestamp {
					date = pv.dateValue()
					print("IN readUserProperty value is \(String(describing: returnValue))")
				}
			}
		}
		
		if let property2Value = snapshot.get(property2) {
			if property2Value is Bool {
				if let pv = property2Value as? Bool {
					bool = pv
					print("In readUserProperty value is \(String(describing: returnValue))")
				}
			}
		}
		
		returnValue = (bool,date)
		
		return returnValue
	}catch{
		print(error)
	}
	
	return nil
	
}
func readUserPropertyBool(_ code:String, property:String) async -> Bool {
	
	var returnValue = false
	
	guard let currentUser = Auth.auth().currentUser else{
		return returnValue
	}
	
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).getDocument()
		
		if let propertyValue = snapshot.get(property) {
			if propertyValue is Bool {
				if let pv = propertyValue as? Bool {
					returnValue = pv
				}
			}
		}
		
		return returnValue
	}catch{
		print(error)
	}

	return returnValue
}
func readUserProperty(_ code:String, property:String) async -> String {
	guard let currentUser = Auth.auth().currentUser else{
		return ""
	}
	
	var returnValue = ""
	let upperCode = code.uppercased()
	
	do{
		let snapshot = try await Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.users).document(currentUser.uid).getDocument()
		
		if let propertyValue = snapshot.get(property) {
			if propertyValue is String {
				if let pv = propertyValue as? String {
					returnValue = pv//propertyValue as! String
					print("In readUserProperty value is \(returnValue)")
				}
			}
		}
		
		return returnValue
	}catch{
		print(error)
	}

	return returnValue
	
}

func fbReadCompanyProperty(_ companyname:String, property:String) async -> Data {

	var jpg = Data()
	
	guard let _ = Auth.auth().currentUser else { return jpg }
	
	let db = Firestore.firestore()

	let docRef = db.collection(fb.companies).document(companyname)

//	Task {
//		do {
			try await docRef.getDocument { (document, error) in
				if let document = document, document.exists {
					
					let docData = document.data()
					print(docData?[fb.name] ?? "unknown name")
					if let logoData = docData?[fb.logo]  as? Data {
						print("fbReadCompanyProperty:\(logoData.count)")
						jpg = logoData
					}
				} else {
					print("Document does not exist")
				}
			}
//		}catch {
//			print(error)
//		}
//	}

	


	return jpg
}
func fbDeletePhraseCategory(_ code:String,  UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	print("Deleting category:\(UID)")
	
	
	Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.phraseCategories).document(String(UID)).delete() { err in
		if let err {
			print("Error removing category \(UID) document: \(err)")
		}
	}
	
}
func fbDeleteLesson(_ code:String,  UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let upperCode = code.uppercased()
	print("Deleting lesson:\(UID)")
	

	Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.lessons).document(String(UID)).delete() { err in
		if let err {
			print("Error removing lesson \(UID) document: \(err)")
		}
	}
	
}
func fbUpdateConversationCountProperty(_ code:String, property:String, UID:Int){
	
	guard let _ = Auth.auth().currentUser else {return}
	
	let db = Firestore.firestore()
	let upperCode = code.uppercased()
	
	let docRef = db.collection(upperCode).document(upperCode).collection(fb.conversations).document(String(UID))
	docRef.updateData([property: FieldValue.increment(Int64(1))]) { err in
		if let err {
			print("Error updating inc field \(property): \(err)")
		}
	}
	
}

func fbIsCurrentUserAuthorizedAsyncAwait(code:String,authtoken:String) async -> (Result<Bool, Error>) {
	
	enum AuthUserError: Error {
		case notLoggedIn
		case notAuthorized
	}
	
	var returnValue:Result<Bool, Error> = .failure(AuthUserError.notLoggedIn)
	
	
	guard let _ = Auth.auth().currentUser else { //user not logged in with firebase auth
		return returnValue
	}
	
	let upperCode = code.uppercased()
	
	do {
		let docRef = Firestore.firestore().collection(upperCode).document(upperCode).collection(fb.authorizedusers).whereField(fb.authtoken, isEqualTo:authtoken.lowercased()).whereField(fb.isauthorized, isEqualTo: true) as Query
		let snapshot = try await docRef.getDocuments()
		
		if snapshot.documents.isEmpty {
			returnValue = .failure(AuthUserError.notAuthorized)
		}else{
			returnValue = .success(true) //only sucess exit
		}
		

	}catch{
		printhires(error.localizedDescription)
		returnValue = .failure(error)
	}

	return returnValue

}

func fsSendEmail(code:String,company:String,spokenname:String){

	guard let currentUser = Auth.auth().currentUser else {return}
	
	struct SendEmail: Encodable {
		let to:String
		let message:[String:String]
		let template:[String:String]//replace name
	}
	/*
	 to: ["someone@gmail.com"],
		 template: {
		   name: "subscribe",
		   data: {
			 name: "Darren",
		   },
		 },
	 */
	
	var message = ["html":"This is some html <code>HTML</code>","subject":"An email from 'May I Help You'","text":"some plain text"]
	let template = ["name":"subscribe","data":"\(spokenname)"]
	
	if code.isNotEmpty && company.isNotEmpty {
		message = ["subject":"An email from 'May I Help You'","text":"A message from company \(company) about code \(code). I cannot login, my email is \(currentUser.email ?? "Unknown email") and unique id is \(currentUser.uid). Can you please sort me out?"]
	}
	
	
	
	let sendEmail = SendEmail(to: "johngoodstadt@icloud.com", message: message, template: template)
	
	
	
	let db = Firestore.firestore()

	
	let emailDoc = try! Firestore.Encoder().encode(sendEmail)
	
	//let docRef = db.collection("email").document("email")
	
	db.collection(fb.mail).document(fb.mail).setData(emailDoc)
	
	
}
