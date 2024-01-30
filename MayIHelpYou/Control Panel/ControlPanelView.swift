//
//  ControlPanelView.swift
//  May I Help You?
//
//  Created by John goodstadt on 19/03/2023.
//

import SwiftUI
import AlertToast
import Firebase

@available(iOS 15, *)
struct ControlPanelView: View {
	@AppStorage(fb.libraryCode) var appStoreLibraryCode: String = ""
	@AppStorage(fb.spokenName) var appStoreSpokenName: String = ""
	
	@Environment(\.presentationMode) var presentationMode
	@EnvironmentObject private var dataManager:DataManager
	
	@StateObject private var viewModel = ViewModel()
	@StateObject var loginViewModel:LoginViewModel = LoginViewModel(avatar:  Avatar(name: "unknown",avatarArea: AvatarArea.practice, subTitle: "", imgString: "img1"))
	
	@State private var libraryCode = ""//default LibraryCode
	@State private var lessonRemindersOn = true
	@State private var lessonReminderTimeForDisplay:String = "9am"
	@State private var lessonReminderTimeDate:Date = Date(timeIntervalSince1970: 0)
	@State private var showingLibraryCodeAlert = false
	@State private var showingReminderTimeAlert = false
	@State private var showingResetLessonsToast = false
	@State private var showingSaveDataOnDeviceToast = false
	@State private var showingLoginAlert = false
	@State private var showingCodeErrorAlert = false
	@State private var showingFBCodeErrorAlert = false
	@State private var currentLoginState = ""
	@State private var currentLoginStateValue = ""
	@State private var showingLoginFullScreenSheet = false
	@State private var showingChatLoginFullScreenSheet = false
	@State private var showingFutureView = false
	@State private var showingNotYetImplemented = false
	@State private var snapshotMessage:String = "Save data On Device"
	
	
	init(){
		libraryCode = appStoreLibraryCode
	}

	
	//DEBUG
	let timerDEBUG = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
	//	let exampleDate = Date.now.addingTimeInterval(67)
	let exampleDate = Date.now.addingTimeInterval(1440)
	
	
	var body: some View {
		//Text("May I Help You - Control Panel")
		NavigationView {
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(spacing: 20) {
					// MARK: - SECTION 1
					
					GroupBox(
						label:
							ControlPanelLabelView(labelText: "May I Help You?", labelImage: "info.circle")
					) {
						Divider().padding(.vertical, 4)
						
						HStack(alignment: .center, spacing: 10) {
							
							Image(data:dataManager.libraryCode.logo)?
								.resizable()
								.aspectRatio(contentMode: .fit)
								.imageScale(.large)
								.foregroundColor(.accentColor)
								.padding(0)
								.scaledToFit()
								.frame(width: 164, height: 164)
								.cornerRadius(9)
							Text("Coaching staff on how to speak to customers.")
								.font(.footnote)
						}
					}
					
					GroupBox(
						label:
							ControlPanelLabelView(labelText: "Lesson Settings", labelImage: "book.circle")
					) {
						
						//						ControlPanelRowView(name: "Library Code", content: "BW 14")
						ControlPanelButtonView(buttonPressed: { self.LibraryCodeButtonPressed() }, name: "Library Code", value: dataManager.libraryCode.code)
							.alert("Enter New Code", isPresented: $showingLibraryCodeAlert) {
								TextField(libraryCode, text: $libraryCode)
									.textCase(.uppercase)
								Button("OK", action: submitLibraryCode)
							} message: {
								Text("Enter the code you have been given to access a set of lessons.")
							}
							.alert("An error occurred in code \(libraryCode)", isPresented: $showingCodeErrorAlert) {
								Button("OK", action: {})
							} message: {
								Text("Make sure it is valid and try again")
							}
							.alert("An error occurred gettting phrases for \(libraryCode)", isPresented: $showingFBCodeErrorAlert) {
								Button("OK", action: {})
							} message: {
								Text("Make sure code is valid and try again")
							}
						
						//						ControlPanelProgressView(labelText: "Progress", labelImage: "star", completions: [true,true,false,false,false])
						ControlPanelProgressView(labelText: "Progress", labelImage: "star", completions: dataManager.calcCompletions())
						ControlPanelRowView(name: "Required lesson repeat​", content: dataManager.viewableLessonsPerPhrase)
						ControlPanelRowView(name: "Minimum time between lessons​", content: dataManager.viewableTimeBetweenLessons)
						
					}
					GroupBox(
						label:
							ControlPanelLabelView(labelText: "User Settings", labelImage: "person.circle")
							.onTapGesture {
								dataManager.removeCachedMP3sWithSpokenName()
							}
						
					) {
						
						//						ControlPanelButtonView(buttonPressed: { self.loginButtonPressed() }, name: "Username",value: "John Goodstadt")
						ControlPanelRowView(name: currentLoginState, content: currentLoginStateValue)
						
						ControlPanelButtonView(buttonPressed: { self.logoutChatButtonPressed() }, name: "Login chat", value: "Login")
							.fullScreenCover(isPresented: $showingChatLoginFullScreenSheet) {
								LoginChatView(chat: loginViewModel.chat).environmentObject(loginViewModel)
							}
						
						
						
						
						ControlPanelButtonView(buttonPressed: { self.logoutButtonPressed() }, name: "Logout (test login)", value: "Logout")
							.sheet(isPresented: $showingLoginFullScreenSheet, onDismiss: {
								print("sheet onDismiss()")
							}, content: LoginView.init)
							.environmentObject(dataManager)
						

						
						
						
						
						ControlPanelRowView(name: "Spoken Name", content: dataManager.spokenName)
						ControlPanelSwitchView(name: "Lesson reminders", switchControl: $lessonRemindersOn)
						
						/*
						 MALE | FEMALE segmented control
						 */
						ControlPanelButtonView(buttonPressed: { self.reminderButtonPressed() }, name: "Lesson reminder timing",value: lessonReminderTimeForDisplay)
							.sheet(isPresented: $showingReminderTimeAlert) {
								//								TimePickerView(dateChosen: dateChosenAction() { date in }).viPresentationDetents([.medium,.fraction(0.50)])
								TimePickerView( reminderDate: $lessonReminderTimeDate, dateChosen:  { selectedDate in self.dateSelectedAction(dateSelected: selectedDate)} ).viPresentationDetents([.medium,.fraction(0.50)])
							}
							.fullScreenCover(isPresented: $showingLoginAlert, content: LoginView.init)
							.onReceive(timerDEBUG) { input in
								
								let formatter = RelativeDateTimeFormatter()
								formatter.unitsStyle = .full
								
								// get exampleDate relative to the current date
								let relativeDate = formatter.localizedString(for: exampleDate, relativeTo: Date.now)
								
								let a = exampleDate.relativeDateAsString()
								// print it out
								print("\(relativeDate),\(a)")
							}
					}
					
					
				}//: VSTACK
				.onAppear{
					assignLoginState()
					
					lessonReminderTimeDate = dataManager.libraryCode.lessonReminderTime
					lessonReminderTimeForDisplay = formatTime(dataManager.libraryCode.lessonReminderTime)
					
					if lessonReminderTimeDate == Date(timeIntervalSince1970: 0) {
						lessonReminderTimeForDisplay = "9am"
						lessonReminderTimeDate = tomorrowMorning(hour: 9) ?? Date()
					}
					
					lessonRemindersOn = dataManager.libraryCode.lessonReminderOn
					
					
					
					let libraryCode = dataManager.libraryCode.code
					let url = URL(fileURLWithPath: getDocumentsDirectoryString()).appendingPathComponent("\(libraryCode)_snapshotData.json")
					
					if exists(url) {
						if let data = try? Data(contentsOf: url) {
							//TODO: could just look at final timestamp?
							if let snapshotData = try? JSONDecoder().decode(QuiickLookSnapshotData.self, from: data) {
								print("\(snapshotData.lessonCode)  \(snapshotData.lastSavedDate)")
								snapshotMessage = "saved \(snapshotData.lessonCode) on \( (snapshotData.lastSavedDate.formatted()) )"
							}else{
								print("Error Decoding snapshot data ")
								print(getDocumentsDirectoryString())
							}
						}
						
					}else{
						snapshotMessage = "No saved data for \(libraryCode)"
					}
					
					
					print(getDocumentsDirectory())//for snapshot debug
					
					
					
				}
				.onChange(of: lessonRemindersOn) { newValue in
					fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.lessonReminderOn, value: newValue)
					
					if lessonRemindersOn && dataManager.areSomeLessonsStarted {
						let date = dataManager.libraryCode.lessonReminderTime
						let hour =  Calendar.current.component(.hour, from: date)
						let minute =  Calendar.current.component(.minute, from: date)
						
						setDailyNotification(hour: hour,minute: minute)
					}else{
						removePendingNotificationRequests(UIDs: [lessonNotificationUID])
					}
				}
				.onDisappear {
					print("Control Panel Dismissed")
				}
				.navigationBarTitle(Text("Settings"), displayMode: .automatic)

			}//: SCROLL
		} //: NAV
	}
	
	func dateSelectedAction(dateSelected:Date){
		
		
		lessonReminderTimeForDisplay = formatTime(dateSelected)
		
		fbUpdateUserDateProperty(dataManager.libraryCode.code,property: fb.lessonReminderTime,value: dateSelected)
		
	}
	func formatTime(_ date:Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "h:mm a"
		
		let dateString = formatter.string(from: date)
		print(dateString)   // "4:44 PM "
		
		return dateString
	}

	
	func CompleteLesson1ButtonPressed(){
		
		dataManager.completeLesson()
		
	}
	func ResetStateButtonPressed(){
		ResetLessonsButtonPressed()
		ResetChatButtonPressed()
		removeAllFilesBySuffix("mp3")
	}
	func ResetChatButtonPressed() {
		
		dataManager.resetChats()
		
		fbResetAllUserChatState(code: dataManager.libraryCode.code, dataManager.chatQuestions)
		
		//fbResetChatAttempts(code: dataManager.libraryCode.code, dataManager.chatQuestions)
	}
	func ResetLessonsButtonPressed() {
		dataManager.resetLessons()
		removePendingNotificationRequests(UIDs: [lessonNotificationUID])
		fbResetAllUserLessonStats(code: dataManager.libraryCode.code, dataManager.lessons)
		
		//		showingResetLessonsToast.toggle()
#if DONT_COMPILE //now on TAB no dismiss
		presentationMode.wrappedValue.dismiss()
#endif
		
	}
	func futureButtonPressed() {
		showingFutureView.toggle()
	}
	func LibraryCodeButtonPressed() {
		showingLibraryCodeAlert.toggle()
	}
	func reminderButtonPressed() {
		
		showingReminderTimeAlert.toggle()
	}
	func loginButtonPressed() {
		showingLoginAlert.toggle()
	}
	func submitLibraryCode() {
		
		libraryCode = libraryCode.uppercased()
		
		if viewModel.isLibraryCodeValid(libraryCode){
			Task {
				await submitLibraryCodeAsync(libraryCode)
			}
		}else{
			showingCodeErrorAlert.toggle()
		}
	}
	func submitLibraryCodeAsync(_ code:String) async {
		
		guard viewModel.isLibraryCodeValid(libraryCode) else {
			return
		}
		
		//TODO: this is too early. if downloadEverthingAsync fails still gets set
		appStoreLibraryCode = libraryCode //save in user defaults
		appStoreSpokenName = dataManager.spokenName //this is kept per code not per user so make sure it carries over to new code
		
		Task {
			await dataManager.downloadEverthingAsync(libraryCode: libraryCode)
			
			if dataManager.spokenName.isEmpty && appStoreSpokenName.isNotEmpty {
				//TODO: would need to redo onAppear{} in TabContent
				printhires("found missing sn bug")
				print( "ControlPanelView.dataManager.spokenName():\(dataManager.spokenName)")
				dataManager.spokenName = appStoreSpokenName
			}
		}
		
		
	}
	func submitLoginCode() {
		print("You entered \(self.appStoreLibraryCode)")
		
	}
	
	func logoutChatButtonPressed() {
		showingChatLoginFullScreenSheet = true
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
			
			showingLoginFullScreenSheet = true
			
			
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
			currentLoginState = "Error"
			currentLoginStateValue = String(signOutError.localizedDescription.prefix(4))
		}
	}
	func assignLoginState(){
		if let currentUser = Auth.auth().currentUser {
			
			let isAnonymous = currentUser.isAnonymous
			let providerData = currentUser.providerData
			
			if providerData.count > 0 {
				let pro = providerData[0]
				if providerData.count >= 2 {
					//seem [0] is latest [1] is oldest?
					//pro = providerData[1] //Linked User??
				}
				let providerID = pro.providerID
				
				switch providerID {
					case "phone":
						currentLoginStateValue = "Phone"
						currentLoginState = "Logged in:"
					case "password":
						
						if let email = currentUser.email {
							currentLoginStateValue = email
						}else{
							currentLoginStateValue = "Email/Password"
						}
						currentLoginState = "Logged in:"
					case "apple.com":
						if let email = currentUser.email {
							if email != pro.email {
								currentLoginStateValue =  pro.email ?? email
							}else{
								currentLoginStateValue = email
							}
							
						}else{
							currentLoginStateValue = "apple.com"
						}
						//						currentLoginStateValue = "Apple"
						currentLoginState = "Logged in:"
					case "google.com":
						if let email = currentUser.email {
							if email != pro.email {
								currentLoginStateValue =  pro.email ?? email
							}else{
								currentLoginStateValue = email
							}
							
						}else{
							currentLoginStateValue = "google.com"
						}
						//						currentLoginStateValue = "Apple"
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
}




struct ControlPanelView_Previews: PreviewProvider {
	
	@State static var dataManager = DataManager(true)
	
	static var previews: some View {
		//		ControlPanelView(loginViewModel: LoginViewModel(avatar: dataManager.avatars[0]))
		ControlPanelView()
			.environmentObject(DataManager(true))
	}
}
