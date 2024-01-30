//
//  ContentView.swift
//  May I Help You?
//
//  Created by John goodstadt on 16/03/2023.
//

import SwiftUI
import AlertToast
import AVFAudio
import FirebaseAuth


struct TabContentView: View  {
	
	@AppStorage(fb.libraryCode) var appStoreLibraryCode: String = ""
	@AppStorage(fb.spokenName) var appStoreSpokenName: String = ""
	@AppStorage(fb.voiceName) var appStoreVoiceName: String = ""
	
	@EnvironmentObject private var dataManager:DataManager
	@EnvironmentObject private var colorManager:ColorManager
	
	@StateObject private var viewModel = ViewModel()
	@StateObject var networkMonitor = NetworkMonitor()
	//TODO: clean up Avatar - not needed
	@StateObject var loginViewModel:LoginViewModel = LoginViewModel(avatar:  Avatar(name: "unknown",avatarArea: AvatarArea.practice, subTitle: "", imgString: "img1"))
	
	private var speechManager = SpeechManager()
	private var audioManager = AudioManager()
	
	@State private var additionalInfo:String = ""
	@State private var currentLink:Link = Link(title: "", link: "")
	
	@State private var showNotPlayedAllToast = false
	@State private var showWaitingToast = false
	@State private var showInvalidToast = false
	//	@State private var currentRelativeWaitTime = ""
	@State private var showingLoginFullScreenSheet = false
	@State private var showingLoadingScreenSheet = false
	@State private var showingNotYetImplemented = false
	@State private var showingPhraseCategoryLink = false
	@State private var showNetworkAlert = false
	@State private var showNoNetworkView = false
	@State private var showNavButtonTapped = false
	
	@State private var lessonProgressValue = 0
	

	@State private var showingAndroidProjectReminder = false //show on first load
	
	//https://stackoverflow.com/questions/76051540/swiftui-programatically-changing-the-tabview-focus
	@State var selectedTab = AppTabs.home
//	https://stackoverflow.com/questions/62504400/programmatically-change-to-another-tab-in-swiftui
//	@State private var tabSelection = 1
	
	//DEBUG
	let timerDEBUG = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
	
	init() {
		
		UITextField.appearance().clearButtonMode = .whileEditing
		
		
	}
	
	var body: some View {
		
		TabView (selection: $selectedTab) {
			
			//MARK: - HOME
			EmptyTabView(text: "Home View Project 4", debugText: "code:\(dataManager.lessonCode)")
				.tabItem {
					Label("Home", systemImage: "house.fill")
				}
				.tag(AppTabs.home)
			
			//MARK: - LESSONS as CARDS
			EmptyTabView(text: "Lessons View Project 4", debugText: "\(dataManager.lessons.count) lessons")
				.tabItem {
					Label("Lesson", systemImage: "list.bullet.clipboard.fill")
				}
				.tag(AppTabs.lesson)
			//MARK: - ALL PHRASES by CATEGORY
			EmptyTabView(text: "Phrases View Project 4", debugText: "\(dataManager.phrases.count) phrases")
				.tabItem {
					Label("Phrases", systemImage: "doc.plaintext.fill")
				}
				.tag(AppTabs.phrases)
			//MARK: - PRACTICE
			EmptyTabView(text: "Practice View Project 4", debugText: debugPratice())
				.tabItem {
					Label("Practice", systemImage: "chart.bar.doc.horizontal.fill")
				}
				.tag(AppTabs.practice)
			ControlPanelView()
				.tabItem {
					Label("Account", systemImage: "person.fill")
				}
				.tag(AppTabs.account)
			

		}//: TABVIEW
		.padding()
		
		.fullScreenCover(isPresented: $showingLoginFullScreenSheet,onDismiss: {
			//for now Jan2024 loading of data comes in login itself not afterwards also (Double loading)
			showingLoadingScreenSheet = true
		}) {
			LoginChatView(chat: loginViewModel.chat).environmentObject(loginViewModel)
		}
		.environmentObject(dataManager)
		.fullScreenCover(isPresented: $showingLoadingScreenSheet,onDismiss: {
			showingAndroidProjectReminder.toggle()
			
		}) {
			LoadEverythingView(libraryCode: appStoreLibraryCode)
		}
		.environmentObject(dataManager)
		.onAppear(){
			
			guard Thread.current.isNotRunningXCTest else { return }
			
			
			
			UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(colorManager.current.segmentSelectedTintColor)
			UISegmentedControl.appearance().backgroundColor = UIColor(colorManager.current.segmentBackgroundColor)
			
			//CHeck if user has loggd on before
			if let _ = Auth.auth().currentUser {
				

				guard networkMonitor.isConnected else{
					showNoNetworkView.toggle()
					return
				}
				
				print("TabContentView.onAppear() spokenname:\(dataManager.spokenName) voice:\(dataManager.voiceName)")
				
				showingLoadingScreenSheet = true
				
			}else{
				//User Not logged on - so force login screen
				showingLoginFullScreenSheet = true
			}
			

			
		}//: ONAPPEAR
		.onChange(of: networkMonitor.isConnected) { connection in //after load
			showNetworkAlert = connection == false
		}
		.alert ("Network connection seems to be offline", isPresented: $showNetworkAlert){}
		
	}
	func debugPratice() -> String {
		
		var total = 0
		dataManager.chatQuestions.forEach{
			total += $0.messageQ.count
		}
		
		return "\(dataManager.chatQuestions.count) conversation(s), \(total) questions"
	}

}



extension TabContentView: SpeechManagerDelegate {
	func speakerDidFinishSpeaking(phraseUID: String) {
		print("ContentView.Ended Speaking PhrasesOrLessonsSelected:\(viewModel.AreaSelected) selectedPackIndex:\(viewModel.selectedPackIndex) ")
		
		fsUpdatePlayedCount(dataManager.libraryCode.code, phraseUID)
		
		guard viewModel.AreaSelected == LESSONS_SELECTED else { return 	}
		
		
		dataManager.incPlayedCount(phraseUID)
		viewModel.speakerFinished(with: phraseUID)
		
		if dataManager.percentageOfLessonPlayCyclesCompleted(viewModel.selectedLessonNumber) >= 1.0 {
			print("SETTING LESSON \(viewModel.selectedLessonNumber) COMPLETED")
			dataManager.setLessonComplete(viewModel.selectedLessonNumber)
		}else{
			//			print("LESSON \(viewModel.selectedLessonIndex) === NOT === COMPLETE % is:\( viewModel.percentageOfLessonPlayCyclesCompleted())")
			print("LESSON SelectedLessonNumber: \(viewModel.selectedLessonNumber) ")
		}
	}
}
extension TabContentView: AudioLibraryDelegate999 {
	
	mutating func audioPlayerDidFinishPlaying999(UID: String) {
		speakerDidFinishSpeaking(phraseUID: UID)
	}
}
struct TabContentView_Previews: PreviewProvider {
	@State static var viewModel = TabContentView.ViewModel()
	
	static var previews: some View {
		TabContentView()
			.environmentObject(DataManager(true))
			.environmentObject(ColorManager())
			.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
		
		TabContentView()
			.preferredColorScheme(.dark)
			.environmentObject(DataManager(true))
			.environmentObject(ColorManager())
			.previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
		
	}
}




