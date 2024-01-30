//
//
//  ChatView.swift
//  WhatsappUI
//
//  Created by Haipp on 26.06.21.
//  


import SwiftUI
import AlertToast

struct ChatView: View {
	
	@EnvironmentObject private var dataManager:DataManager
	@Environment(\.colorScheme) var colorScheme
	@EnvironmentObject private var colorManager:ColorManager
	
	
	var chat: PracticeChat
	
	@State private var text = ""
	@FocusState private var isFocused
	
	@State private var messageIDToScroll: UUID?
	
	let spacing: CGFloat = 10
	let minSpacing: CGFloat = 3
	let audioManager = AudioManager()
	@State private var showPlayErrorMessage = false
	@State private var currentPlayErrorMessage = ""
	@State private var showWrongExplanation = false
	@State private var currentWrongExplanation = ""
	//	@State private var showMessageToast = false
	//	@State private var toastMessage = ""
	var body: some View {
		
		VStack(spacing: 0) {
			
			
			GeometryReader { reader in
				getChatsView(viewWidth: reader.size.width)
					.onTapGesture {
						isFocused = false
					}
			}
			//			.padding(.bottom, 5)
			
#if DONT_COMPILE
			toolbarView()
#endif
		}
		.padding(.top, 1)
		.navigationBarItems(leading: navBarLeadingBtn(), trailing: navBarTrailingBtnEmpty())
		.navigationBarTitleDisplayMode(.inline)
		
	} //:BODY
	
	struct MessageView: View {
		
		@EnvironmentObject private var dataManager:DataManager
		@EnvironmentObject private var colorManager:ColorManager
		
		@State private var showMessageToast = false
		@State private var toastMessage = ""
		
		var message:ChatMessage
		var answerButtonPressed: (_ message: ChatMessage) -> Void
		let audioManager = AudioManager()
		
		var body : some View {
			Group { //or else no compile!!
				//TODO: probably dont need isReceived
				let _ = message.type == .Received
				let isCompleted = message.rowType == .complete
				let _ = message.rowType
				
				if message.isButton {
					Button(action: {
						answerButtonPressed(message)
					}) {
						Text(message.text)
							.foregroundColor(colorManager.current.baseForeground)
							.padding(.horizontal)
							.padding(.vertical, 12)
					}
				}else{
					Text(message.text)
						.if (message.rowType == .prompt) { view in
							view.font(Font.headline.weight(.bold))
						}
						.padding(.horizontal)
						.padding(.vertical, 12)
						.background(isCompleted ? Color.green.opacity(0.9) : Color.black.opacity(0.2))
						.cornerRadius(13)
						.onTapGesture {
							if message.rowType == .prompt {
								answerButtonPressed(message)
							}
						}
				}
			}//: GROUP
			
			.background(message.isButton ? colorManager.current.buttonBlue : Color(UIColor.systemBackground))
			.cornerRadius(13)
			.toast(isPresenting: $showMessageToast){
				AlertToast(type: .regular, title: toastMessage)
			}
		}
		
	} //:MESSAGE VIEW
	//	func playMessageButtonPressed(_ message: ChatMessage) {
	//		print("\(chat.avatar.voice)")
	//		GoogleSpeec hManager.shared.speak(text: message.text, voiceName: GOOGLE_MALE_VOICE) {  result in
	//			switch result {
	//				case .failure(let error):print("error \(error)")
	//					printhires(error.localizedDescription)
	////					toastMessage = "Error getting text voiced by google"
	////					showMessageToast.toggle()
	//				case .success(let mp3):
	//					self.audioManager.playAudio(mp3, UID:  UUID().uuidString)
	//			}
	//		}
	//	}
	func answerButtonPressed(_ message: ChatMessage) {
		
		
		if message.rowType == .prompt {
			print("cn:\(chat.conversationNumber) qn:\(message.questionNumber) \(fb.prompt)")
			
			let currentVoiceName = chat.avatar.voice.isNotEmpty ? chat.avatar.voice : GOOGLE_MALE_VOICE
			
			//let filename99 = "\(dataManager.libraryCode.code)_\(currentVoiceName)_\(fb.prompt)_\(chat.conversationNumber)_\(message.questionNumber)"
			
			let filename = makePracticeUID(code: dataManager.libraryCode.code,
												voiceName: currentVoiceName,
												type: fb.prompt,
												conversationNumber: chat.conversationNumber,
												questionNumber: message.questionNumber)
			
			let mp3 = getCachedAudioIfExists(UID: filename)
			if mp3.isEmpty {
				printhires("CALLING GOOGLE \(filename)")
				GoogleSpeechManager.shared.speak(text: message.text, voiceName: currentVoiceName) {  result in
					switch result {
						case .failure(let error):print("error \(error)")
							printhires(error.localizedDescription)
							//					toastMessage = "Error getting text voiced by google"
							//					showMessageToast.toggle()
						case .success(let mp3):
							self.audioManager.playAudio(mp3, UID:  UUID().uuidString)
							cacheMP3Locally(UID: filename,mp3)
							fbIncGoogleAPICount(code: dataManager.libraryCode.code, fieldName: fb.googleAPICallCount)
					}
				}
			}else{
				printhires("LOCAL MP3 \(filename)")
				audioManager.playAudio(mp3, UID: filename, caller_delegate: self)
				fbIncGoogleAPICount(code: dataManager.libraryCode.code, fieldName: fb.googleAPIAvoidedCount)
			}
			return
		}
		else if message.rowType == .restart
		{
			print("Do a restart")
			
			dataManager.resetChats() //memory
			
			fbResetAllUserChatState(code: dataManager.libraryCode.code, dataManager.chatQuestions)
			
			//save stats for each round of tries
			
			let attempts = chat.attempts + 1
			printhires("answerButtonPressed() attempts moving from \(chat.attempts) to \(attempts)")
			
			dataManager.incChatAttempts(chatUID: chat.id, attempts:attempts)// chat.attempts += 1
			fbUpdateUserPracticeStatProperty(code: dataManager.libraryCode.code, chatID: chat.conversationNumber, property: fb.attempts, value: attempts)
			
			return
		}
		
		guard !chat.completed else {
			return
		}
		
		guard message.questionNumber == chat.currentQuestionNumber else {
			//print(chat.currentQuestionNumber)
			return //dont allow earlier questions to be tapped
		}
		
		
		switch message.rowType {
			case .correct:
				print("cn:\(chat.conversationNumber) qn:\(message.questionNumber) \(fb.correctChoice)")
				//let filename = "\(fb.correctChoice)_\(chat.conversationNumber)_\(message.questionNumber)"
				
				let currentVoiceName = chat.avatar.voice.isNotEmpty ? chat.avatar.voice : GOOGLE_MALE_VOICE
				
				//let filename99 = "\(dataManager.libraryCode.code)_\(currentVoiceName)_\(fb.correct)_\(chat.conversationNumber)_\(message.questionNumber)"
				let filename = makePracticeUID(code: dataManager.libraryCode.code,
													voiceName: currentVoiceName,
													type: fb.correct,
													conversationNumber: chat.conversationNumber,
													questionNumber: message.questionNumber)
				
				let mp3 = getCachedAudioIfExists(UID: filename)
				if mp3.isEmpty {
					printhires("CALLING GOOGLE \(filename)")
					GoogleSpeechManager.shared.speak(text: message.text, voiceName: GOOGLE_MALE_VOICE) {  result in
						switch result {
							case .failure(let error):print("error \(error)")
								printhires(error.localizedDescription)
								showPlayErrorMessage.toggle()
								
							case .success(let mp3):
								audioManager.playAudio(mp3, UID: UUID().uuidString, caller_delegate: self)
								cacheMP3Locally(UID: filename,mp3)
								fbIncGoogleAPICount(code: dataManager.libraryCode.code, fieldName: fb.googleAPICallCount)
						}
					}
				}else{
					printhires("LOCAL MP3 \(filename)")
					audioManager.playAudio(mp3, UID: filename, caller_delegate: self)
					fbIncGoogleAPICount(code: dataManager.libraryCode.code, fieldName: fb.googleAPIAvoidedCount)
				}

				
				if !chat.completedCurrentQuestion {
					let messageID = dataManager.moveToCorrectAnswer(for: chat )
					messageIDToScroll = messageID
					
					dataManager.currentQuestionComplete(true, chat: chat)
					
					
					fbIncPracticeCorrectCount(code: dataManager.libraryCode.code, fieldName: fb.correctCount, chat.conversationNumber)
					fbUpdateChatAnswerAttemptCount(code: dataManager.libraryCode.code, fb.correctCount, attemptNumber: chat.attempts, chat.conversationNumber)
				}
				
				
				
			case .more:print("Do next if 1 available")
				//dataManager.currentQuestionComplete(true, chat: chat)
				//printhires("MORE:cqn:\(chat.currentQuestionNumber)")
				if chat.currentQuestionNumber < chat.avatar.questionCount {
					
					//printhires("+0cqn:\(chat.currentQuestionNumber)")
					
					let nextQuestionNumber = chat.currentQuestionNumber + 1
					let messageID = dataManager.moveToNextQuestion(for: chat )
					messageIDToScroll = messageID
					
					
					
					let prompt = dataManager.currentQuestionPrompt(for: chat, questionNumber: nextQuestionNumber)
					
					print("cn:\(chat.conversationNumber) qn:\(nextQuestionNumber) \(prompt)")
//
					let currentVoiceName = chat.avatar.voice.isNotEmpty ? chat.avatar.voice : GOOGLE_MALE_VOICE
//					let filename = "\(dataManager.libraryCode.code)_\(currentVoiceName)_\(fb.prompt)_\(chat.conversationNumber)_\(nextQuestionNumber)"
					//let filename99 = "\(dataManager.libraryCode.code)_\(currentVoiceName)_\(fb.prompt)_\(chat.conversationNumber)_\(nextQuestionNumber)"
					
					let filename = makePracticeUID(code: dataManager.libraryCode.code,
														voiceName: currentVoiceName,
														type: fb.prompt,
														conversationNumber: chat.conversationNumber,
														questionNumber: nextQuestionNumber)
					
					let mp3 = getCachedAudioIfExists(UID: filename)
					if mp3.isEmpty {
						printhires("CALLING GOOGLE \(filename)")
						GoogleSpeechManager.shared.speak(text: prompt, voiceName: currentVoiceName) {  result in
							switch result {
								case .failure(let error):print("error \(error)")
									printhires(error.localizedDescription)
									showPlayErrorMessage.toggle()
									
								case .success(let mp3):
									audioManager.playAudio(mp3, UID: UUID().uuidString, caller_delegate: self)
									cacheMP3Locally(UID: filename,mp3)
									fbIncGoogleAPICount(code: dataManager.libraryCode.code, fieldName: fb.googleAPICallCount)
							}
						}
					}else{
						printhires("LOCAL MP3 \(filename)")
						audioManager.playAudio(mp3, UID: filename, caller_delegate: self)
						fbIncGoogleAPICount(code: dataManager.libraryCode.code, fieldName: fb.googleAPIAvoidedCount)
					}
					

					
					
					dataManager.currentQuestionComplete(false, chat: chat)
				}else {//else no more question do complete
					//print("Completed series")
					dataManager.currentQuestionComplete(true, chat: chat)
				}
			case .wrong1:
				//				print("wrong1 Answer")
				
				
				
				if !chat.completedCurrentQuestion {
					dataManager.currentQuestionComplete(false, chat: chat)
					let messageID = dataManager.moveToWrong1Answer(for: chat)
					messageIDToScroll = messageID
					
					
					fbIncPracticeWrongCount(code: dataManager.libraryCode.code, fieldName: fb.mistakeCount, chat.conversationNumber)
					fbUpdateChatAnswerAttemptCount(code: dataManager.libraryCode.code, fb.wrongCount, attemptNumber: chat.attempts, chat.conversationNumber)
				}else{
					currentWrongExplanation = dataManager.wrong1Explanation(for: chat)
					showWrongExplanation.toggle()
				}
				
			case .wrong2: print("wrong2 Answer")
				
				if !chat.completedCurrentQuestion {
					dataManager.currentQuestionComplete(false, chat: chat)
					let messageID = dataManager.moveToWrong2Answer(for: chat)
					messageIDToScroll = messageID
					
					
					fbIncPracticeWrongCount(code: dataManager.libraryCode.code, fieldName: fb.mistakeCount, chat.conversationNumber)
					fbUpdateChatAnswerAttemptCount(code: dataManager.libraryCode.code, fb.wrongCount, attemptNumber: chat.attempts, chat.conversationNumber)
				}else{
					currentWrongExplanation = dataManager.wrong2Explanation(for: chat)
					showWrongExplanation.toggle()
				}
				
			default: print("Not correct or wrong!")
				if !chat.completedCurrentQuestion {
					dataManager.currentQuestionComplete(false, chat: chat)
					let text = "Cannot determine answer. Try again."
					if let newMessage = dataManager.sendMessage(text, in: chat) {
						messageIDToScroll = newMessage.id
					}
				}
		}
	}
	/*
	 1. get all messages for each section
	 */
	
	func getChatsView(viewWidth: CGFloat) -> some View {
		ScrollView {
			ScrollViewReader { scrollReader in
				LazyVGrid(columns: [GridItem(.flexible(minimum: 0))], spacing: 0, pinnedViews: [.sectionHeaders]) {
					
					let sectionMessages = dataManager.getSectionMessages(for: chat)
					ForEach(sectionMessages.indices, id: \.self) { i in
						let messages = sectionMessages[i]
						
						Section(header: sectionHeaderProgress(for: chat,firstMessage: messages.first!)) {
							ForEach(messages) { message in
								let isReceived = message.type == .Received
								
								HStack {
									ZStack {
										
										MessageView(message: message, answerButtonPressed: { message in
											self.answerButtonPressed(message)
											
										})
										
										
									}//: ZSTACK
									.frame(width: viewWidth * 0.7, alignment: isReceived ? .leading  : .trailing)
									.padding(.vertical, 5)
									
								} //:HSTACK
								.frame(maxWidth: .infinity, alignment: isReceived ? .leading  : .trailing)
								.id(message.id)
							}//:FOR EACH message
						} //: SECTION
					}
					.onChange(of: isFocused) { _ in
						if isFocused {
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
								withAnimation(.easeIn(duration: 0.5)) {
									scrollReader.scrollTo(chat.messages.last!.id, anchor: .bottom)
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
						//printhires("ChatView.onAppear()")
						DispatchQueue.main.async {
							print(chat)
							if !chat.messages.isEmpty {
								scrollReader.scrollTo(chat.messages.last!.id, anchor: .bottom)
							}
							
						}
					}
				}
				.padding(.horizontal)
			}
		} //scrollview
		//		.background(Color(UIColor.systemBackground))
		.if (colorScheme == .dark) { view in
			view.background(Color(red: 0.1, green: 0.1, blue: 0.1))
		}
		.if (colorScheme == .light) { view in
			view.background(Color(UIColor.systemBackground))
		}
		.toast(isPresenting: $showWrongExplanation, duration: 4){
			AlertToast(type: .regular, title: currentWrongExplanation)
		}
		.toast(isPresenting: $showPlayErrorMessage, duration: 4){
			AlertToast(type: .regular, title: currentWrongExplanation)
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
					if let newMessage = dataManager.sendMessage(text, in: chat) {
						text = ""
						printhires("999 scrolling to:\(newMessage.id.description.prefix(4))")
						messageIDToScroll = newMessage.id
						//print(" newMessage.id:\( newMessage.id)")
					}
				}) {
					Image(systemName: "paperplane.fill")
						.foregroundColor(colorManager.current.baseForeground)
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
	func sectionHeaderProgress(for chat: PracticeChat, firstMessage message: ChatMessage) -> some View {
		ZStack {
			
			
			
			let totalQuestionCount = chat.avatar.questionCount
			let _ = Color(hue: 0.587, saturation: 0.742, brightness: 0.924)
			Text("\(message.questionNumber) of \(totalQuestionCount)")
				.foregroundColor(colorScheme == .dark ? colorManager.current.foregroundDarkGrey : .black)
				.font(.system(size: 14, weight: .regular))
				.frame(width: 120)
				.padding(.vertical, 4)
				.background(Capsule().foregroundColor(colorScheme == .dark ? Color.black : colorManager.current.backgroundLightGrey))
		}
		.padding(.vertical, 5)
		.frame(maxWidth: .infinity)
	}
	func sectionHeaderDate(firstMessage message: ChatMessage) -> some View {
		ZStack {
			let _ = Color(hue: 0.587, saturation: 0.742, brightness: 0.924)
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
	func navBarTrailingBtnEmpty() -> some View {
		EmptyView()
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
}

extension ChatView: AudioLibraryDelegate999 {
	mutating func audioPlayerDidFinishPlaying999(UID: String) {
		print("ChatView.audioPlayerDidFinishPlaying999()")
	}
}

struct ChatView_Previews: PreviewProvider {
	
	static let dataManager = DataManager(true)
	static let chat:[PracticeChat] = dataManager.transformConversationsToChats(MinimalConversations)
	
	static var previews: some View {
		NavigationView {
			ChatView(chat: chat[0])
				.environmentObject(DataManager(true))
		}
	}
}
