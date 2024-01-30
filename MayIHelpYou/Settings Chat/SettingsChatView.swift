//
//
//  ChatView.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  


import SwiftUI
import AlertToast
import FirebaseAuth

struct SettingsChatView: View {
	@AppStorage(fb.spokenName) var appStoreSpokenName: String = ""
	@AppStorage(fb.libraryCode) var appStoreLibraryCode: String = ""
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject private var colorManager:ColorManager
	@EnvironmentObject var viewModel: SettingsViewModel
	@EnvironmentObject var dataManager:DataManager
	@StateObject var loginViewModel:LoginViewModel = LoginViewModel(avatar:  Avatar(name: "unknown",avatarArea: AvatarArea.loginFlow, subTitle: "", imgString: "img1"))
	
	let chat: SettingsChat
	
	@State private var text = ""
	@FocusState private var isFocused
	
	@State private var messageIDToScroll: UUID?
	@State private var showMessageToast = false
	@State private var toastMessage = ""
	@State private var showingLoginFullScreenSheet = false
	@State private var showingChatLoginFullScreenSheet = false
	@State private var showingChangeNotificationSheet = false
	
	@Binding var selectedTab: AppTabs
	
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
			//TODO: DO I need to do this here? see download everything
			if dataManager.spokenName.isEmpty {
				print("firebase call for spoken name")
				let spokenName = await readUserProperty(dataManager.libraryCode.code, property: fb.spokenName)
				viewModel.currentSpokenName = spokenName
			}else{
				viewModel.currentSpokenName = dataManager.spokenName
			}
			
			
			if let _ = Auth.auth().currentUser {
				viewModel.stateMachine = SettingsStateMachine()
				viewModel.resetToStart()
//				viewModel.sendMessages(.loggedin)
			}else{
				//TODO: not logged in
				viewModel.sendMessages(.notLoggedIn)
			}
		}
	}
		
	
	struct MessageView: View {
		//@EnvironmentObject private var dataManager:DataManager
		@EnvironmentObject private var colorManager:ColorManager
		
		
		var message:SettingsMessage
		var buttonPressed: (_ message: SettingsMessage) -> Void
		
		var body : some View {
			
			Group{
				let _ = message.type == .Received
				let _ = message.rowType
				//let isdS = message.rowType == .correct ||  message.rowType == .wrong1 ||  message.rowType == .wrong2  || message.rowType == .more ? colorManager.current.buttonBlue : Color(UIColor.systemBackground))
				
				let isSuccess = message.rowType == .changeSpokenNameSuccess ||  message.rowType == .checkedLibraryCode ? true : false
				
				
				if message.isButton {
					Button(action: {
						buttonPressed(message)
					}) {
						Text(message.text)
							.foregroundColor(.white)
							.padding(.horizontal)
							.padding(.vertical, 12)
					}
				}else{
					Text(message.text)
						.padding(.horizontal)
						.padding(.vertical, 12)
						.background(isSuccess ?  Color.green.opacity(0.9) : Color.black.opacity(0.2))
						.cornerRadius(13)
				}
			}//: GROUP
			.background(message.isButton ? colorManager.current.buttonBlue : Color(UIColor.systemBackground))
			.cornerRadius(13)
		}
	}
	func buttonPressed(_ message: SettingsMessage) {
		
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
			case .loginChat:
				showingChatLoginFullScreenSheet.toggle()
			case .invalidLibraryCode:
				print("\(message.rowType)")
				toastMessage = "Show Change Lesson Code page"
				showMessageToast.toggle()
			case .changeLibraryCode:
				print("\(message.rowType)")
				
				viewModel.stateMachine.transition(to: .changeLibrayCode)
				
				let authtoken = getAuthToken()
				printhires("valid codes for \(authtoken)")
				Task {
					var codes = await validCodesForUser(authtoken: authtoken)
					print(" authorized codes \(codes)")
					
					codes.removeAll { $0 == dataManager.libraryCode.code} //don't show current one.
					
					if codes.count == 1 {
						viewModel.sendMessage("Available code:\(codes.joined(separator: ","))")
						let code = codes.first ?? ""
						let message = SettingsMessage("Use:\(codes[0])",rowType: .checkedLibraryCode, isButton: true,tag: code)
						if let lastMessage = viewModel.sendMessage(message){
							messageIDToScroll = lastMessage.id
						}
						
					}else if codes.count > 1 {
						viewModel.sendMessage("Available codes:\(codes.joined(separator: ","))")
						codes.forEach {
							let code = $0
							let message = SettingsMessage("Use:\(code)",rowType: .checkedLibraryCode, isButton: true,tag: code)
							
							if $0 == codes.last {
								if let lastMessage = viewModel.sendMessage(message){
									messageIDToScroll = lastMessage.id
								}
							}else{
								viewModel.sendMessage(message)
							}
							
							
							
							
						}
					} //else no hits
					else{
						viewModel.sendMessage("No library codes available. Contact administrator to arrange access.", rowType: .authmessage)
					}
				}
				
				
				 
				
				
				
				
				//iewModel.changeLibraryCodeButtonPressed()
			case .changeSpokenName:
				print("\(message.rowType)")
				
				viewModel.stateMachine.transition(to: .changeSpokenName)
				viewModel.sendMessage("Type in the new spoken name")
				
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
			case .setMale, .setFemale:
				
				
				let previousVoice = dataManager.voiceName//if voice changes have to remove all cached files
				if  message.rowType == .setMale {
					dataManager.voiceName = GOOGLE_MALE_VOICE
					fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.voiceMale, value: true)
					toastMessage = "Voice set to male"
					if dataManager.voiceName != previousVoice {
						removeAllFilesBySuffix("mp3")//have to invlaidate saved mp3s - because user changed voice
					}
				}else{
					dataManager.voiceName = GOOGLE_FEMALE_VOICE
					fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.voiceMale, value: false)
					toastMessage = "Voice set to female"
					if dataManager.voiceName != previousVoice {
						removeAllFilesBySuffix("mp3")//have to invlaidate saved mp3s - because user changed voice
					}
				}
				showMessageToast.toggle()
		
				let sentence = "Hello \(dataManager.spokenName), Welcome to May I Help You."
				
				GoogleSpeechManager.shared.speak(text: sentence, voiceName: dataManager.voiceName) {  result in
					switch result {
						case .failure(let error):print("error \(error)")
							printhires(error.localizedDescription)
							toastMessage = "Error getting text voiced by google"
							showMessageToast.toggle()
						case .success(let mp3):
							self.audioManager.playAudio(mp3, UID: UUID().uuidString)
					}
				}
			case .checkedLibraryCode:
				
				Task {
					let libraryCode = message.tag
					
					await dataManager.downloadEverthingAsync(libraryCode: libraryCode)
					appStoreLibraryCode = libraryCode
					
					if let lastMessage = viewModel.sendMessage(.changedLibraryCodeSuccess) {
						messageIDToScroll = lastMessage.id
					}
				}
			case .changeNotification:
				showingChangeNotificationSheet.toggle()
				
			default:
				print("TODO TODO TODO \( message.rowType )")
		}
	}
	func textEntered(_ text:String) {
		
		
		printhires("\(viewModel.stateMachine)")
		
		
		switch viewModel.stateMachine.getCurrentState {
				
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
			case .changeSpokenName:
				let spokenName = text
				guard viewModel.isSpokenNameValid(spokenName) else {
					if let lastMessage = viewModel.sendMessage(.changeSpokenNameError) {
						messageIDToScroll = lastMessage.id
					}
					return
				}
				
				
				
				viewModel.stateMachine.transition(to: .changeSpokenNameSuccess)

				dataManager.spokenName = spokenName
				appStoreSpokenName = spokenName
				dataManager.removeCachedMP3sWithSpokenName()
				fbUpdateUserProperty(dataManager.libraryCode.code, property: fb.spokenName, value: spokenName)
				
				if let lastMessage = viewModel.sendMessage(.changeSpokenNameSuccess) {
					messageIDToScroll = lastMessage.id
				}
				

			default:
				print("textEntered not used")
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
				.toast(isPresenting: $showMessageToast){
					AlertToast(type: .regular, title: toastMessage)
				}
				.alert("Go to account settings", isPresented: $showingChangeNotificationSheet) {
					Button("Account", action: {
						selectedTab = .account
					})
					Button("Cancel", action: {})
				} message: {
					Text("You can set up or change your daily reminder in your Account settings")
				}
			}
		} //scrollview
		.if (colorScheme == .dark) { view in
			view.background(Color(red: 0.1, green: 0.1, blue: 0.1))
		}
		.if (colorScheme == .light) { view in
			view.background(Color(UIColor.systemBackground))
		}
		.fullScreenCover(isPresented: $showingLoginFullScreenSheet, onDismiss: {
			print("fullScreenCover onDismiss()")
			//updateDataManagerWithEvery thing() //TODO: Too Early?
			
		}, content: LoginView.init)
		.environmentObject(dataManager)
		.fullScreenCover(isPresented: $showingChatLoginFullScreenSheet) {
			LoginChatView(chat: loginViewModel.chat).environmentObject(loginViewModel)
		}
	}
	
	func toolbarView() -> some View {
		VStack {
			let height: CGFloat = 37
			HStack {
				TextField("Message...", text: $text)
					.textFieldStyle(.plain)   //dark mode
					.padding(.horizontal, 10)
					.frame(height: height)
//					.background(Color.white)
					.clipShape(RoundedRectangle(cornerRadius: 13))
					.focused($isFocused)
				
				Button(action: {
					if let newMessage = viewModel.userSendMessage(text) {
						textEntered(text)
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
	
	func sectionHeader(firstMessage message: SettingsMessage) -> some View {
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
} //:ALIChatView

struct ALIChatView_Previews: PreviewProvider {
	
	static let avatar = Avatar(name: "unknown",avatarArea: AvatarArea.changeSettings, imgString: "img1")
	@State static var selectedTab: AppTabs = AppTabs.home
	
	static var previews: some View {
		NavigationView {
			SettingsChatView(chat: SettingsViewModel(avatar: avatar).chat, selectedTab:$selectedTab)
				.environmentObject(SettingsViewModel(avatar: avatar))
		}
	}
}
