//
//
//  ChatView.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  


import SwiftUI
import AlertToast
import Firebase
import FirebaseAuth
import GoogleSignInSwift
import GoogleSignIn

struct LoginChatView: View {
	
	@AppStorage(fb.libraryCode) var appStoreLibraryCode: String = ""
	
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject private var colorManager:ColorManager
	@EnvironmentObject var viewModel: LoginViewModel
	@EnvironmentObject var dataManager:DataManager
	
	@FocusState private var isFocused
	
	@State private var text = ""
	@State private var messageIDToScroll: UUID?
	@State private var showMessageToast = false
	@State private var toastMessage = ""
	@State private var showingLoginFullScreenSheet = false
//	@State private var coordinator: SignInWithAppleCoordinator?

	let chat: LoginChat
	let spacing: CGFloat = 10
	let minSpacing: CGFloat = 3
	let audioManager = AudioManager()
	
	
	
	var body: some View {
		VStack(spacing: 0) {
			GeometryReader { reader in
				getChatsView(viewWidth: reader.size.width)
					.onTapGesture {
						isFocused = false
					}
			}
			.padding(.bottom, 5)
			
			toolbarView()
		}//: VSTACK
		.padding(.top, 1)
//		.navigationBarItems(leading: navBarLeadingBtn(), trailing: navBarTrailingBtn())
		.navigationBarItems(leading: navBarLeadingBtn())
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			printhires(".OnAppear")
			viewModel.markAsUnread(false, chat: chat)
			
			//
			
			
		}.task {
			printhires(".TASK")
			//TODO: could init here? as opposed to parent?
			viewModel.currentLibraryCode = dataManager.libraryCode.code
			//let avatar = viewModel.avatar
			if dataManager.spokenName.isEmpty {
				print("firebase call for spoken name")
				let spokenName = await readUserProperty(dataManager.libraryCode.code, property: fb.spokenName)
				viewModel.currentSpokenName = spokenName
			}else{
				viewModel.currentSpokenName = dataManager.spokenName
			}
			
			//TODO: Note: Login should start with user logged out.
			//For testing user might already be logged in.
			if let _ = Auth.auth().currentUser {
				viewModel.stateMachine = LogInStateMachine()
				viewModel.stateMachine.transition(to: .loggedIn)
				viewModel.resetToStart()
//				viewModel.sendMessages(.loggedin)
			}else{
				
				viewModel.stateMachine = LogInStateMachine()
				viewModel.resetToStart()
			}
		}
	}
		
	
	struct MessageView: View {
		//@EnvironmentObject private var dataManager:DataManager
		@EnvironmentObject private var colorManager:ColorManager
		
		var message:LoginMessage
		var buttonPressed: (_ message: LoginMessage) -> Void
		
		var body : some View {
			
			Group{
				let _ = message.type == .Received
				let _ = message.rowType
				
				let isSuccess = message.rowType == .changeSpokenNameSuccess ||  message.rowType == .checkedLibraryCode ? true : false
				
				
				if message.isButton == .normal {
					Button(action: {
						buttonPressed(message)
					}) {
						Text(message.text)
							.foregroundColor(.white)
							.padding(.horizontal)
							.padding(.vertical, 12)
					}
				}
				else
				{
					Text(message.text)
						.padding(.horizontal)
						.padding(.vertical, 12)
						.background(isSuccess ?  Color.green.opacity(0.9) : Color.black.opacity(0.2))
						.cornerRadius(13)
				}
			}//: GROUP
			
			.if (message.isButton == .normal) { view in
				view.background( colorManager.current.buttonBlue)
			}
			.if (message.isButton == .none) { view in
				view.background( Color(UIColor.systemBackground))
			}
			.cornerRadius(13)
		}

	} //:MessageView

	func buttonPressed(_ message: LoginMessage) {
		print(chat.description)
		
		let currentUser = Auth.auth().currentUser
		
		printhires("\(viewModel.stateMachine)")
		
		switch message.rowType {
				
			case .text:
				print("\(message.rowType)")
			case .login:
				print("\(message.rowType)")
				self.toastMessage = "Show Login page"
				showMessageToast.toggle()
			case .logout:
				print("\(message.rowType)")
				toastMessage = "Show Logout page"

				
				
				
				viewModel.sendMessage("Are you sure you want to login again?")
				viewModel.sendMessage(.logoutconfirmed)
				
			case .logoutconfirmed:
				if viewModel.logoutButtonPressed() {
					showingLoginFullScreenSheet.toggle()
				}
			case .invalidLibraryCode:
				print("\(message.rowType)")
				toastMessage = "Show Change Lesson Code page"
				showMessageToast.toggle()
			case .changeLibraryCode:
				print("\(message.rowType)")
				
				viewModel.stateMachine.transition(to: .changeLibrayCode)
				viewModel.sendMessage("Type in the new library code")
				
				
				//iewModel.changeLibraryCodeButtonPressed()

				
			case .url:
				
				let urlString = ""
				
				if let url = URL(string:urlString) {
					UIApplication.shared.open(url)
				}
			case .unknown:
				print("\(message.rowType)")
			case .continuelesson:
				print("\(message.rowType)")
				toastMessage = "Navigate to lesson 3"
				showMessageToast.toggle()
			case .authmessage:
				toastMessage = "Send message to authoriser"
				showMessageToast.toggle()
			case .loginJG:
				
				
				let email = "john@goodstadt.com"
				
				
				#if DONT_COMPILE // for testing
				if email == currentUser?.email {
					toastMessage = "You are already logged in to \(email)"
					showMessageToast.toggle()
					return
				}
				#endif

				
				Task {
					let password = "password"
					let success = await viewModel.signInWithDemoAccount(email,password)
					if success {
						viewModel.stateMachine.transition(to: .loggedIn)
						viewModel.sendMessage(.loginSuccess)
						if let user = Auth.auth().currentUser {
							print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
						}
						
						viewModel.sendMessage(.introLibraryCode)
						let resultJA65 = await checkAuthorization(code: "JA65",authtoken: email)
						let resultDA65 = await checkAuthorization(code: "DA65",authtoken: email)
						let resultSC01 = await checkAuthorization(code: "SC01",authtoken: email)
						
						if resultJA65.OK {
							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeJA65){
								messageIDToScroll = lastMessage.id
							}
							
						}
						
						if resultDA65.OK {
							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeDA65){
								messageIDToScroll = lastMessage.id
							}
						}
						
						if resultSC01.OK {
							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeSC01){
								messageIDToScroll = lastMessage.id
							}
						}
							
						if !resultJA65.OK && !resultDA65.OK  && !resultSC01.OK {
							//TODO: could be more specific here
							if let lastMessage = viewModel.sendMessages(.libraryCodesErrorNotFound){
								messageIDToScroll = lastMessage.id
							}
						}
						
						
					}
					else{
						viewModel.stateMachine.transition(to: .logInError)
						if let lastMessage = viewModel.sendMessage(.loginErrorNotInFirebase){
							messageIDToScroll = lastMessage.id
						}
					}
				}
			case .loginIndaPoint:
				Task {
					let password = demoPassword
					let email = "indapoint@gmail.com"
					
					if email == currentUser?.email {
						toastMessage = "You are already logged in to \(email)"
						showMessageToast.toggle()
						return
					}
					
					let success = await viewModel.signInWithDemoAccount(email,password)
					if success {
						viewModel.stateMachine.transition(to: .loggedIn)
						viewModel.sendMessage(.loginSuccess)
						if let user = Auth.auth().currentUser {
							print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
						}
						viewModel.sendMessage(.introLibraryCode)
						
						doLibraryCodeProcessing(authtoken:email)
						
						
					}else{
						viewModel.stateMachine.transition(to: .logInError)
						if let lastMessage = viewModel.sendMessage(.loginError){
							messageIDToScroll = lastMessage.id
						}
					} //:SUCCESS
				}//:TASK

			case .loginTesting:
				Task {
					let password = "password"
					let email = "testing@apple.com"
					
					if email == currentUser?.email {
						toastMessage = "You are already logged in to \(email)"
						showMessageToast.toggle()
						return
					}
					
					let success = await viewModel.signInWithDemoAccount(email,password)
					if success {
						viewModel.stateMachine.transition(to: .loggedIn)
						viewModel.sendMessage(.loginSuccess)
						if let user = Auth.auth().currentUser {
							print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
						}
						viewModel.sendMessage(.introLibraryCode)
						let resultJA65 = await checkAuthorization(code: "JA65",authtoken: email)
						let resultDA65 = await checkAuthorization(code: "DA65",authtoken: email)
						let resultSC01 = await checkAuthorization(code: "SC01",authtoken: email)
						
						if resultJA65.OK {
							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeJA65){
								messageIDToScroll = lastMessage.id
							}
							
						}else if resultDA65.OK {
							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeDA65){
								messageIDToScroll = lastMessage.id
							}
						}else if resultSC01.OK {
							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeSC01){
								messageIDToScroll = lastMessage.id
							}
						}else{
							//TODO: could be more specific here
							if let lastMessage = viewModel.sendMessages(.libraryCodesErrorNotFound){
								messageIDToScroll = lastMessage.id
							}
						}
					}else{
						viewModel.stateMachine.transition(to: .logInError)
						if let lastMessage = viewModel.sendMessage(.loginError){
							messageIDToScroll = lastMessage.id
						}
					}
				}

			case .cancelLogin:
				
				dismiss()
				
			case .messageToAdmin:
				fsSendEmail(code: dataManager.libraryCode.code, company: dataManager.company, spokenname: dataManager.spokenName )
				if let lastMessage = viewModel.sendMessage("Message Sent OK") {
					messageIDToScroll = lastMessage.id
				}
			case .displayLibraryCodeJA65:
				//TODO: DOwnloadEverything here

				//next Step
				viewModel.sendMessage(.introSpokenName)
				if let lastMessage = viewModel.sendMessage(.enterSpokenName){
					messageIDToScroll = lastMessage.id
					
				}
				viewModel.stateMachine.transition(to: .changeSpokenName)
				
				Task {
					await dataManager.downloadEverthingAsync(libraryCode: "JA65")
					appStoreLibraryCode = "JA65"
				}
				
			case .displayLibraryCodeDA65:
//				toastMessage = "Library Code DA65 processing still to do"
//				showMessageToast.toggle()
				viewModel.sendMessage(.introSpokenName)
				if let lastMessage = viewModel.sendMessage(.enterSpokenName){ messageIDToScroll = lastMessage.id }
				viewModel.stateMachine.transition(to: .changeSpokenName)
				
				Task {
					await dataManager.downloadEverthingAsync(libraryCode: "DA65")
					appStoreLibraryCode = "DA65"
				}
			case .displayLibraryCodeSC01:
				viewModel.sendMessage(.introSpokenName)
				if let lastMessage = viewModel.sendMessage(.enterSpokenName){ messageIDToScroll = lastMessage.id }
				viewModel.stateMachine.transition(to: .changeSpokenName)
				
				Task {
					await dataManager.downloadEverthingAsync(libraryCode: "SC01")
					appStoreLibraryCode = "SC01"
				}
			case .changeSpokenName:
				print("\(message.rowType)")
				
//				viewModel.stateMachine.transition(to: .changeSpokenName)
				viewModel.sendMessage("Type in the new spoken name")
				
				//viewModel.changeSpokenNameButtonPressed()
			case .changeSpokenNameSuccess:
				toastMessage = "Change Spoken Name successful"
				showMessageToast.toggle()
			case .changeSpokenNameError:
				toastMessage = "Change Spoken Name Error"
				showMessageToast.toggle()
			case .spokenNameConfirmNo:
				viewModel.stateMachine.transition(to: .changeSpokenName)
//
				if let lastMessage = viewModel.sendMessage("Type in the new spoken name"){ messageIDToScroll = lastMessage.id }
				
			case .spokenNameConfirmYes:
				viewModel.stateMachine.transition(to: .changeVoice)
				
				if let lastMessage = viewModel.sendMessages(.chooseVoice) {
					messageIDToScroll = lastMessage.id
				}
			case .chooseVoiceMale:
				let sentence = "Hello \(dataManager.spokenName ), Welcome to May I Help You."
				
				GoogleSpeechManager.shared.speak(text: sentence, voiceName: GOOGLE_MALE_VOICE) {  result in
					switch result {
						case .failure(let error):print("error \(error)")
							printhires(error.localizedDescription)
						case .success(let mp3):
							self.audioManager.playAudio(mp3, UID: UUID().uuidString)
							dataManager.voiceName = GOOGLE_MALE_VOICE
							fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.voiceMale, value: true)
					}
				}
				toastMessage = "Male voice chosen"
				showMessageToast.toggle()
				
				if viewModel.stateMachine.getCurrentState != .logInComplete {
					viewModel.stateMachine.transition(to: .logInComplete)
					
					if let lastMessage = viewModel.sendMessage(.logInComplete) {
						messageIDToScroll = lastMessage.id
					}
				}
				
				
			case .chooseVoiceFemale:
				let sentence = "Hello \(dataManager.spokenName), Welcome to May I Help You."
				
				GoogleSpeechManager.shared.speak(text: sentence, voiceName: GOOGLE_FEMALE_VOICE) {  result in
					switch result {
						case .failure(let error):print("error \(error)")
							printhires(error.localizedDescription)
						case .success(let mp3):
							self.audioManager.playAudio(mp3, UID: UUID().uuidString)
							dataManager.voiceName = GOOGLE_FEMALE_VOICE
							fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.voiceMale, value: false)
							
					}
				}
				toastMessage = "Female voice chosen"
				showMessageToast.toggle()

				if viewModel.stateMachine.getCurrentState != .logInComplete {
					viewModel.stateMachine.transition(to: .logInComplete)
					
					if let lastMessage = viewModel.sendMessage(.logInComplete) {
						messageIDToScroll = lastMessage.id
					}
				}
			case .checkedLibraryCode:
				
				Task {
					let libraryCode = message.tag
					
					await dataManager.downloadEverthingAsync(libraryCode: libraryCode)
					appStoreLibraryCode = libraryCode
					
					viewModel.sendMessage(.changedLibraryCodeSuccess)
					
					
					viewModel.sendMessage(.introSpokenName)
					if let lastMessage = viewModel.sendMessage(.enterSpokenName) {
						messageIDToScroll = lastMessage.id
					}
					viewModel.stateMachine.transition(to: .changeSpokenName)
	
				}
			case .logInComplete:
				dismiss()
			default:
				print("TODO: Missing RowType:\( message.rowType )")
		}
	}
	func textEntered(_ text:String) {
		
		
		printhires("\(viewModel.stateMachine)")
		
		
		switch viewModel.stateMachine.getCurrentState {
				
#if DONT_COMPILE //Library code now as button choice
			case .changeLibrayCode,.changingLibrayCode:
				let code = text.uppercased()
				guard viewModel.isLibraryCodeValid(code) else {
					if let lastMessage = viewModel.sendMessage(.invalidLibraryCode) {
						messageIDToScroll = lastMessage.id
					}
					return
				}
	
				guard code != self.viewModel.currentLibraryCode else {
					if let lastMessage = viewModel.sendMessage(.sameLibraryCode) {
						messageIDToScroll = lastMessage.id
					}
					return
				}
				
				viewModel.stateMachine.transition(to: .changingLibrayCode)
				Task {
					let exists = await doesCodeExist(code: code)
					if exists {
						print("Code '\(code)' DOES exist in the cloud")
						viewModel.stateMachine.transition(to: .changedLibrayCodeSuccess)
						if let lastMessage = viewModel.sendMessage(.checkedLibraryCode) {
							messageIDToScroll = lastMessage.id
						}
						
						dataManager.updateLibraryCode(code)

						await dataManager.downloadEverthingAsync(libraryCode: code)
						
						//only sucess exit
//						viewModel.resetToStart(rowType: .checkedLibraryCode)
//						viewModel.stateMachine.transition(to: .loggedIn)
						
					}else{
						print("Code '\(code)' does not exist in the cloud")
						viewModel.stateMachine.transition(to: .changedLibrayCodeError)
						if let lastMessage = viewModel.sendMessage(.notFoundLibraryCode) {
							messageIDToScroll = lastMessage.id
						}
					}
				}
#endif
			case .changeSpokenName,.changeSpokenNameConfirm:
				let spokenName = text
				guard viewModel.isSpokenNameValid(spokenName) else {
					if let lastMessage = viewModel.sendMessage(.changeSpokenNameError) {
						messageIDToScroll = lastMessage.id
					}
					return
				}
				let sentence = "Hello \(spokenName), Welcome to May I Help You."
				
				GoogleSpeechManager.shared.speak(text: sentence, voiceName: GOOGLE_MALE_VOICE) {  result in
					switch result {
						case .failure(let error):print("error \(error)")
							printhires(error.localizedDescription)
						case .success(let mp3):
							self.audioManager.playAudio(mp3, UID:  UUID().uuidString)
					}
				}
				
				viewModel.stateMachine.transition(to: .changeSpokenNameSuccess)

				dataManager.spokenName = spokenName
				fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.spokenName, value: spokenName)
				
				viewModel.stateMachine.transition(to: .changeSpokenNameConfirm)
				
				viewModel.sendMessage(.spokenNameConfirmYes)
				if let lastMessage = viewModel.sendMessage(.spokenNameConfirmNo) {
					messageIDToScroll = lastMessage.id
				}
				
			case .notLoggedIn,.loggedIn:
				//login
				
				//May 31 2023. only 1 enter text - email address
				
				guard text.isValidEmail() else{
					toastMessage = "Invalid email entered. Try again."
					showMessageToast.toggle()
					if let lastMessage = viewModel.sendMessages(.emailformatInvalid){
						messageIDToScroll = lastMessage.id
					}
					
					
					return
				}
				
				
				let email = text
				
				Task {
					var password = demoPassword
					if adminUsers.contains(email) {
						password = adminPassword
					}
					
					let success = await viewModel.signInWithDemoAccount(email,password)
					if success {
						viewModel.stateMachine.transition(to: .loggedIn)
						viewModel.sendMessage(.loginSuccess)
						if let user = Auth.auth().currentUser {
							print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
						}
						viewModel.sendMessage(.introLibraryCode)
//						let resultJA65 = await checkAuthorization(code: "JA65",authtoken: email)
//						let resultDA65 = await checkAuthorization(code: "DA65",authtoken: email)
//						let resultSC01 = await checkAuthorization(code: "SC01",authtoken: email)
//
						doLibraryCodeProcessing(authtoken:email)


//						if resultJA65.OK {
//							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeJA65){
//								messageIDToScroll = lastMessage.id
//							}
//
//						}
//
//						if resultDA65.OK {
//							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeDA65){
//								messageIDToScroll = lastMessage.id
//							}
//						}
//
//						if resultSC01.OK {
//							if let lastMessage = viewModel.sendMessage(.displayLibraryCodeSC01){
//								messageIDToScroll = lastMessage.id
//							}
//						}
//
//
//
//						}else{
//							//TODO: could be more specific here
//							if let lastMessage = viewModel.sendMessages(.libraryCodesErrorNotFound){
//								messageIDToScroll = lastMessage.id
//							}
//						}
//
//					}else{
//						viewModel.stateMachine.transition(to: .logInError)
//						if let lastMessage = viewModel.sendMessage(.loginErrorNotInFirebase){
//							messageIDToScroll = lastMessage.id
//						}
					}else{
						printhires("Not Logged in OK")
						viewModel.sendMessage(.loginError)
						viewModel.sendMessages(.sendMessageToAdmin)
						
					}
				}
			default:
				printhires("textEntered not used state:\(viewModel.stateMachine.getCurrentState)")
		}
		
	}

	func getChatsView(viewWidth: CGFloat) -> some View {
		ScrollView {
			ScrollViewReader { scrollReader in
				LazyVGrid(columns: [GridItem(.flexible(minimum: 0))], spacing: 0, pinnedViews: [.sectionHeaders]) {
					//					let sectionMessages = viewModel.getSectionMessages(for: chat)
					//					ForEach(sectionMessages.indices, id: \.self) { i in
					//						let messages = sectionMessages[i]
					//						Section(header: sectionHeader(firstMessage: messages.first!)) {
					ForEach(chat.messages) { message in
						let isReceived = message.type == .Received
						
						HStack {
							ZStack {
								MessageView(message: message, buttonPressed: { message in
									self.buttonPressed(message)
									
								})
							}//: ZSTACK
							.frame(width: viewWidth * 0.7, alignment: isReceived ? .leading  : .trailing)
							.padding(.vertical, 5)
							
						}
						.frame(maxWidth: .infinity, alignment: isReceived ? .leading  : .trailing)
						.id(message.id)
					}//:LOOP MESSAGES
					//						}
					//					}
					.onChange(of: isFocused) { _ in
						if chat.messages.isNotEmpty {
							if isFocused {
								DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
									withAnimation(.easeIn(duration: 0.5)) {
										scrollReader.scrollTo(chat.messages.last!.id, anchor: .bottom)
									}
								}
							}
						}
					}
					.onChange(of: messageIDToScroll) { _ in
						// This scrolls down to the new sent Message
						if let messageID = messageIDToScroll {
							DispatchQueue.main.async {
								withAnimation(.easeIn) {
									scrollReader.scrollTo(messageID)
								}
							}
						}
					}
					.onAppear {
						if chat.messages.isNotEmpty {
							DispatchQueue.main.async {
								scrollReader.scrollTo(chat.messages.last!.id, anchor: .bottom)
							}
						}
					}
					
				} //:LAZYVGRID
				.padding(.horizontal)
//				.toast(isPresenting: $showMessageToast){
//					AlertToast(type: .regular, title: toastMessage)
//				}
			}
		} //scrollview
		.if (colorScheme == .dark) { view in
			view.background(Color(red: 0.1, green: 0.1, blue: 0.1))
		}
		.if (colorScheme == .light) { view in
			view.background(Color(UIColor.systemBackground))
		}
		.toast(isPresenting: $showMessageToast){
			AlertToast(type: .regular, title: toastMessage)
		}
		.fullScreenCover(isPresented: $showingLoginFullScreenSheet, onDismiss: {
			print("fullScreenCover onDismiss()")
			//updateDataManagerWithEvery thing() //TODO: Too Early?
			
		}, content: LoginView.init)
			.environmentObject(dataManager)
	}
	
	func toolbarView() -> some View {
		VStack {
			let height: CGFloat = 37
			HStack {
				TextField("Message...", text: $text)
					.textFieldStyle(.plain)   //dark mode
					.textCase(.lowercase)//does not appear to work
					.padding(.horizontal, 10)
					.frame(height: height)
//					.background(Color.white)
					.clipShape(RoundedRectangle(cornerRadius: 13))
					.focused($isFocused)
				
				Button(action: {
					if let newMessage = viewModel.userSendMessage(text.lowercased()) {
						textEntered(text.lowercased())
						text = ""
						messageIDToScroll = newMessage.id
					}
				}) {
					Image(systemName: "paperplane.fill")
						.foregroundColor(.white)
						.frame(width: height, height: height)
						.background(
							Circle()
								.foregroundColor(text.isEmpty ? .gray : .blue)
						)
				}
			}
			.frame(height: height)
		}
		.padding(.vertical, 10)
		.padding(.horizontal)
		.background(.thickMaterial)
	}
	
	func sectionHeader(firstMessage message: LoginMessage) -> some View {
		ZStack {
			//let color = Color(hue: 0.587, saturation: 0.742, brightness: 0.924)
			Text(message.date.descriptiveString(dateStyle: .medium))
				.foregroundColor(colorScheme == .dark ? colorManager.current.foregroundDarkGrey : .black)
				.font(.system(size: 14, weight: .regular))
				.frame(width: 120)
				.padding(.vertical, 4)
				.background(Capsule().foregroundColor(colorScheme == .dark ? Color.black : colorManager.current.backgroundLightGrey))
		}
		.padding(.vertical, 5)
		.frame(maxWidth: .infinity)
	}
	
	func navBarLeadingBtn() -> some View {
		Button(action: {}) {
			HStack {
				Image(chat.avatar.imgString)
					.resizable()
					.frame(width: 40, height: 40)
					.clipShape(Circle())
				
				Text(chat.avatar.name)
					.bold()
			}
			.foregroundColor(.black)
		}
	}
	
	func navBarTrailingBtn() -> some View {
		HStack {
			Button(action: {}) {
				Image(systemName: "video")
			}
			
			Button(action: {}) {
				Image(systemName: "phone")
			}
		}
	}
} //:LoginChatView

extension LoginChatView {
	func doLibraryCodeProcessing(authtoken:String) {
		
		//TODO: change to validCodesForUser()
		Task {
			//viewModel.sendMessage(.introLibraryCode)
			
			let codes = await validCodesForUser(authtoken: authtoken)
			print(" authorized codes \(codes)")
			
			
			if codes.count == 1 {
				print("1 code available to me \(codes)")
				
				if let libraryCode = codes.first {
					
					
					viewModel.sendMessage("Using Library Code \(libraryCode)")
					viewModel.sendMessage(.introSpokenName)
					
					
					
					if let lastMessage = viewModel.sendMessage(.enterSpokenName){
						print("scrolling to message \(lastMessage)")
						messageIDToScroll = lastMessage.id
						
					}
					
					
					viewModel.stateMachine.transition(to: .changeSpokenName)
					
					Task {
						await dataManager.downloadEverthingAsync(libraryCode: libraryCode)
						appStoreLibraryCode = libraryCode
					}
				}else{
					viewModel.sendMessage("Cannot find a library code available for you. Please contact an administrator to arrange access.", rowType: .authmessage)
				}
				

				return
				
				
			}else if codes.count > 1 {
				print(">1 code available to me \(codes)")
				//TODO:
				viewModel.sendMessage("Available codes:\(codes.joined(separator: ","))")
				codes.forEach {
					let code = $0
					//TODO: isButton should be buttonType?
					let message = LoginMessage("Use:\(code)",rowType: .checkedLibraryCode, isButton: .normal,tag: code)
					
					
					if $0 == codes.last {
						if let lastMessage = viewModel.sendMessage(message){
							messageIDToScroll = lastMessage.id
						}
					}else{
						viewModel.sendMessage(message)
					}
				}
				
//				codes.forEach {
//					if $0 == codes.last {
//						if let lastMessage = viewModel.sendMessage($0){
//							messageIDToScroll = lastMessage.id
//						}
//					}else{
//						viewModel.sendMessage($0)
//					}
//
//				}
				
			}else{
				viewModel.sendMessage("No library codes available. Contact administrator to arrange access.", rowType: .authmessage)
			}
		}
	}
	
	

}
struct LoginChatView_Previews: PreviewProvider {
	
	static let avatar = Avatar(name: "unknown",avatarArea: AvatarArea.changeSettings, imgString: "img1", questionCount: 0)
	
	static var previews: some View {
		NavigationView {
			LoginChatView(chat: LoginViewModel(avatar: avatar).chat)
				.environmentObject(LoginViewModel(avatar: avatar))
		}
	}
}
