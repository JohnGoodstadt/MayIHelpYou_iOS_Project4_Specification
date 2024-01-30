//
//  BalancedViewsViewModel.swift
//  Bridge
//
//  Created by John goodstadt on 04/03/2023.
//

import Foundation
import SwiftUI
import Resolver


//Matches Picker
let LESSONS_SELECTED:Int = 0
let PHRASE_LIBRARY_SELECTED:Int = 1
let PRACTICE_SELECTED:Int = 2
let FUTURE_SELECTED:Int = 3
let UNUSED:Int = 4

let WAIT_TIME_TARGET = 10 //seconds

//let P3:Int = 5



//enum cannotPlayReason {
//	case invalid
//	case waiting
//	case notAllPhrasesPlayed
//	case OK
//}

extension TabContentView {
	@MainActor class ViewModel: ObservableObject {
		
		//TODO: remove this
		@Published var mainTabs = ["Lessons","Phrases","Practice","Future"]
		
		@Published var selectedPhraseIndex: Int = 1
		@Published var selectedLessonNumber: Int = 1
		@Published var selectedConversationNumber: Int = 1
		@Published var selectedFutureIndex: Int = 1
		
		//TODO: choose 1 of below - pref index
		@Published var selectedChatNumber: Int = 1
		@Published var selectedChatIndex: Int = 0
//		@Published var currentQuestionNumber: Int = 1 //TODO: works for 1 chat - invalid when changing chat number
		
		//moved from QACarouselView to higher parent - helps to reset from conv1 to conv2
		@Published var questionState:QuestionState = .question
		@Published var QAIndex:Int = 0
		
		//@Published var myPhrases: [Phrase] = StarterPhrases
//		@Published var phraseLibraryTabs: [PhraseCategory] = StarterPhraseCategories
//		@Published var lessonsTabs: [Lesson] = StarterLessons
		
		@Published var AreaSelected:Int = LESSONS_SELECTED
		@Published var selectedPackIndex: Int = 1
		@Published var playedCount:Int = 0 //test
		@Published var showSettingsView: Bool = false //TODO: do we need this?
		@Published var showDebugView: Bool = false
		@Published var showIPadDebugView: Bool = false
		
		@Published var currentPhrase: Phrase = Phrase(title: "", additional: "")
		
		@Published var newDBUpdatesAvailable:Bool = false
		
		
		

		/// This method applies our remote config values to our UI

		
		func updateTabTitles(_ libraryCode:LibraryCode){
			self.mainTabs = [libraryCode.lessonTabTitle,libraryCode.phrasesTabTitle,libraryCode.practiceTabTitle]
		}
		
		func speakerFinished(with UID:String) {
			
			guard AreaSelected == LESSONS_SELECTED else {
				return
			}
			selectedPhraseIndex = selectedPhraseIndex //NOTE: does not refersh without this -- force refresh
		}
		//MOVED TO dataManager
		func getPhrase(with UID:String) -> Phrase? {
			
			guard AreaSelected == LESSONS_SELECTED else {
				return nil
			}
			return nil
		}
		
		func CurrentPhrase(_ phrase:Phrase){
			currentPhrase = phrase
		}
			
		func percentageOfPlayCount(_ count:Int) -> CGFloat {
			
			guard count < TARGET_AUDIO_COUNT else{
				return 1.0
			}
			
			return CGFloat(count) / CGFloat(TARGET_AUDIO_COUNT)
		}
		
		struct QSConfig: Codable {
			let intValue: Int
		}
		



		
	}
	
}
