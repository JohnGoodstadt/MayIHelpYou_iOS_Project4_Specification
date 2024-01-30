//
//  BalancedViewsViewModel.swift
//  Bridge
//
//  Created by John goodstadt on 04/03/2023.
//

import Foundation
import SwiftUI

extension DebugView {
	@MainActor class ViewModel: ObservableObject {
		@Published var bundlePhrases = StarterPhrases
		@Published var bundlePhraseCategories = StarterPhraseCategories
		@Published var bundleLessonTabs = StarterLessons
		
		@Published var myPhrases: [Phrase] = [
		 Phrase(
				phraseType: .introductions,
				sortNumber: 1,
				phrase:"Hello, welcome to Barlow's.",
				additional: "Making customers welcome with a smile and a greeting makes a great start to their shopping experience")

	 ]

		func buttonPushed(at index:Int) {
			
			let p = myPhrases[index]
			p.playedCount += 1
			myPhrases[index] = p
			
		}

	}
}
