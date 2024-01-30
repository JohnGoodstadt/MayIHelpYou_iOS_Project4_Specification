//
//  LoginView.swift
//  May I Help You?
//
//  Created by John goodstadt on 22/03/2023.
//

import SwiftUI
import FirebaseAuth
import AlertToast
import AVFAudio

@available(iOS 15.0, *)
struct LoginView: View {
	@AppStorage("isOnboarding") var isOnboarding: Bool?
	@Environment(\.presentationMode) var presentationMode
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject private var dataManager:DataManager
	@EnvironmentObject private var colorManager:ColorManager
	
	@StateObject private var viewModel = ViewModel()
	
	@State var username = defaultUsername
	@State var libraryCode = defaultLibraryCode
//	@State var spokenName = ""
	
	@State private var showingVerificationCodeAlert = false
	@State private var showingLoginNoPasswordAlert = false
	@State private var passwordLessEmail = ""
	@State private var verificationCode = ""
	@State private var currentLoginState = ""
	@State private var currentLoginStateValue = "State"
	@State private var showingFBCodeErrorAlert = false
	@State private var showingSpokenNameErrorAlert = false
	@State private var showingLoginErrorToast = false
	@State private var showingLoginErrorToastMessage = ""

	
	var body: some View {
		
		ScrollView {
			
			VStack(){
				VStack {
					//Color.green
					Text("May I Help You ?")
						.foregroundColor(colorManager.current.baseForeground)
						.font(.largeTitle)
						.fontWeight(.bold)
						.padding(.top,40)
					Text("Your Customer Service Coach")
						.foregroundColor(colorManager.current.baseForeground)
						.font(.title2)
						.fontWeight(.bold)
						.padding(.top,1)
					
					
				} //: VSTACK
				.frame(maxHeight: 200)
				.frame(maxWidth: .infinity)
				.ignoresSafeArea()
				.background(Color.green)
				
				
				Text("Welcome, please enter your name and the Library Code for your training.")
					.padding(.top,40)
					.padding()
					.font(.title2)
				
				GroupBox(
					label:
						ControlPanelLabelView(labelText: "Login", labelImage: "person.circle")
				) {
					
					
					Group {
						ControlPanelTextFieldView(buttonPressed: { self.loginButtonPressed() }, name: "Library Code", value: $libraryCode)
							.alert("An error occurred gettting phrases for \(libraryCode)", isPresented: $showingFBCodeErrorAlert) {
								Button("OK", action: {})
							} message: {
								Text("Make sure code is valid and try again")
							}
						ControlPanelTextFieldView(buttonPressed: { self.loginButtonPressed() }, name: "Spoken Name", value: $dataManager.spokenName)
							.alert("Spoken Name Missing", isPresented: $showingSpokenNameErrorAlert) {
								Button("OK", action: {})
							} message: {
								Text("Some message about invalid Spoken Name")
							}
						ControlPanelRowView(name: currentLoginState, content: currentLoginStateValue)
						
	#if DONT_COMPILE //disabled for demo - leaving room for more hard coded addresses
						ControlPanelButtonView(buttonPressed: { self.loginTelephoneButtonPressed() }, name: "+1 650 555 1111", value: "Login")
							.alert("Enter Code", isPresented: $showingVerificationCodeAlert) {
								TextField("", text: $verificationCode)
								Button("OK", action: phoneNumberVerificationCodeButtonPressed)
							} message: {
								Text("Enter the 6 digit code.")
							}
	#endif
					}//: GROUP
					
					Group {
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("john@goodstadt.com") }, name: "john@goodstadt.com", value: "Login")
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("alex@chruszcz.com") }, name: "alex@chruszcz.com", value: "Login")
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("testing@apple.com") }, name: "testing@apple.com", value: "Login")
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("daniele@iezzi.com") }, name: "daniele@iezzi.com", value: "Login")
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("alex@barlows.com") }, name: "alex@barlows.com", value: "Login")
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("alex@star-cafe.com") }, name: "alex@star-cafe.com", value: "Login")
						ControlPanelButtonView(buttonPressed: { self.loginEmailButtonPressed("alex@socialfutures.com") }, name: "alex@socialfutures.com", value: "Login")
						
						ControlPanelButtonView(buttonPressed: { self.logoutButtonPressed() }, name: "Logout", value: "Logout")
						
	#if DONT_COMPILE //disabled for demo - leaving room for more hard coded addresses
						ControlPanelButtonView(buttonPressed: { self.loginNoPasswordButtonPressed() }, name: "No password email", value: "Login")
							.toast(isPresenting: $showingLoginNoPasswordAlert){
								AlertToast(displayMode: .banner(.pop), type: .regular, title: "Sorry, not yet implemented")
							}
							.alert("Enter Email", isPresented: $showingLoginNoPasswordAlert) {
								TextField("", text: $passwordLessEmail)
								Button("OK", action: loginNoPasswordAction)
							} message: {
								Text("Enter a valid email  to receive a link.")
							}
	#endif
					}
					

				}//: GROUP BOX
				.padding()
				
				
#if DONT_COMPILE
				ControlPanelTextFieldView(countdownCompleteAction: { self.loginButtonPressed() }, name: "Username", lessonProgressValue: $username)
				//				.padding()
				
				ControlPanelTextFieldView(countdownCompleteAction: { self.loginButtonPressed() }, name: "Library Code", lessonProgressValue: $libraryCode)
				//				.padding()
				
				
				Text("Welcome to Customer Service Training")
					.padding(.top,15)
					.padding()
				
				Button( action: {
					
					
					
					isOnboarding = false
					
					
					dismiss()
				}){
					Text("START")
						.font(.title)
						.fontWeight(.bold)
						.padding(10)
						.padding([.leading,.trailing],5)
						.foregroundColor(colorManager.current.baseForeground)
					
				}
				
				.background(colorManager.current.buttonBlue) // If you have this
				.cornerRadius(16)
				.padding(.top,10)
				
#endif
				Spacer()
			} //: VSTACK
			.toast(isPresenting: $showingLoginErrorToast){
				AlertToast(type: .regular, title: showingLoginErrorToastMessage)
			}
			.onAppear{
				assignLoginState()
				
				var outputPorts: [AVAudioSession.Port] { AVAudioSession.sharedInstance().currentRoute.outputs.map { $0.portType } }
				
				let areHeadphonesConnected: Bool = outputPorts.contains(.headphones)
				print("areHeadphonesConnected:\(areHeadphonesConnected)")
			}
			
		}//: SCROLLVIEW
		
	} //: BODY
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
				}else{
					print("previous user does not exist")
				}
			}

			
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
			currentLoginState = "Error"
			currentLoginStateValue = String(signOutError.localizedDescription.prefix(4))
		}
	}
	func loginNoPasswordButtonPressed(){
		self.showingLoginNoPasswordAlert = true
	}
	func loginEmailButtonPressed(_ email:String) {
		
		guard viewModel.isSpokenNameValid(dataManager.spokenName) else {
			showingSpokenNameErrorAlert.toggle()
			return
		}
		
		if viewModel.isLibraryCodeValid(libraryCode){
			Task {
				await loginEmailAction(libraryCode, email, spokenName: dataManager.spokenName)
				
			}
		}else{
			showingFBCodeErrorAlert.toggle()
		}
	}
//	func loginUpdateStatisticsAction(_ code:String,_ email:String) async {
//
//	}
	func loginEmailAction(_ code:String,_ email:String, spokenName:String) async {
		
		guard viewModel.isLibraryCodeValid(code) else { return }
		guard viewModel.isSpokenNameValid(spokenName) else { return }
		
		
		let exists = await doesCodeExist(code: code)
		if exists {
			print("code EXISTS")
			
			//let email = "john.goodstadt@alex.com" //l4o4FJgOOEXRmxT9g1iaQwcs7eT2
			let password = "password"
			
			Auth.auth().signIn(withEmail: email, password: password) { result, err in
				if let err = err {
					print("Failed due to error:", err)
					currentLoginStateValue = String(err.localizedDescription.prefix(32))
					currentLoginState = "Email Error"
					
					showingLoginErrorToastMessage = err.localizedDescription
					showingLoginErrorToast.toggle()
					
					return
				}
				
				print("Successfully logged in with ID: \(result?.user.uid ?? "")")

				
				assignLoginState()
				
				Task {
					let exists = await doesUserExist( code: dataManager.libraryCode.code)
					if exists {
						print("user EXISTS")
						updateUserLoginStats(code: code, spokenName: spokenName.capitalizingFirstLetter())
//						dataManager.updateLessonStatistics(code)
//						updateLessonStatistics(code, email)
						
					}else{
						print("Newly Logged in user \(result?.user.uid.prefix(8) ?? "")")
						fsUpdateUserDoc(code: dataManager.libraryCode.code, spokenName: spokenName.capitalizingFirstLetter())
					}
					
//
					//TODO: CODE??
					await dataManager.downloadEverthingAsync()
					//await dataManager.downloadStaticLessonDataAsync(code: dataManager.libraryCode.code)
					
					if exists { //now we have downloaded lessons update the stats area
						dataManager.updateLessonState(code)
					}
					
					print("====> DISMISSING <=====")
					dismiss()//NOTE: The only success exit
				}
				

				
			}//: signIn
		} else{ //exists
			showingFBCodeErrorAlert = true
		}
		
		
	}
//	func updateLessonStatistics(_ code:String,_ email:String) {
//		
//		
////		dataManager.
//	}
	func loginNoPasswordAction(){
		
	}
	func spokenNameButtonPressed() {
		print("I am the spokenNameButtonPressed")
		
	}
	func loginButtonPressed() {
		print("I am the loginButtonPressed")
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
				let exists = await doesUserExist( code: defaultLibraryCode)
				if exists {
					print("user EXISTS")
					updateUserLoginStats(code: defaultLibraryCode, spokenName: dataManager.spokenName)
				}else{
					fsUpdateUserDoc(code: defaultLibraryCode, spokenName: dataManager.spokenName)
				}
			}
			
		}
	}
	func assignLoginState(){
		if let currentUser = Auth.auth().currentUser {
			
			let isAnonymous = currentUser.isAnonymous
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
						currentLoginState = "Login State"
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

}

struct LoginView_Previews: PreviewProvider {
	
	
	@State static var username = defaultUsername
	@State static var libraryCode = defaultLibraryCode
	
	static func loginButtonPressed() {
		print("I am the login Button Pressed")
	}
	
	static var previews: some View {
		if #available(iOS 15.0, *) {
			LoginView()
		} else {
			// Fallback on earlier versions
		}
	}
}
