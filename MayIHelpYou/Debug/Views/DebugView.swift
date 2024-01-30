//
//  DebugView.swift
//  May I Help You?
//
//  Created by John goodstadt on 17/03/2023.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseFirestoreSwift
import Firebase

struct DebugView: View {
	@EnvironmentObject private var dataManager:DataManager
	
	@StateObject private var viewModel = ViewModel()
	@State private var phraseCount:Int = 0
	@State private var lessonTabCount:Int = 0
	@State private var phraseTabCount:Int = 0
	
	@State private var showingVerificationCodeAlert = false
	@State private var showingLoginNoPasswordAlert = false
	@State private var passwordLessEmail = ""
	@State private var verificationCode = ""
	@State private var currentLoginState = ""
	@State private var currentLoginStateValue = "State"
	@State private var showingUploadAudioAlert = false
	
	var body: some View {
		
		ScrollView(.vertical, showsIndicators: false) {
			VStack(spacing: 20) {
				GroupBox(
					label:
						ControlPanelLabelView(labelText: "Admin Values", labelImage: "book.circle")
					
				) {
					
					ControlPanelRowView(name: "Number of Phrases​", content: String(phraseCount))
					ControlPanelRowView(name: "Number of Lessons​", content: String(lessonTabCount))
					ControlPanelRowView(name: "Number of Categories​", content: String(phraseTabCount))
					ControlPanelRowView(name: "Company Name​", content: defaultCompanyName)
					ControlPanelRowView(name: "Library Code​", content: dataManager.libraryCode.code)
					
					ControlPanelRowView(name: "Colors​", content: dataManager.libraryCode.COLORHigh.description)
					
					
				}
				.padding()
				
				GroupBox(
					label:
						ControlPanelLabelView(labelText: "Login", labelImage: "person.circle")
				) {
					
					ControlPanelRowView(name: currentLoginState, content: currentLoginStateValue)
					
					ControlPanelButtonView(buttonPressed: { self.loginTelephoneButtonPressed() }, name: "+1 650 555 1111", value: "Login")
						.alert("Enter Code", isPresented: $showingVerificationCodeAlert) {
							TextField("", text: $verificationCode)
							Button("OK", action: phoneNumberVerificationCodeButtonPressed)
						} message: {
							Text("Enter the 6 digit code.")
						}
					ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed() }, name: "john.goodstadt@alex.com", value: "Login")
					ControlPanelButtonView(buttonPressed: { self.loginNoPasswordButtonPressed() }, name: "No password email", value: "Login")
						.alert("Enter Email", isPresented: $showingLoginNoPasswordAlert) {
							TextField("", text: $passwordLessEmail)
							Button("OK", action: loginNoPasswordAction)
						} message: {
							Text("Enter a valid email  to receive a link.")
						}
					ControlPanelButtonView(buttonPressed: { self.logoutButtonPressed() }, name: "Logout", value: "Logout")
					
					
					
				}
				.padding()
				
				GroupBox(
					label:
						ControlPanelLabelView(labelText: "Admin Actions", labelImage: "book.circle")
				) {
					
					ControlPanelRowView(name: "Paths​", content: "/\(dataManager.libraryCode.code)/phrases")
					
					ControlPanelButtonView(buttonPressed: { self.loadStarterPhrasesButtonPressed() }, name: "Load Starter set of phrases", value: "Load")
					ControlPanelButtonView(buttonPressed: { self.downloadButtonPressed() }, name: "Download all values", value: "Download")
					ControlPanelButtonView(buttonPressed: { self.uploadPhrasesButtonPressed() }, name: "Upload Phrases", value: "Upload")
					ControlPanelButtonView(buttonPressed: { self.uploadAllButtonPressed() }, name: "Upload All", value: "UPLOAD")
					ControlPanelButtonView(buttonPressed: { self.uploadStatsButtonPressed() }, name: "Upload Statistics", value: "Stats")
					ControlPanelButtonView(buttonPressed: { self.uploadAudioButtonPressed() }, name: "Upload Audio", value: "Preview")
						.sheet(isPresented: $showingUploadAudioAlert) {
							DebugUploadAudioView()
						}
					ControlPanelButtonView(buttonPressed: { self.speakUsingGoogleAPI() }, name: "Upload Statistics", value: "Stats")
				}
				.padding()
				
				//https://github.com/googleapis/google-cloud-ios.git

				
				//				Text("\(dataManager.libraryCode.code)/phrases").font(.footnote)
				//				Text("\(dataManager.libraryCode.code)/lessonTabs").font(.footnote)
				//				Text("\(dataManager.libraryCode.code)/phraseTabs").font(.footnote)
				
			}//: VSTACK
			//		.background(LinearGradient(gradient: Gradient(colors: [dataManager.libraryCode.COLORHigh, dataManager.libraryCode.COLORLow]), startPoint: .top, endPoint: .bottom))
			.background(dataManager.libraryCode.COLORHigh)
			//		.background(Color.red)
			.onAppear{
				
				calcCounts()
				
				assignLoginState()
				
				
				
			}
		}//: SCROLL
		
		
		
		
		
	}
	func speakUsingGoogleAPI(){
		//https://github.com/googleapis/google-cloud-ios.git
		let _ = "Hello John"
	}
	func assignLoginState(){
		if let currentUser = Auth.auth().currentUser {
			
//			let uid = currentUser.uid
//			let phoneNumber = currentUser.phoneNumber
			let isAnonymous = currentUser.isAnonymous
//			let displayName = currentUser.displayName
//			let isEmailVerified = currentUser.isEmailVerified
			
//			let _ = currentUser.providerID //Apple/facebook/google
//			let description = currentUser.description
//			let metadata = currentUser.metadata
			let providerData = currentUser.providerData
			
			if providerData.count > 0 {
				let pro = providerData[0]
				let providerID = pro.providerID
				
				switch providerID {
					case "phone":
						currentLoginStateValue = "Phone"
						currentLoginState = "Logged in:"
					case "password":
						currentLoginStateValue = "Email/Password"
						currentLoginState = "Logged in:"
					default:
						currentLoginStateValue = isAnonymous ? "Anon" : "Not Anon"
						currentLoginState = "TODO"
				}
				
				
				
				print(providerID)
			}else{
				
				currentLoginStateValue = isAnonymous ? "Anon" : "Not Anon"
				currentLoginState = "State"
				
			}
		}else{
			currentLoginStateValue = "Not Logged In"
			currentLoginState = "Login State"
		}
		
	}
	func loginNoPasswordAction(){
		
	}
	func loginNoPasswordButtonPressed(){
		self.showingLoginNoPasswordAlert = true
	}
	func logoutButtonPressed() {
		
		let auth = Auth.auth()
		
		do {
			let previousUID = Auth.auth().currentUser?.uid ?? ""
		
			try auth.signOut()
			
			assignLoginState()
			
			Task {
				let exists = await doesUserExist( code: dataManager.libraryCode.code, uid: previousUID)
				if exists {
					print("user \(previousUID.prefix(4)) EXISTS") //NOTE: should always be true
					updateUserLogoutStats(code: dataManager.libraryCode.code,uid:previousUID)
				}
			}

			
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
			currentLoginState = "Error"
			currentLoginStateValue = String(signOutError.localizedDescription.prefix(4))
		}
	}
	
	func phoneNumberVerificationCodeButtonPressed(){
		AuthManager.shared.verifyCode(smsCode: self.verificationCode) { success in
			guard success else {
				print("verifyCode failed")
				currentLoginStateValue = "verifyCode failed"
				currentLoginState = "Phone Error"
				return
			}
			
			print("TELEPHONE NUMBER LOGIN SUCCESS !")
	
			
			assignLoginState()
			
			Task {
				let exists = await doesUserExist( code: dataManager.libraryCode.code)
				if exists {
					print("user EXISTS")
					//TODO: add spoken Name
					updateUserLoginStats(code: dataManager.libraryCode.code, spokenName: "")
				}else{
					fsUpdateUserDoc(code: dataManager.libraryCode.code, spokenName: "")
				}
			}
			
		}
	}
	
	let phoneNumber = "+16505551111"
	let myphoneNumber = "+447808163865"
	func loginTelephoneButtonPressed() {
		AuthManager.shared.startAuth(phoneNumber: phoneNumber, completion: {/* [weak self]*/ success in
			guard success else {
				print("Error")
				return
			}
			
			self.showingVerificationCodeAlert = true
			
		})
	}
	func mutLoginTelephoneButtonPressed() {
#if DCONT_COMPILE
		var isVerified : Bool = false
		var verificationID : String?// = nil
		let telephone = "+447808163865"
		
		if !isVerified {
			Auth.auth().settings?.isAppVerificationDisabledForTesting = false
			PhoneAuthProvider.provider().verifyPhoneNumber(telephone, uiDelegate: nil, completion: {verificationID, error in
				print("PhoneAuthProvider")
				if error != nil {
					print(error?.localizedDescription)
					//					print(error)
					return
				}else{
					//self.verificationID = verificationID
					isVerified = true
					//					verificationID = verificationID
				}
			})
		}else{
			guard let verificationID else {
				print()
				return
			}
			
			let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: telephone)
			Auth.auth().signIn(with: credential, completion: { authData, error in
				if error != nil {
					print(error)
				}else{
					print("AUTH OK WITH \(authData?.user.phoneNumber ?? "NA") Phone Number")
				}
			})
		}
#endif
	}
	func loginEmailButtonPressed() {
		
		let email = "john.goodstadt@alex.com" //l4o4FJgOOEXRmxT9g1iaQwcs7eT2
		let password = "password"
		
		Auth.auth().signIn(withEmail: email, password: password) { result, err in
			if let err = err {
				print("Failed due to error:", err)
				currentLoginStateValue = String(err.localizedDescription.prefix(4))
				currentLoginState = "Email Error"
				return
			}
			
			//			print("Successfully logged in with ID: \(result?.user.uid ?? "")")

			
			assignLoginState()
			
			Task {
				let exists = await doesUserExist( code: dataManager.libraryCode.code)
				if exists {
					print("user EXISTS")
					updateUserLoginStats(code: dataManager.libraryCode.code, spokenName: "")
				}else{
					fsUpdateUserDoc(code: dataManager.libraryCode.code, spokenName: "")
				}
			}
			
		}
		
	}
	func uploadAudioButtonPressed(){
		showingUploadAudioAlert = true
	}
	func uploadStatsButtonPressed(){
		dataManager.updateLessonState(dataManager.libraryCode.code)
	}
	func uploadAllButtonPressed() {
		print("I am the uploadAllButtonPressed")
		
		uploadLibraryCodeDoc( code: dataManager.libraryCode.code)
		uploadPhrases(company: defaultCompanyName, code: dataManager.libraryCode.code, viewModel.bundlePhrases)
		fsUploadLessons(dataManager.libraryCode.code,viewModel.bundleLessonTabs)
		uploadPhraseCategories(company: defaultCompanyName, code: dataManager.libraryCode.code,viewModel.bundlePhraseCategories)
		
	}
	func uploadPhrasesButtonPressed() {
		print("I am the uploadPhrasesButtonPressed")
		uploadPhrases(company: defaultCompanyName, code: dataManager.libraryCode.code, viewModel.bundlePhrases)
		
		
	}
	func loadStarterPhrasesButtonPressed(){
		dataManager.updateApp(libraryCode:MinimalLibraryCode, phrases:  StarterPhrases, phraseCategories: StarterPhraseCategories, lessons: StarterLessons, lessonStatesForUser: [LessonStateForUser](),avatars: MinimalAvatars)
	}
	func downloadButtonPressed() {
			dataManager.downloadEverthing()
	}
	//TODO: DELETE THIS?
	#if DONT_COMPILE
	func download_Everthing_MOVED() async{
		
		let result = await download_Everything( company: defaultCompanyName, code: dataManager.libraryCode.code)
		
		switch result {
			case .success(let everything):
				print("success getting everything")
				
				let fbLibraryCode = everything[fb.code]
				let fbphraseCategories = everything[fb.phraseCategories]
				let fblessonTabs = everything[fb.lessons]
				let fbphrases = everything[fb.phrases]
				
				guard fbphrases is [Phrase], fblessonTabs is [Lesson], fbphraseTabs is [Lesson] , fbLibraryCode is [LibraryCode] else{
					print("Error getting data")
					return
				}
				
				
				
				guard let libraryCode = fbLibraryCode as?  [LibraryCode], libraryCode.count == 1 else { return }
				guard let phrases = fbphrases as?  [Phrase] else { return }
				guard let phraseCategories = fbphraseCategories as?  [Lesson] else { return }
				guard let lessons = fblessonTabs as?  [Lesson] else { return }
				
				print("phrases:\(phrases.count)")
				print("phraseCategories:\(phraseCategories.count)")
				print("lessonTabs:\(lessons.count)")
				
				if let lc = libraryCode.first {
					dataManager.updateApp(libraryCode:lc, phrases:  phrases, phraseCategories: phraseCategories, lessons: lessons, lessonState: [LessonStateForUser](),avatars: MinimalAvatars)
				}
				
				
			case .failure(let error):
				print(error.localizedDescription) // Prints the error message
		}
	}
	#endif
	func calcCounts(){
		
		Task{
			let count = await countAggregateCollection()
			let countLessonsTabs = await countAggregateLessonCollection()
			let countPhraseTabs = await countAggregatePhraseCollection()
			print("phrase count:\(count) phrase tab count:\(countPhraseTabs) lesson tab count \(countLessonsTabs)")
			self.phraseCount = count
			self.lessonTabCount = countLessonsTabs
			self.phraseTabCount = countPhraseTabs
			
		}
		
	}
	private func countAggregateCollection() async -> Int {
		let countQuery =  Firestore.firestore().collection(defaultCompanyName.lowercased()).document(dataManager.libraryCode.code.uppercased()).collection(fb.phrases).count
		do {
			let snapshot = try await countQuery.getAggregation(source: .server)
			return Int(truncating: snapshot.count)
		} catch {
			print(error);
		}
		return(0)
	}
	private func countAggregateLessonCollection() async -> Int {
		let countQuery =  Firestore.firestore().collection(defaultCompanyName.lowercased()).document(dataManager.libraryCode.code.uppercased()).collection(fb.lessons).count
		do {
			let snapshot = try await countQuery.getAggregation(source: .server)
			return Int(truncating: snapshot.count)
		} catch {
			print(error);
		}
		return(0)
	}
	private func countAggregatePhraseCollection() async -> Int {
		let countQuery =  Firestore.firestore().collection(defaultCompanyName.lowercased()).document(dataManager.libraryCode.code.uppercased()).collection(fb.phraseCategories).count
		do {
			let snapshot = try await countQuery.getAggregation(source: .server)
			return Int(truncating: snapshot.count)
		} catch {
			print(error);
		}
		return(0)
	}
	
}

struct DebugView_Previews: PreviewProvider {
	
	static var previews: some View {
		DebugView()
	}
}
